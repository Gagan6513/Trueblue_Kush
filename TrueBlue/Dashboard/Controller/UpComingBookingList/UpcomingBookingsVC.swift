//
//  UpcomingBookingsVC.swift
//  TrueBlue
//
//  Created by Inexture Solutions LLP on 17/11/23.
//

import UIKit
import Alamofire
import DZNEmptyDataSet
import Applio

class UpcomingBookingsVC: UIViewController{

    @IBOutlet weak var tblUpcomingBookingsList: UITableView!
    @IBOutlet weak var dateToTxtFld: UITextField!
    @IBOutlet weak var dateFromTxtFld: UITextField!
    
    @IBOutlet weak var searchTxtFld: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var btnSearch: UIButton!
    
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var btnApply: UIButton!

    @IBOutlet weak var filterview: UIView!
    
    
    var arrCollectionList = [UpcomingBookingData]()
    var collectionNoteDetail : UpcomingBookingData?
    
    var arrColor = [UIColor(named: "AppBlue"),UIColor(named: "AppGreen"),UIColor(named: "AppGrey"),UIColor(named: "AppRed"),UIColor(named: "AppOrange")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterview.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        btnApply.layer.cornerRadius = 7
        searchView.layer.borderColor = UIColor(named: "AppBlue")?.cgColor
        searchView.layer.borderWidth = 1
        searchView.layer.cornerRadius = 5
        self.searchView.isHidden = true
        
        btnFilter.layer.cornerRadius = btnFilter.frame.size.height/2
        
//        btnSearch.layer.cornerRadius = 5
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.DateNotificationAction(_:)), name: .collectionDate, object: nil)
        
