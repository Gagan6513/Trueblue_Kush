//
//  CollectionsVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 27/02/24.
//

import UIKit

class DeliveryCollectionsVC: UIViewController {
    
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var currentPage = 0
    var isSearchEnable = false
    var isPaginationAvailable = false
    var arrNavigation = [["title": "All", "icon": "", "type": "All", "count": "0"],
                         ["title": "Collection", "icon": "ic_collection_tab", "type": "Collection", "count": "0"],
                         ["title": "Deliveries", "icon": "ic_delivery_tab", "type": "Deliveries", "count": "0"],
                         ["title": "Swap", "icon": "ic_swap_tab", "type": "Swap", "count": "0"]]
    var selectedFilter = "All"
    var search = ""
    var arrAvailVehicles = [AccidentMaintenance]()
    var arrFilteredVehicles = [AccidentMaintenance]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        
        NotificationCenter.default.addObserver(forName: .AccidentDetails, object: nil, queue: nil, using: { [weak self] _ in
            guard let self else { return }
            self.refreshPage()
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
        self.tableView.registerNib(for: "DeliveryCollectionsTVC")
        
        self.filterCollectionView.delegate = self
        self.filterCollectionView.dataSource = self
    }
    
}

extension DeliveryCollectionsVC: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.search = ""
        DispatchQueue.main.async {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.refreshPage()
    }
    
    func refreshPage() {
        self.arrFilteredVehicles = []
        self.arrAvailVehicles = []
        self.currentPage = 0
        self.getAvaiableVehicleList()
    }
}

extension DeliveryCollectionsVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrFilteredVehicles.count != 0 {
            tableView.removeBackgroundView()
            return self.arrFilteredVehicles.count
        }
        tableView.setBackgroundView(msg: .fleets_empty)
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryCollectionsTVC") as? DeliveryCollectionsTVC else { return UITableViewCell() }
        cell.selectionStyle = .none
        
//        if let data = self.arrFilteredVehicles[safe: indexPath.row] {
//            cell.setupDetails(data: data)
//            
//            cell.refClicked = { [weak self] in
//                guard let self else { return }
//                self.openReferance(data: data)
//            }
//            
//            cell.serviceClicked = { [weak self] in
//                guard let self else { return }
//                self.openService(data: data)
//            }
//            
//            cell.btnReferanceClicked = { [weak self] in
//                guard let self else { return }
//                self.openFleetReferance(data: data)
//            }
//        }
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = self.arrFilteredVehicles.count - 1
        if indexPath.row == lastItem {
            if isPaginationAvailable && search.isEmpty {
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

extension DeliveryCollectionsVC {
    
    func getAvaiableVehicleList() {
        if self.currentPage == 0 {
            CommonObject().showProgress()
        }
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.getFleetsList)!
        webService.method = .post
        
        var param = [String: Any]()
        param["limitRecord"] = "\(numberOfItemPerPage)"
        param["pageNo"] = "\(numberOfItemPerPage * (self.currentPage))"
        
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
                    
                    if let all = self.arrNavigation.firstIndex(where: { $0["title"] == "All" }) {
                        if let count = data.data?.total_records?.total_count {
                            self.arrNavigation[all]["count"] = count
                        }
                    }
                    
                    if let available = self.arrNavigation.firstIndex(where: { $0["title"] == "Available" }) {
                        if let count = data.data?.total_records?.available_count {
                            self.arrNavigation[available]["count"] = count
                        }
                    }
                    
                    if let hire = self.arrNavigation.firstIndex(where: { $0["title"] == "On Hire" }) {
                        if let count = data.data?.total_records?.hired_count {
                            self.arrNavigation[hire]["count"] = count
                        }
                    }
                    
                    if let maintenance = self.arrNavigation.firstIndex(where: { $0["title"] == "Maintenance" }) {
                        if let count = data.data?.total_records?.maintenance_count {
                            self.arrNavigation[maintenance]["count"] = count
                        }
                    }
                    
                    self.filterCollectionView.reloadData()
                    
                    
                    if let dataList = data.data?.response {
                        self.isPaginationAvailable = !(dataList.count < numberOfItemPerPage)
                        self.arrAvailVehicles.append(contentsOf: dataList)
//                        self.arrFilteredVehicles.append(contentsOf: dataList)
                        self.filterData()
                    }
                }
            }
        }
    }
    
    func filterData() {
        
        if selectedFilter == "All" {
            
            self.arrFilteredVehicles = self.arrAvailVehicles
            
        } else if selectedFilter == "Available" {
            
            self.arrFilteredVehicles = self.arrAvailVehicles.filter({ $0.status == "Active"
                && ($0.fleet_status == "Returned" || $0.fleet_status == "Free")})

        } else if selectedFilter == "On Hire" {
            
            self.arrFilteredVehicles = self.arrAvailVehicles.filter({ $0.status == "Active"
                                                                    && ($0.fleet_status == "Hired") })
            
        } else if selectedFilter == "Maintenance" {
            
            self.arrFilteredVehicles = self.arrAvailVehicles.filter({ $0.status == "Maintenance" })
        }
        
//        self.arrFilteredVehicles = self.arrFilteredVehicles.filter({ search.isEmpty ? true :
//               (($0.vehicle_make?.lowercased().contains(search.lowercased()) ?? false)
//            || ($0.vehicle_model?.lowercased().contains(search.lowercased()) ?? false))
//            || ($0.registration_no?.lowercased().contains(search.lowercased()) ?? false)
//        })

        if self.isPaginationAvailable && search.isEmpty {
            if self.arrFilteredVehicles.count == 0 {
                self.currentPage += 1
                self.getAvaiableVehicleList()
            }
        }
        
        self.tableView.reloadData()
    }
    
}

extension DeliveryCollectionsVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrNavigation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventDetailsNavigation", for: indexPath) as? EventDetailsNavigation else { return UICollectionViewCell() }
            
        cell.lblTitle.text = "\(self.arrNavigation[indexPath.row]["title"] ?? "") (\(self.arrNavigation[indexPath.row]["count"] ?? ""))"
        cell.imgIcon.isHidden = (self.arrNavigation[indexPath.row]["icon"] ?? "") == ""
        if (self.arrNavigation[indexPath.row]["icon"] ?? "") != "" {
            cell.imgIcon.image = UIImage(named: self.arrNavigation[indexPath.row]["icon"] ?? "")
        }
        
        if selectedFilter == (self.arrNavigation[indexPath.row]["type"] ?? "") {
            cell.imgIcon.tintColor = .black
            cell.lblTitle.textColor = .black
            
            if selectedFilter == "All" {
                cell.bgView.backgroundColor = .darkGray
                cell.imgIcon.tintColor = .white
                cell.lblTitle.textColor = .white
            } else {
                cell.bgView.backgroundColor = UIColor(named: "FAD9A9")
            }
            
        } else {
            cell.imgIcon.tintColor = .black
            cell.lblTitle.textColor = .black
            cell.bgView.backgroundColor = .clear
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 4), height: collectionView.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.search = ""
        self.currentPage = 0
        self.isPaginationAvailable = false
        self.arrAvailVehicles = []
        self.arrFilteredVehicles = []
        self.selectedFilter = (self.arrNavigation[indexPath.row]["title"] ?? "")
        
        self.filterCollectionView.reloadData()
        self.getAvaiableVehicleList()
    }
}
