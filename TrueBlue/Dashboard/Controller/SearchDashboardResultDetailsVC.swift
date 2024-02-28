//
//  SearchDashboardResultDetailsVC.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 31/08/21.
//

import UIKit
import Alamofire
import DZNEmptyDataSet
class SearchDashboardResultDetailsVC: UIViewController {
    var searchResultObj = SearchDashboardModelData()
    var vehiclesResultObj = [VehiclesDetailsModelData]()
    var searchValue = String()
    var arrSearchData = [SearchDashboardResultDetailsModelData]()
    
//    @IBOutlet weak var ibViewSappedVehicleBtn: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var viewSwappedHeight: NSLayoutConstraint!
    @IBOutlet weak var viewSwappedBtnView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //viewSwappedHeight.constant = 0
        // Do any additional setup after loading the view.
        let parameters : Parameters = ["searchvalue" : searchValue]
        apiPostRequest(parameters: parameters, endPoint: EndPoints.SEARCH_DASHBOARD_RESULT_DETAILS)
        if searchResultObj.isSwapped == "Yes" {
            //ibViewSappedVehicleBtn.isHidden = false
        } else {
            //ibViewSappedVehicleBtn.isHidden = true
        }
        
        print(vehiclesResultObj.count)
        tblView.emptyDataSetSource = self
        tblView.emptyDataSetDelegate = self
        
    }
    
    func apiPostRequest(parameters: Parameters,endPoint: String) {
        CommonObject.sharedInstance.showProgress()
        let obj = SearchDashboardResultDetailsViewModel()
        obj.delegate = self
        obj.postSearchDashboardResultDetails(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @objc func viewSwappedVehicles(sender:UIButton ) {
        print(vehiclesResultObj)
        var storyboardName = String()
        var vcid = String()
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboardName = AppStoryboards.DASHBOARD
            vcid = AppStoryboardId.SWAPPED_VEHICLEVC
            // vcid = AppStoryboardId.COLLECTION_NOTE
        } else {
            storyboardName  = AppStoryboards.DASHBOARD_PHONE
            vcid = AppStoryboardId.SWAPPED_VEHICLE_PHONE
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        let  swappedVehiclevc = storyboard.instantiateViewController(identifier: vcid) as! SwappedVehicleVC
        swappedVehiclevc.vehiclesResultListObj = vehiclesResultObj
        swappedVehiclevc.refNumber = arrSearchData
        swappedVehiclevc.modalPresentationStyle = .overFullScreen
        present(swappedVehiclevc, animated: true, completion: nil)
    }

    func calculateDaysBetweenDates(startDate: Date, endDate: Date) -> Int {
        let secondsInDay: TimeInterval = 86400 // 60 seconds/minute * 60 minutes/hour * 24 hours/day

        // Calculate the time interval between the two dates in seconds
        let timeInterval = endDate.timeIntervalSince(startDate)

        // Calculate the total number of days
        let days = Int(timeInterval / secondsInDay)

        return days
    }

   /*
//    @IBAction func viewSwappedVehicleBtn(_ sender: UIButton) {
//        print(vehiclesResultObj)
//        var storyboardName = String()
//        var vcid = String()
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            storyboardName = AppStoryboards.DASHBOARD
//            vcid = AppStoryboardId.SWAPPED_VEHICLEVC
//            // vcid = AppStoryboardId.COLLECTION_NOTE
//        } else {
//            storyboardName  = AppStoryboards.DASHBOARD_PHONE
//            vcid = AppStoryboardId.SWAPPED_VEHICLE_PHONE
//
//            //vcid = AppStoryboardId.COLLECTION_NOTE_PHONE
//        }
//        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
//        let  swappedVehiclevc = storyboard.instantiateViewController(identifier: vcid) as! SwappedVehicleVC
//        swappedVehiclevc.vehiclesResultListObj = vehiclesResultObj
//        swappedVehiclevc.refNumber = arrSearchData
//        swappedVehiclevc.modalPresentationStyle = .overFullScreen
//        present(swappedVehiclevc, animated: true, completion: nil)
//    }
    */
}

extension SearchDashboardResultDetailsVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSearchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppTblViewCells.SEARCH_DASHBOARD_RESULT_DETAIL, for: indexPath as IndexPath) as! SearchDashboardResultDetailTblViewCell
        cell.selectionStyle = .none
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dateInData = ""
        if arrSearchData[indexPath.row].dateIn.isEmpty || arrSearchData[indexPath.row].dateIn == "0000-00-00" {
            dateInData = "--"
        }else {
            dateInData = arrSearchData[indexPath.row].dateIn
        }
        
        if !arrSearchData[indexPath.row].referenceNumber.isEmpty {
            cell.referenceNumberLbl.text = arrSearchData[indexPath.row].referenceNumber
        } else {
            cell.referenceNumberLbl.text = "--"
        }
        if !arrSearchData[indexPath.row].vehicleRego.isEmpty {
            cell.vehicleRegoLbl.text = arrSearchData[indexPath.row].vehicleRego
        } else {
            cell.vehicleRegoLbl.text = "--"
        }
        if !arrSearchData[indexPath.row].makeModel.isEmpty {
            cell.makeModelLbl.text = arrSearchData[indexPath.row].makeModel
        } else {
            cell.makeModelLbl.text = "--"
        }
        if !arrSearchData[indexPath.row].clientName.isEmpty {
            cell.clientNameLbl.text = arrSearchData[indexPath.row].clientName
        } else {
            cell.clientNameLbl.text = "--"
        }
        
        cell.dateInLbl.text = dateInData
