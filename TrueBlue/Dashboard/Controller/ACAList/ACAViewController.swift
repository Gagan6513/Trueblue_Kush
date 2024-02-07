//
//  ACAViewController.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 22/12/23.
//

import UIKit
import Applio

class ACAViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    
    var arrACAList = [ACAList]()
    var startDate = ""
    var endDate = ""
    var dateFormater = DateFormatter()
    let refreshControl = UIRefreshControl()
    var isFromFilter = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.btnFilter.layoutIfNeeded()
        self.btnFilter.layoutSubviews()
        self.btnFilter.layer.cornerRadius = self.btnFilter.layer.frame.width / 2
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnSearch(_ sender: Any) {
        self.txtSearch.resignFirstResponder()
    }
    
    @IBAction func btnFilter(_ sender: Any) {
        let ctrl = self.storyboard?.instantiateViewController(withIdentifier: "ACADataFilterViewController") as! ACADataFilterViewController
        ctrl.modalPresentationStyle = .overFullScreen
        ctrl.view.isOpaque = false
        ctrl.dateClosure = {fromdate, todate in
            self.isFromFilter = true
            self.startDate = fromdate
            self.endDate = todate
            self.getACAList()
        }
        self.present(ctrl, animated: false)
    }
    
    func setupTableView() {
        self.txtSearch.delegate = self
        
//        self.btnFilter.isHidden = true
        self.tableView.isHidden = true
        
        self.dateFormater.dateFormat = "dd-MM-YYYY"

        self.tableView.contentInset = UIEdgeInsets(top: 14, left: 0, bottom: 100, right: 0)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(for: "AcaTVC")
        
        self.startDate = self.dateFormater.string(from: Date().startOfMonth())
        self.endDate = self.dateFormater.string(from: Date().endOfMonth())
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableView.addSubview(self.refreshControl) // not required when using UITableViewController
        
        self.getACAList()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.getACAList(isProgressShow: false)
    }
}

extension ACAViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.getACAList()
    }
    
}

extension ACAViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !self.isFromFilter {
            self.arrACAList.count == 0 ? tableView.setBackgroundView(msg: .aca_without_filter_empty) :
                                         tableView.removeBackgroundView()
        } else {
            self.arrACAList.count == 0 ? tableView.setBackgroundView(msg: "ACA not found from \(self.startDate) To \(self.endDate).") :
                                         tableView.removeBackgroundView()
        }
        
        
        return self.arrACAList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AcaTVC") as? AcaTVC else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.setupDetails(data: self.arrACAList[indexPath.row])
        return cell
    }
}

extension ACAViewController {
    
    func getACAList(isProgressShow: Bool = true) {
        
        if isProgressShow {
            CommonObject().showProgress()
        }
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.getACAList)!
        webService.method = .post
        
        var param = [String: Any]()
        if self.txtSearch.text == "" || self.isFromFilter {
            param["fromDate"] = self.startDate
            param["toDate"] = self.endDate
        } else {
            param["aca_id"] = self.txtSearch.text
        }
        
        webService.parameters = param
        
        /* API CALLS */
        WebService.shared.performMultipartWebService(model: webService, imageData: []) { [weak self] responseData, error in
            guard let self else { return }
            
            CommonObject().stopProgress()
            self.refreshControl.endRefreshing()
            self.tableView.isHidden = false

            if let error {
                /* API ERROR */
                showAlert(title: "Error!", messsage: "\(error)")
                return
            }
            
            /* CONVERT JSON DATA TO MODEL */
            if let data = responseData?.convertData(ACAListModel.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? ACAListModel {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    self.arrACAList = data.data?.response ?? []
                    self.tableView.reloadData()
                    self.isFromFilter = false
                }
            }
        }
//        self.isFromFilter = false
    }
    
}
