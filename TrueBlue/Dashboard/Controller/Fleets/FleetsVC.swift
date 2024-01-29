//
//  FleetsVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 29/01/24.
//

import UIKit

class FleetsVC: UIViewController {
    
    var arrAvailVehicles = [AccidentMaintenance]()

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var currentPage = 1
    var isPaginationAvailable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        
        NotificationCenter.default.addObserver(forName: .AccidentDetails, object: nil, queue: nil, using: { [weak self] _ in
            guard let self else { return }
            self.getAvaiableVehicleList()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.getAvaiableVehicleList()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnAdd(_ sender: Any) {

        let ctrl = UIStoryboard(name: "AccidentManagement", bundle: nil).instantiateViewController(withIdentifier: "AccidentManagementVC") as! AccidentManagementVC
        ctrl.modalPresentationStyle = .overFullScreen
        self.present(ctrl, animated: true)
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(for: "FleetsTVC")
    }
    
}


extension FleetsVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrAvailVehicles.count != 0 {
            tableView.removeBackgroundView()
            return self.arrAvailVehicles.count
        }
        tableView.setBackgroundView(msg: .vehicle_empty)
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FleetsTVC") as? FleetsTVC else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.setupDetails(data: self.arrAvailVehicles[indexPath.row])
        
        cell.refClicked = { [weak self] in
            guard let self else { return }
            self.openReferance(data: self.arrAvailVehicles[indexPath.row])
        }
        
        cell.serviceClicked = { [weak self] in
            guard let self else { return }
            self.openService(data: self.arrAvailVehicles[indexPath.row])
        }
        
        cell.btnReferanceClicked = { [weak self] in
            guard let self else { return }
            self.openFleetReferance(data: self.arrAvailVehicles[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = self.arrAvailVehicles.count - 3
        if indexPath.row == lastItem {
            if isPaginationAvailable {
                self.currentPage += 1
                self.getAvaiableVehicleList()
            }
        }
    }
    
    func openReferance(data: AccidentMaintenance) {
        let ctrl = UIStoryboard(name: "AccidentManagement", bundle: nil).instantiateViewController(withIdentifier: "ViewReferenceVC") as! ViewReferenceVC
        ctrl.modalPresentationStyle = .overFullScreen
        ctrl.vehicleDetails = data
        self.present(ctrl, animated: true)
    }
    
    func openFleetReferance(data: AccidentMaintenance) {
        let ctrl = UIStoryboard(name: "AccidentManagement", bundle: nil).instantiateViewController(withIdentifier: "FleetReferenceVC") as! FleetReferenceVC
        ctrl.modalPresentationStyle = .overFullScreen
        ctrl.vehicleDetails = data
        self.present(ctrl, animated: true)
    }
    
    func openService(data: AccidentMaintenance) {
        let ctrl = UIStoryboard(name: "AccidentManagement", bundle: nil).instantiateViewController(withIdentifier: "ServicesHistoryVC") as! ServicesHistoryVC
        ctrl.modalPresentationStyle = .overFullScreen
        ctrl.vehicleDetails = data
        self.present(ctrl, animated: true)
    }
 
}

extension FleetsVC {
    
    func getAvaiableVehicleList() {
        CommonObject().showProgress()
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.getFleetsList)!
        webService.method = .post
        
        var param = [String: Any]()
        param["limitRecord"] = "10"
        param["pageNo"] = self.currentPage
        
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
            if let data = responseData?.convertData(AccidentMaintenanceModel.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? AccidentMaintenanceModel {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    
                    if let dataList = data.data?.response {
                        self.isPaginationAvailable = !(dataList.count < 10)
                        self.arrAvailVehicles.append(contentsOf: dataList)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
}

