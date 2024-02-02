//
//  ViewReferenceVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 22/01/24.
//

import UIKit
import Applio

class ViewReferenceVC: UIViewController {

    @IBOutlet weak var carModelLabel: UILabel!
    @IBOutlet weak var carIdLabel: UILabel!
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var vehicleDetails: AccidentMaintenance?
    var arrReferace: [AccidentReferance] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableview()
        self.setupDetails()
        
        NotificationCenter.default.addObserver(forName: .AccidentDetails, object: nil, queue: nil, using: { [weak self] _ in
            guard let self else { return }
            self.getRefList()
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getRefList()
    }
    
    @IBAction func btnAddAccident(_ sender: Any) {
        let ctrl = UIStoryboard(name: "AccidentManagement", bundle: nil).instantiateViewController(withIdentifier: "AccidentManagementVC") as! AccidentManagementVC
        ctrl.modalPresentationStyle = .overFullScreen
        ctrl.regoNumber = self.vehicleDetails?.registration_no ?? ""
        self.present(ctrl, animated: true)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func setupTableview() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(for: "ViewReferenceTVC")
    }
    
    func setupDetails() {
        if let data = vehicleDetails {
            self.carNameLabel.text = "\(data.vehicle_make ?? "") \(data.vehicle_model ?? "") (\(data.yearof_manufacture ?? ""))"
            self.carIdLabel.text = data.vehicle_category
            self.carModelLabel.text = (data.vehicle_make ?? "")
            if let url = URL(string: data.fleet_image ?? "") {
                self.carImage.sd_setImage(with: url)
            }
        }
    }
}

extension ViewReferenceVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrReferace.count != 0 {
            tableView.removeBackgroundView()
            return self.arrReferace.count
        }
        tableView.setBackgroundView(msg: .referance_list_empty)
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ViewReferenceTVC") as? ViewReferenceTVC else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.setupDetails(data: self.arrReferace[indexPath.row])
        cell.detailsButtonClicked = { [weak self] in
            guard let self else { return }
            let ctrl = UIStoryboard(name: "AccidentManagement", bundle: nil).instantiateViewController(withIdentifier: "AccidentManagementVC") as! AccidentManagementVC
            ctrl.modalPresentationStyle = .overFullScreen
            ctrl.accidentData = self.arrReferace[indexPath.row]
            self.present(ctrl, animated: true)
        }
        
        cell.viewButtonClicked = { [weak self] in
            guard let self else { return }
            let ctrl = UIStoryboard(name: "AccidentManagement", bundle: nil).instantiateViewController(withIdentifier: "AccidentManagementVC") as! AccidentManagementVC
            ctrl.modalPresentationStyle = .overFullScreen
            ctrl.accidentData = self.arrReferace[indexPath.row]
            ctrl.isFromView = true
            self.present(ctrl, animated: true)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
    }
    
}

extension ViewReferenceVC {
    
    func getRefList() {
        CommonObject().showProgress()
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.accidentBookings)!
        webService.method = .post
        
        var param = [String: Any]()
        param["referenceFor"] = "rego"
        param["regoId"] = vehicleDetails?.id
        
        webService.parameters = param
        
        /* API CALLS */
        WebService.shared.performMultipartWebService(model: webService, imageData: []) { [weak self] responseData, error in
            guard let self else { return }
            
            CommonObject().stopProgress()
            self.tableView.isHidden = false
            
            if let error {
                /* API ERROR */
                showAlert(title: "Error!", messsage: "\(error)")
                return
            }
            
            /* CONVERT JSON DATA TO MODEL */
            if let data = responseData?.convertData(AccidentReferanceModel.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? AccidentReferanceModel {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    print("Before Filter Count", (data.data?.response ?? []).count)
                    self.arrReferace = (data.data?.response ?? []).filter({ ($0.is_accident_ref ?? "") == "1" })
                    print("After Filter Count", self.arrReferace.count)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

