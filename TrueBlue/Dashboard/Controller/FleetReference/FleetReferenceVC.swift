//
//  FleetReferenceVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 29/01/24.
//

import UIKit
import Applio

var numberOfItemPerPage = 50

class FleetReferenceVC: UIViewController {

    @IBOutlet weak var carModelLabel: UILabel!
    @IBOutlet weak var carIdLabel: UILabel!
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var vehicleDetails: AccidentMaintenance?
    var vehicleCollectionDetails: CollectionDeliveryDataList?
    var arrReferace: [AccidentReferance] = []
    
    var currentPage = 0
    var isPaginationAvailable = false
    
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
    
    @IBAction func btnAddNewRef(_ sender: Any) {
        CommonObject.sharedInstance.isNewEntry = true
        CommonObject.sharedInstance.currentReferenceId = ""
        
        var storyboardName = String()
        var vcID = String()
        if UIDevice.current.userInterfaceIdiom == .pad {
            vcID = AppStoryboardId.NEW_BOOKING_ENTRY
            storyboardName = AppStoryboards.DASHBOARD
        } else {
            vcID = AppStoryboardId.NEW_BOOKIN_ENTRY_PHONE
            storyboardName = AppStoryboards.DASHBOARD_PHONE
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        let newbookingEntryVc = storyboard.instantiateViewController(identifier: vcID) as! NewBookingEntryVC
        present(newbookingEntryVc, animated: true, completion: nil)
    }
    
    func setupTableview() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(for: "FleetViewReferenceTVC")
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
        
        if let data = vehicleCollectionDetails {
            self.carNameLabel.text = "\(data.vehicle_make ?? "") \(data.vehicle_model ?? "") (\((data.yearof_manufacture ?? "").date(convetedFormate: .ddmmyyyy)))"
            self.carIdLabel.text = data.vehicle_category
            self.carModelLabel.text = (data.vehicle_make ?? "")
            if let url = URL(string: data.fleet_image ?? "") {
                self.carImage.sd_setImage(with: url)
            }
        }
    }
}

extension FleetReferenceVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrReferace.count != 0 {
            tableView.removeBackgroundView()
            return self.arrReferace.count
        }
        tableView.setBackgroundView(msg: .referance_list_empty)
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FleetViewReferenceTVC") as? FleetViewReferenceTVC else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.setupDetails(data: self.arrReferace[indexPath.row])
        cell.detailsButtonClicked = { [weak self] in
            guard let self else { return }
            self.navigateToNewEntry(index: indexPath.row)
        }
        
        cell.viewButtonClicked = { [weak self] in
            guard let self else { return }
            self.navigateToNewEntry(index: indexPath.row)
        }
        
        return cell
    }
    
    func navigateToNewEntry(index: Int) {
        if let application_id = arrReferace[index].application_id {
            
            CommonObject.sharedInstance.isNewEntry = false
            CommonObject.sharedInstance.currentReferenceId = application_id
            
            var storyboardName = String()
            var vcID = String()
            if UIDevice.current.userInterfaceIdiom == .pad {
                vcID = AppStoryboardId.NEW_BOOKING_ENTRY
                storyboardName = AppStoryboards.DASHBOARD
            } else {
                vcID = AppStoryboardId.NEW_BOOKIN_ENTRY_PHONE
                storyboardName = AppStoryboards.DASHBOARD_PHONE
            }
            let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
            let newbookingEntryVc = storyboard.instantiateViewController(identifier: vcID) as! NewBookingEntryVC
            present(newbookingEntryVc, animated: true, completion: nil)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = self.arrReferace.count - 10
        if indexPath.row == lastItem {
            if isPaginationAvailable {
                self.currentPage += 1
                self.getRefList()
            }
        }
    }
    
    
}

extension FleetReferenceVC {
    
    func getRefList() {
        if self.currentPage == 0 {
            CommonObject().showProgress()
        }
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.getRegoBookings)!
        webService.method = .post
        
        var param = [String: Any]()
        param["limitRecord"] = "\(numberOfItemPerPage)"
        param["pageNo"] = "\(numberOfItemPerPage * (self.currentPage))"
        
        param["vehicle_id"] = vehicleDetails?.id ?? vehicleCollectionDetails?.vehicle_id
        
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
//                    print("Before Filter Count", (data.data?.response ?? []).count)
                    if let dataList = data.data?.response {
                        self.isPaginationAvailable = !(dataList.count < 50)
                        self.arrReferace.append(contentsOf: dataList)
                        self.tableView.reloadData()
                    }
//                    print("After Filter Count", self.arrReferace.count)
                }
            }
        }
    }
    
}

