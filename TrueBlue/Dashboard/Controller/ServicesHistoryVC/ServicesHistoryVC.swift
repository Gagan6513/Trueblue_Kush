//
//  ServicesHistoryVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 26/01/24.
//

import UIKit
import Applio

class ServicesHistoryVC: UIViewController {

    @IBOutlet weak var carModelLabel: UILabel!
    @IBOutlet weak var carIdLabel: UILabel!
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var vehicleDetails: AccidentMaintenance?
    var arrReferace: [AccidentService] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableview()
        self.setupDetails()
        DispatchQueue.main.async {
            self.getRefList()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func setupTableview() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(for: "ServiceTVC")
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        let ctrl = UIStoryboard(name: "AccidentManagement", bundle: nil).instantiateViewController(withIdentifier: "FleetServiceVC") as! FleetServiceVC
        ctrl.modalPresentationStyle = .overFullScreen
        ctrl.isFromView = false
        ctrl.regoNumber = self.vehicleDetails?.registration_no ?? ""
        self.present(ctrl, animated: true)
    }
    
    func setupDetails() {
        if let data = vehicleDetails {
            self.carNameLabel.text = "\(data.vehicle_make ?? "") \(data.vehicle_model ?? "") (\((data.yearof_manufacture ?? "").date(convetedFormate: .ddmmyyyy)))"
            self.carIdLabel.text = data.vehicle_category
            self.carModelLabel.text = (data.vehicle_make ?? "")
            if let url = URL(string: data.fleet_image ?? "") {
                self.carImage.sd_setImage(with: url)
            }
        }
        
        
        NotificationCenter.default.addObserver(forName: .refreshFleetList, object: nil, queue: nil, using: { [weak self] _ in
            guard let self else { return }
            self.getRefList()
        })
        
    }
}

extension ServicesHistoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrReferace.count != 0 {
            tableView.removeBackgroundView()
            return self.arrReferace.count
        }
        tableView.setBackgroundView(msg: .service_list_empty)
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceTVC") as? ServiceTVC else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.setupDetails(data: self.arrReferace[indexPath.row])
        cell.btnViewClicked = { [weak self] status in
            guard let self else { return }
            self.showDetiails(isFromView: status, data: self.arrReferace[indexPath.row])
        }
        return cell
    }
    
    func showDetiails(isFromView: Bool, data: AccidentService) {
        let ctrl = UIStoryboard(name: "AccidentManagement", bundle: nil).instantiateViewController(withIdentifier: "FleetServiceVC") as! FleetServiceVC
        ctrl.modalPresentationStyle = .overFullScreen
        ctrl.serviceData = data
        ctrl.isFromView = isFromView
        self.present(ctrl, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
    }
    
}

extension ServicesHistoryVC {
    
    func getRefList() {
        CommonObject().showProgress()
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.getRegoServiceHistory)!
        webService.method = .post
        
        var param = [String: Any]()
//        param["referenceFor"] = "rego"
        param["vehicle_id"] = vehicleDetails?.id
        
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
            if let data = responseData?.convertData(AccidentServiceModel.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? AccidentServiceModel {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    self.arrReferace = (data.data?.response ?? [])
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