//        tblUpcomingBookingsList.emptyDataSetSource = self;
//        tblUpcomingBookingsList.emptyDataSetDelegate = self;
        
        
        self.tblUpcomingBookingsList.delegate = self
        self.tblUpcomingBookingsList.dataSource = self
        self.tblUpcomingBookingsList.registerNib(for: "UpcomingBookingTableViewCell")

        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        //dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFromTxtFld.text = dateFormatter.string(from: currentDate)
        dateToTxtFld.text = dateFromTxtFld.text
        dateFromTxtFld.keyboardType = .numberPad
        dateToTxtFld.keyboardType = .numberPad
        
        CallAPIWhenPageLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)//Removes all notifications being observed
    }
    
    
    func CallAPIWhenPageLoad(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let strFrom = dateFormatter.string(from: Date())
        let strTo = dateFormatter.string(from: Calendar.current.date(byAdding: .year, value: 3, to: Date()) ?? Date())
        
        let dateFrom = dateFormatter.date(from: strFrom)
        let dateTo = dateFormatter.date(from: strTo)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let resultDateFrom = dateFormatter.string(from: dateFrom!)
        let resultDateTo = dateFormatter.string(from: dateTo!)
        
//        if dateFrom!.compare(dateTo!) == .orderedDescending {
//            // To Date is earlier than From Date
//            showToast(strMessage: validationForToFromDate)
//            
//        } else {
            let parameters : Parameters = ["fromDate" : resultDateFrom,
                                           "toDate" : resultDateTo]
            apiPostCollectionNoteDetail(parameters: parameters, endPoint: EndPoints.GET_NEW_UPCOMING_BOOKINGS)
//        }
        
    }
    
    @objc func DateNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let selectedDate = userInfo["selectedDate"] as? String {
                let selectedTextField = userInfo["dateTextField"] as! UITextField
                switch selectedTextField {
                case dateFromTxtFld:
                    dateFromTxtFld.text = selectedDate
                case dateToTxtFld:
                    dateToTxtFld.text = selectedDate
                default:
                    print("Unkown Date Textfield")
                }
            }
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func submitBtn(_ sender: UIButton) {
        if dateFromTxtFld.text == "" {
            showToast(strMessage: dateFromRequired)
            return
        }
        if dateToTxtFld.text == "" {
            showToast(strMessage: dateToRequired)
            return
        }
        filterview.isHidden = true
        apiUpcomingBookingList()
    }
    
    @IBAction func dateFromCalenderTapped(_ sender: UIButton) {
        showDatePickerPopUp(textField: dateFromTxtFld, notificationName: .collectionDate, _isFromUpcomingBooking: true)
    }
    
    @IBAction func dateToCalenderTapped(_ sender: UIButton) {
        showDatePickerPopUp(textField: dateToTxtFld, notificationName: .collectionDate, _isFromUpcomingBooking: true)
    }
    
    @IBAction func searchInnerAction(_ sender: Any) {
        self.searchView.isHidden = true
        if (searchTxtFld.text?.isEmpty ?? false) {
            self.CallAPIWhenPageLoad()
        } else {
            let parameters : Parameters = ["application_id" : searchTxtFld.text ?? ""]
            apiPostCollectionNoteDetail(parameters: parameters, endPoint: EndPoints.GET_NEW_UPCOMING_BOOKINGS)
        }
    }
    
    @IBAction func btnSearchClicked(_ sender: UIButton) {
//        self.view.endEditing(true)
        self.searchView.isHidden = false
        self.searchTxtFld.becomeFirstResponder()
    }
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        filterview.isHidden = true
    }
    
    @IBAction func btnFliterClicked(_ sender: UIButton) {
        filterview.isHidden = false
    }
    
    func apiUpcomingBookingList(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateFrom = dateFormatter.date(from: dateFromTxtFld.text ?? "")
        let dateTo = dateFormatter.date(from: dateToTxtFld.text ?? "")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let resultDateFrom = dateFormatter.string(from: dateFrom!)
        let resultDateTo = dateFormatter.string(from: dateTo!)
        
        if dateFrom!.compare(dateTo!) == .orderedDescending {
            // To Date is earlier than From Date
            showToast(strMessage: validationForToFromDate)
            
        } else {
            let parameters : Parameters = ["fromDate" : resultDateFrom,
                                           "toDate" : resultDateTo]
            apiPostCollectionNoteDetail(parameters: parameters, endPoint: EndPoints.GET_NEW_UPCOMING_BOOKINGS)
        }
    }
    
    func apiPostCollectionNoteDetail(parameters: Parameters,endPoint: String) {
        CommonObject.sharedInstance.showProgress()
        let obj = UpcomingBookingListViewModel()
        obj.delegate = self
        obj.postCollectionNoteDetail(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy/MM/dd"
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            return outputFormatter.string(from: date)
        }
        return nil
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension UpcomingBookingsVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
extension UpcomingBookingsVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrCollectionList.count != 0 {
            tableView.removeBackgroundView()
            return self.arrCollectionList.count
        }
        if dateFromTxtFld.text?.isEmpty ?? true {
            tableView.setBackgroundView(msg: "No Records found")
        } else {
            tableView.setBackgroundView(msg: "No Records found for\n\(dateFromTxtFld.text ?? "") to \(dateToTxtFld.text ?? "")")
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppTblViewCells.UPCOMING_BOOKING_LIST_CELL, for: indexPath as IndexPath) as! UpcomingBookingTableViewCell
        cell.selectionStyle = .none
        cell.setData(data: self.arrCollectionList[indexPath.row])
        return cell
        
        //////////
//        let cell = tableView.dequeueReusableCell(withIdentifier: AppTblViewCells.COLLECTION_NOTES_LIST_CELL, for: indexPath as IndexPath) as! CollectionNotesListTableViewCell
//        if indexPath.row == 0 {
//            let headerCell = tableView.dequeueReusableCell(withIdentifier: AppTblViewCells.COLLECTIONS_LIST_HEADER, for: indexPath as IndexPath) as! CollectionsHeaderTblViewCell
//            return headerCell
//        } else {
//            cell.viewMainBorder.layer.borderColor = UIColor(named: AppColors.INPUT_BORDER)?.cgColor
//            cell.viewMainBorder.layer.borderWidth =  1
//            cell.viewMainBorder.backgroundColor = .white
//        }
        //////////
        
//        let intRandom = Int.random(in: 0 ... 4)
//        print(intRandom)
//        cell.lblColor.backgroundColor = arrColor[intRandom]
//        cell.viewColor.backgroundColor = arrColor[intRandom]?.withAlphaComponent(0.2)
//
//        cell.MakeModelLbl.text = "\(arrCollectionList[indexPath.row].vehicle_make.trimmingCharacters(in: .whitespaces)) / \(arrCollectionList[indexPath.row].vehicle_model)"
//
//        cell.RefNoLbl.text = arrCollectionList[indexPath.row].application_id
//        cell.AssociateLbl.text = arrCollectionList[indexPath.row].associate_name
//        cell.ClientNameLbl.text = "\(arrCollectionList[indexPath.row].owner_firstname) \(arrCollectionList[indexPath.row].owner_lastname)"
//        cell.VehicleRegoLbl.text = arrCollectionList[indexPath.row].registration_no
//
//        let stringDate = formattedDateFromString(dateString: arrCollectionList[indexPath.row].expected_delivery_date, withFormat: "dd")
//
//        let stringMonthYear = formattedDateFromString(dateString: arrCollectionList[indexPath.row].expected_delivery_date, withFormat: "MMM, yyyy")
//
//        let stringB = formattedDateFromString(dateString: arrCollectionList[indexPath.row].expected_delivery_date, withFormat: "dd MMM, yyyy")
//
//        cell.dateLbl.text = stringDate
//        cell.dateMonthYearLbl.text = stringMonthYear
        
//        return cell
   
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !arrCollectionList[indexPath.row].application_id.isEmpty {
            
            CommonObject.sharedInstance.isNewEntry = false
            CommonObject.sharedInstance.currentReferenceId = arrCollectionList[indexPath.row].application_id
            
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
            //newbookingEntryVc.newBookingBackDelegate = self
    //            alertVc.dictCardDetails = dictUploadedDocumentsData.cardDetails//Sending Card Details to Card Details Screen
    //            alertVc.modalPresentationStyle = .overFullScreen
            present(newbookingEntryVc, animated: true, completion: nil)
            
//            performSegue(withIdentifier: AppSegue.CREATE_NEW_ENTRY, sender: nil)
        }
    }
}

