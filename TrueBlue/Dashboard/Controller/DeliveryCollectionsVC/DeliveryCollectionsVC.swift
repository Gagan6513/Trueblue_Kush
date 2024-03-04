//
//  CollectionsVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 27/02/24.
//

import UIKit

class DeliveryCollectionsVC: UIViewController {
    
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnFilter: UIButton!
    
    var currentPage = 0
    var isSearchEnable = false
    var isPaginationAvailable = false
    var arrNavigation = [["title": "All", "icon": "", "type": "all", "count": "0"],
                         ["title": "Collection", "icon": "ic_collection_tab", "type": "returned", "count": "0"],
                         ["title": "Deliveries", "icon": "ic_delivery_tab", "type": "hired", "count": "0"],
                         /*["title": "Swap", "icon": "ic_swap_tab", "type": "swapped", "count": "0"]*/]
    
    var selectedFilter = "All"
    var selectedFilterType = "all"
    var search = ""
    var arrAvailVehicles = [CollectionDeliveryDataList]()
    var arrFilteredVehicles = [CollectionDeliveryDataList]()
    var startDate = ""
    var endDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.navigationTitle.text = self.selectedFilter
        NotificationCenter.default.addObserver(forName: .AccidentDetails, object: nil, queue: nil, using: { [weak self] _ in
            guard let self else { return }
            self.refreshPage()
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.btnFilter.layoutIfNeeded()
        self.btnFilter.layoutSubviews()
        self.btnFilter.layer.cornerRadius = self.btnFilter.layer.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCollectionListList()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnSearch(_ sender: Any) {
        self.txtSearch.resignFirstResponder()

    }
    
    @IBAction func btnFilter(_ sender: Any) {
        let ctrl = UIStoryboard(name: "DashboardPhone", bundle: nil).instantiateViewController(withIdentifier: "ACADataFilterViewController") as! ACADataFilterViewController
        ctrl.modalPresentationStyle = .overFullScreen
        ctrl.view.isOpaque = false
        ctrl.startDate = self.startDate
        ctrl.endDate = self.endDate

        ctrl.dateClosure = {fromdate, todate in
            self.startDate = fromdate
            self.endDate = todate
            self.getCollectionListList()
        }
        self.present(ctrl, animated: false)
    }
    
    func setupTableView() {
        self.txtSearch.delegate = self

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(for: "DeliveryCollectionsTVC")
        
        self.filterCollectionView.delegate = self
        self.filterCollectionView.dataSource = self
    }
    
}

extension DeliveryCollectionsVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        search = (string.isEmpty ? String(search.dropLast()) : (textField.text! + string)).lowercased()
        
//        if search == "" {
//            self.arrFilteredVehicles = self.arrAvailVehicles
//        } else {
//            self.arrFilteredVehicles = self.arrAvailVehicles.filter({ ($0.owner_firstname?.lowercased().contains(search) ?? false) || ($0.owner_lastname?.lowercased().contains(search) ?? false) })
//        }
//
//        self.tableView.reloadData()
        return true
    }
        
    
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
        self.getCollectionListList()
    }
}

extension DeliveryCollectionsVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrFilteredVehicles.count != 0 {
            tableView.removeBackgroundView()
            return self.arrFilteredVehicles.count
        }
        tableView.setBackgroundView(msg: .records_empty)
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryCollectionsTVC") as? DeliveryCollectionsTVC else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        if let data = self.arrFilteredVehicles[safe: indexPath.row] {
            
            if self.selectedFilterType.lowercased() == "returned" {
                cell.setCollectionData(data: data)
            } else if self.selectedFilterType.lowercased() == "hired" {
                cell.setDeliveredData(data: data)
            } else {
                cell.setupDetails(data: data)
            }
            
            cell.clickedRefButton = { [weak self] in
                guard let self else { return }
                self.openReferance(data: data)
            }
            
            cell.clickedRegoButton = { [weak self] in
                guard let self else { return }
                self.openFleetReferance(data: data)
            }
            
            cell.clickedNextButton = { [weak self] in
                guard let self else { return }
                self.openFilter(data: data)
            }
        }
        return cell
    }
    
    func openFilter(data: CollectionDeliveryDataList) {
        let ctrl = self.storyboard?.instantiateViewController(withIdentifier: "CollectionFilterVC") as! CollectionFilterVC
        ctrl.modalPresentationStyle = .overFullScreen
        ctrl.view.isOpaque = false
        ctrl.isCollected = (data.status ?? "").lowercased() == "returned"
        
        ctrl.refbtnClicked = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.openReferance(data: data)
            }
        }
        
        ctrl.returnbtnClicked = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.openRetrunVehicle(data: data)
            }
        }
        
        ctrl.regobtnClicked = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.openFleetReferance(data: data)
            }
        }
        
        ctrl.swapbtnClicked = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.openSwapVehicle(data: data)
            }
        }
        
        self.present(ctrl, animated: false)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let lastItem = self.arrFilteredVehicles.count - 1