//        if !arrSearchData[indexPath.row].dateIn.isEmpty || arrSearchData[indexPath.row].dateIn != "0000-00-00"{
//            cell.dateInLbl.text = arrSearchData[indexPath.row].dateIn
//        } else {
//            cell.dateInLbl.text = dateInData
//        }
        if !arrSearchData[indexPath.row].dateOut.isEmpty {
            cell.dateOutLbl.text = arrSearchData[indexPath.row].dateOut
        } else {
            cell.dateOutLbl.text = "--"
        }
        if !arrSearchData[indexPath.row].dateOut.isEmpty {
            cell.dateOutLbl.text = arrSearchData[indexPath.row].dateOut
        } else {
            cell.dateOutLbl.text = "--"
        }
        if !arrSearchData[indexPath.row].clientRego.isEmpty {
            cell.clientRegoLbl.text = arrSearchData[indexPath.row].clientRego
        } else {
            cell.clientRegoLbl.text = "--"
        }
        if !arrSearchData[indexPath.row].clientMakeModel.isEmpty {
            cell.clientMakeModelLbl.text = arrSearchData[indexPath.row].clientMakeModel
        } else {
            cell.clientMakeModelLbl.text = "--"
        }
        if !arrSearchData[indexPath.row].referralName.isEmpty {
            cell.referralNameLbl.text = arrSearchData[indexPath.row].referralName
        } else {
            cell.referralNameLbl.text = "--"
        }
        if !arrSearchData[indexPath.row].repairerName.isEmpty {
            cell.repairerNameLbl.text = arrSearchData[indexPath.row].repairerName
        } else {
            cell.repairerNameLbl.text = "--"
        }
        
        
        
        if let startDate = dateFormatter.date(from: arrSearchData[indexPath.row].dateOut),
           let endDate = dateFormatter.date(from: dateInData) {
            let daysBetween = calculateDaysBetweenDates(startDate: startDate, endDate: endDate)
            cell.totalDaysLbl.text = "\(daysBetween)"
        } else {
            cell.totalDaysLbl.text = "--"
        }
        
            /*
        //        if !arrSearchData[indexPath.row].settledAmount.isEmpty {
        //            cell.settledAmountLbl.text = arrSearchData[indexPath.row].settledAmount
        //        } else {
        //            cell.settledAmountLbl.text = "--"
        //        }
        //        if !arrSearchData[indexPath.row].paymentAmount.isEmpty {
        //            cell.paymentAmountLbl.text = arrSearchData[indexPath.row].paymentAmount
        //        } else {
        //            cell.paymentAmountLbl.text = "--"
        //        }
             */
        if !arrSearchData[indexPath.row].status.isEmpty {
            cell.statusLbl.text = arrSearchData[indexPath.row].status
        } else {
            cell.statusLbl.text = "--"
        }
        if searchResultObj.isSwapped == "Yes" {
            //cell.viewSwappedVehicleBtn.isHidden = false
            cell.viewSwappedVehicleView.isHidden = false
            cell.viewSwappedVehicleBtn.tag = indexPath.row
            cell.viewSwappedVehicleBtn.addTarget(self, action: #selector(viewSwappedVehicles(sender: )), for: .touchUpInside)
        } else {
            //cell.viewSwappedVehicleBtn.isHidden = true
            cell.viewSwappedVehicleView.isHidden = true
        }
       // cell.viewSwappedVehicleBtn.tag = indexPath.row
        //if arrSearchData[indexPath.row].
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !arrSearchData[indexPath.row].referenceNumber.isEmpty {
            CommonObject.sharedInstance.isNewEntry = false
            CommonObject.sharedInstance.currentReferenceId = arrSearchData[indexPath.row].referenceNumber
            performSegue(withIdentifier: AppSegue.CREATE_NEW_ENTRY, sender: nil)
        }
    }
}
extension SearchDashboardResultDetailsVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIImage(named: AppImageNames.NO_RECORD_FOUND)
        }
        return UIImage(named: AppImageNames.NO_RECORD_FOUND_SMALL)
    }
}
extension SearchDashboardResultDetailsVC : SearchDashboardResultDetailsVMDelegate {
    func searchDashboardResultDetailsAPISuccess(objData: SearchDashboardResultDetailsModel, strMessage: String) {
        showToast(strMessage: strMessage)
        print(objData.arrResult)
        arrSearchData = objData.arrResult
        if arrSearchData.count > 0 {
            tblView.reloadData()
        }
    }
    
    func searchDashboardResultDetailsAPISuccess(strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
    }
    
    func searchDashboardResultDetailsAPIFailure(strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
    }
}
