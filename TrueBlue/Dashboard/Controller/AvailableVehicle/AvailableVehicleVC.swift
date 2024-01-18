//
//  AvailableVehicleVC.swift
//  TrueBlue
//
//  Created by Ashwani Kumar on 30/08/21.
//

import UIKit
import Alamofire
import Applio

class AvailableVehicleVC: UIViewController {
    
    var arrAvailVehicles = [AvailableVehicle]()
    
    @IBOutlet weak var tblAvailVehicles: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.getAvaiableVehicleList()
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupTableView() {
        self.tblAvailVehicles.delegate = self
        self.tblAvailVehicles.dataSource = self
        self.tblAvailVehicles.registerNib(for: "AvailableVehicleTVC")
    }
    
}


extension AvailableVehicleVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrAvailVehicles.count != 0 {
            tableView.removeBackgroundView()
            return self.arrAvailVehicles.count
        }
        tableView.setBackgroundView(msg: .vehicle_empty)
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AvailableVehicleTVC") as? AvailableVehicleTVC else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.setupDetails(data: self.arrAvailVehicles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension AvailableVehicleVC {
    
    func getAvaiableVehicleList() {
        CommonObject().showProgress()
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.AVAILABLE_VEHICLE_LIST)!
        webService.method = .post
        
        let application_id = CommonObject.sharedInstance.currentReferenceId.replacingOccurrences(of: "IV000", with: "")
        
        var param = [String: Any]()
        param["notesForId"] = application_id
        param["notesFor"] = "all"
        
        webService.parameters = param
        
        /* API CALLS */
        WebService.shared.performMultipartWebService(model: webService, imageData: []) { [weak self] responseData, error in
            guard let self else { return }
            
            CommonObject().stopProgress()
            self.tblAvailVehicles.isHidden = false
            
            if let error {
                /* API ERROR */
                showAlert(title: "Error!", messsage: "\(error)")
                return
            }
            
            /* CONVERT JSON DATA TO MODEL */
            if let data = responseData?.convertData(AvailableVehicleModel.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? AvailableVehicleModel {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    self.arrAvailVehicles = data.data ?? [AvailableVehicle]()
                    self.tblAvailVehicles.reloadData()
                    
                }
            }
        }
    }
    
}