//        if indexPath.row == lastItem {
//            if isPaginationAvailable && search.isEmpty {
//                self.currentPage += 1
//                self.getCollectionListList()
//            }
//        }
    }
    
    func openReferance(data: CollectionDeliveryDataList) {
        
//        var storyboardName = String()
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            storyboardName = AppStoryboards.DASHBOARD
//        } else {
//            storyboardName = AppStoryboards.DASHBOARD_PHONE
//        }
//        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
//
//        let ctrl = storyboard.instantiateViewController(withIdentifier: "SearchDashboardResultDetailsVC") as! SearchDashboardResultDetailsVC
//        ctrl.modalPresentationStyle = .overFullScreen
//        ctrl.searchValue = data.application_id ?? ""
//        self.present(ctrl, animated: true)
        
        var storyboardName = String()
        var vcid = String()
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboardName = AppStoryboards.DASHBOARD
            vcid = AppStoryboardId.REF_SEARCH_RESULT_VC
            
        } else {
            storyboardName  = AppStoryboards.DASHBOARD_PHONE
            vcid = AppStoryboardId.REF_SEARCH_RESULT_PHONE
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        let searchResultvc = storyboard.instantiateViewController(identifier: vcid) as! ReferenceSearchResultVC
//        searchResultvc.responseDict = dict
        searchResultvc.searchValue = data.application_id ?? ""
        searchResultvc.modalPresentationStyle = .overFullScreen
        self.present(searchResultvc, animated: true, completion: nil)
        
    }
    
    
    func openSwapVehicle(data: CollectionDeliveryDataList) {
        let ctrl = UIStoryboard(name: "DashboardPhone", bundle: nil).instantiateViewController(withIdentifier: "NewSwapVehicleVC") as! NewSwapVehicleVC
        ctrl.modalPresentationStyle = .overFullScreen
        ctrl.regoNumber = data.registration_no ?? ""
        self.present(ctrl, animated: true)
    }
    
    func openRetrunVehicle(data: CollectionDeliveryDataList) {
        let ctrl = UIStoryboard(name: "DashboardPhone", bundle: nil).instantiateViewController(withIdentifier: "NewReturnVehicleVC") as! NewReturnVehicleVC
        ctrl.modalPresentationStyle = .overFullScreen
        ctrl.regoNumber = data.registration_no ?? ""
        self.present(ctrl, animated: true)
    }
    
    func openFleetReferance(data: CollectionDeliveryDataList) {
        let ctrl = UIStoryboard(name: "AccidentManagement", bundle: nil).instantiateViewController(withIdentifier: "FleetReferenceVC") as! FleetReferenceVC
        ctrl.modalPresentationStyle = .overFullScreen
        ctrl.vehicleCollectionDetails = data
        self.present(ctrl, animated: true)
    }
}

extension DeliveryCollectionsVC {
    
    func getCollectionListList() {
        
        self.arrAvailVehicles = []
        
        if self.currentPage == 0 {
            CommonObject().showProgress()
        }
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.collectionDeliveryList)!
        webService.method = .post
        
        var param = [String: Any]()
        param["fromDate"] = self.startDate
        param["toDate"] = self.endDate
        param["status"] = self.selectedFilterType
        
        if self.search != "" {
            param["searchval"] = self.search
        }
        
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
            if let data = responseData?.convertData(CollectionDeliveryModel.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? CollectionDeliveryModel {
                    if (data.status ?? 0) == 0 {
                        self.arrAvailVehicles = []
                        self.arrFilteredVehicles = []
//                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        self.tableView.reloadData()
                        return
                    }
                    if let dataList = data.data {
                        self.isPaginationAvailable = !(dataList.count < numberOfItemPerPage)
                        self.arrAvailVehicles.append(contentsOf: dataList)
                        self.arrFilteredVehicles = self.arrAvailVehicles
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
}

extension DeliveryCollectionsVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrNavigation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventDetailsNavigation", for: indexPath) as? EventDetailsNavigation else { return UICollectionViewCell() }
            
        cell.lblTitle.text = "\(self.arrNavigation[indexPath.row]["title"] ?? "")"
        cell.imgIcon.isHidden = (self.arrNavigation[indexPath.row]["icon"] ?? "") == ""
        if (self.arrNavigation[indexPath.row]["icon"] ?? "") != "" {
            cell.imgIcon.image = UIImage(named: self.arrNavigation[indexPath.row]["icon"] ?? "")
        }
        
        if selectedFilter == (self.arrNavigation[indexPath.row]["title"] ?? "") {
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
        return CGSize(width: (collectionView.frame.width / CGFloat(self.arrNavigation.count)), height: collectionView.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.search = ""
        self.txtSearch.text = ""
        self.currentPage = 0
        self.isPaginationAvailable = false
        self.arrAvailVehicles = []
        self.arrFilteredVehicles = []
        self.selectedFilter = (self.arrNavigation[indexPath.row]["title"] ?? "")
        self.selectedFilterType = (self.arrNavigation[indexPath.row]["type"] ?? "")
        self.filterCollectionView.reloadData()
        self.getCollectionListList()
        
        self.navigationTitle.text = self.selectedFilter
    }
}