extension UpcomingBookingsVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case dateFromTxtFld,dateToTxtFld:
            return textField.validateDateTyped(shouldChangeCharactersInRange: range, replacementString: string)
        default:
            return true
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateFromTxtFld {
            showDatePickerPopUp(textField: dateFromTxtFld, notificationName: .collectionDate, _isFromUpcomingBooking: true)
        }
        if textField == dateToTxtFld {
            showDatePickerPopUp(textField: dateToTxtFld, notificationName: .collectionDate, _isFromUpcomingBooking: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        if textField == searchTxtFld && ((searchTxtFld.text?.isEmpty) != nil){
            let parameters : Parameters = ["application_id" : searchTxtFld.text ?? ""]
            apiPostCollectionNoteDetail(parameters: parameters, endPoint: EndPoints.GET_NEW_UPCOMING_BOOKINGS)
        }
        return true
    }
}
extension UpcomingBookingsVC :DZNEmptyDataSetDelegate , DZNEmptyDataSetSource  {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIImage(named: AppImageNames.NO_RECORD_FOUND)
        }
        return UIImage(named: AppImageNames.NO_RECORD_FOUND_SMALL)
    }
}
extension UpcomingBookingsVC : UpcomingBookingListVMDelegate {
    func UpcomingBookingListAPISuccess(objData: UpcomingBookingDataModel, strMessage: String, serviceKey: String) {
        objData.arrResult.count > 0 ? arrCollectionList = objData.arrResult : arrCollectionList.removeAll()
        
//        if arrCollectionList.count > 0{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let ready = arrCollectionList.sorted(by: { (dateFormatter.date(from:$0.expected_delivery_date) ?? Date()).compare((dateFormatter.date(from:$1.expected_delivery_date) ?? Date())) == .orderedAscending })
            arrCollectionList = ready
            tblUpcomingBookingsList.reloadData()
//        }
        
    }
    
    func UpcomingBookingListAPIFailure(strMessage: String, serviceKey: String) {
        arrCollectionList.removeAll()
        tblUpcomingBookingsList.reloadData()
    }
}
