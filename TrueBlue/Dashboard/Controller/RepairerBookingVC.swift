//
//  RepairerBookingVC.swift
//  TrueBlue
//
//  Created by Sharad Patil on 17/12/23.
//

import UIKit
import Alamofire

class RepairerBookingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var dateToTF: UITextField!
    @IBOutlet weak var dateFromTF: UITextField!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var repairerBookingTableView: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    
    var repairBookingsArray = [[String: Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        filterView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        //dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFromTF.text = dateFormatter.string(from: currentDate)
        dateToTF.text = dateFromTF.text
        dateFromTF.keyboardType = .numberPad
        dateToTF.keyboardType = .numberPad
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.DateNotificationAction(_:)), name: .collectionDate, object: nil)
        CallAPIWhenPageLoad()
    }
    
    func CallAPIWhenPageLoad(){
        
        let dates = getCurrentMonthDates()
        print("Start Date: \(dates.startDate)")
        print("End Date: \(dates.endDate)")
        let parameters : Parameters = ["fromDate" : dates.startDate,
                                           "toDate" : dates.endDate]
        apiPostCollectionNoteDetail(parameters: parameters, endPoint: EndPoints.GET_NEW_REPAIRER_BOOKINGS)
        
    }
    func getCurrentMonthDates() -> (startDate: String, endDate: String) {
        let calendar = Calendar.current
        let currentDate = Date()

        // Get the range of the current month
        if let monthRange = calendar.range(of: .month, in: .year, for: currentDate) {
            // Get the start date of the month
            let startDateComponents = DateComponents(year: calendar.component(.year, from: currentDate),
                                                     month: calendar.component(.month, from: currentDate),
                                                     day: 1)
            if let startDate = calendar.date(from: startDateComponents) {
                // Get the end date of the month
                let endDateComponents = DateComponents(year: calendar.component(.year, from: currentDate),
                                                       month: calendar.component(.month, from: currentDate) + 1,
                                                       day: 0)
                if let endDate = calendar.date(from: endDateComponents) {
                    // Format dates as strings
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"

                    let startDateString = dateFormatter.string(from: startDate)
                    let endDateString = dateFormatter.string(from: endDate)

                    return (startDate: startDateString, endDate: endDateString)
                }
            }
        }

        // Default return values if something goes wrong
        return (startDate: "", endDate: "")
    }

    func apiPostCollectionNoteDetail(parameters: Parameters,endPoint: String) {
        CommonObject.sharedInstance.showProgress()
        let newAPIPATH = API_PATH.replacingOccurrences(of: "newapp", with: "app")
        let requestURL = newAPIPATH + endPoint
         
        if NetworkReachabilityManager()!.isReachable {
            AF.request(requestURL , method: .post, parameters: parameters, encoding: URLEncoding.httpBody) { $0.timeoutInterval = 60 }.responseJSON { (response) in
                debugPrint(response)
                
                CommonObject.sharedInstance.stopProgress()
                if let mainDict = response.value as? [String : AnyObject] {
                    
                    print(mainDict)
                    
                    if let responseData = mainDict["data"] as? [String: Any],
                       let responseArray = responseData["response"] as? [[String: Any]] {
                        
                        self.repairBookingsArray = responseArray
                        self.repairerBookingTableView.reloadData()
                    } else {
                        print("Error parsing response")
                    }
                    let status = mainDict["status"] as? Int ?? 0
                    if status == 1{
                        CommonObject.sharedInstance.stopProgress()
                        
                        let dict = mainDict["data"] as? Dictionary<String, Any> ?? [:]
                        print(dict)
                        
                        
                        let strMsg = mainDict["msg"] as? String ?? ""
                        //                        self.delegateDataSync?.requestSuccess(dictObj: dict, serviceKey: endPoint, strMessage: strMsg)
                    } else {
                        CommonObject.sharedInstance.stopProgress()
                        let errorMsg = mainDict["msg"] as? String ?? ""
                        print(errorMsg)
                        
                    }
                } else{
                    //Diksha Rattan:Api Failure Response
                    CommonObject.sharedInstance.stopProgress()
                    
                }
            }
        }
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
    
    @objc func DateNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let selectedDate = userInfo["selectedDate"] as? String {
                let selectedTextField = userInfo["dateTextField"] as! UITextField
                switch selectedTextField {
                case dateFromTF:
                    dateFromTF.text = selectedDate
                case dateToTF:
                    dateToTF.text = selectedDate
                default:
                    print("Unkown Date Textfield")
                }
            }
        }
    }
    
    func apiRepairerBookingList(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateFrom = dateFormatter.date(from: dateFromTF.text ?? "")
        let dateTo = dateFormatter.date(from: dateToTF.text ?? "")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let resultDateFrom = dateFormatter.string(from: dateFrom!)
        let resultDateTo = dateFormatter.string(from: dateTo!)
        
        if dateFrom!.compare(dateTo!) == .orderedDescending {
            // To Date is earlier than From Date
            showToast(strMessage: validationForToFromDate)
            
        } else {
            let parameters : Parameters = ["fromDate" : resultDateFrom,
                                           "toDate" : resultDateTo]
            apiPostCollectionNoteDetail(parameters: parameters, endPoint: EndPoints.GET_NEW_REPAIRER_BOOKINGS)
        }
    }
    
    
    @IBAction func filterBtnClicked(_ sender: Any) {
        filterView.isHidden = false
    }
    @IBAction func searchBtnClicked(_ sender: Any) {
    }
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func btnClosed(_ sender: Any) {
        filterView.isHidden = true
    }
    
    @IBAction func btnSearch(_ sender: Any) {
        self.view.endEditing(true)
        if !(txtSearch.text?.isEmpty ?? false) {
            let parameters : Parameters = ["searchval" : txtSearch.text ?? ""]
            apiPostCollectionNoteDetail(parameters: parameters, endPoint: EndPoints.GET_NEW_REPAIRER_BOOKINGS)
        } else {
            CallAPIWhenPageLoad()
        }
    }
    
    @IBAction func dateFromCalendarTapped(_ sender: Any) {
        showDatePickerPopUp(textField: dateFromTF, notificationName: .collectionDate, _isFromUpcomingBooking: true)
    }
    
    @IBAction func applyBtnTapped(_ sender: Any) {
        
        if dateFromTF.text == "" {
            showToast(strMessage: dateFromRequired)
            return
        }
        if dateToTF.text == "" {
            showToast(strMessage: dateToRequired)
            return
        }
        filterView.isHidden = true
        apiRepairerBookingList()
    }
    
    @IBAction func dateToCalendarTapped(_ sender: Any) {
        showDatePickerPopUp(textField: dateToTF, notificationName: .collectionDate, _isFromUpcomingBooking: true)
    }
    
    func getDayMonthWithYear(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: dateString) {
            // Format the date to include month name and year
            dateFormatter.dateFormat = "MMM, yyyy"
            let formattedDateString = dateFormatter.string(from: date)
            
            // Fetch the day of the month
            dateFormatter.dateFormat = "dd"
            let dayOfMonth = dateFormatter.string(from: date)
            
            return "\(dayOfMonth)~\(formattedDateString)"
        }
        
        return "Invalid date format"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repairBookingsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppTblViewCells.REPAIR_BOOKING_TABLEVIEW_CELL, for: indexPath as IndexPath) as! RepairerBookingTableViewCell
        cell.selectionStyle = .none

        let repairObject = repairBookingsArray[indexPath.row]
        cell.selectionStyle = .none
        cell.associateLbl.text = repairObject["associate_name"] as? String
        cell.makeModelLbl.text = "\(repairObject["vehicle_make"] ?? "") / \(repairObject["vehicle_model"] ?? "")"
        cell.referalName.text = repairObject["referral_name"] as? String
        cell.clientNameLbl.text = "\(repairObject["owner_firstname"] ?? "")  \(repairObject["owner_lastname"] ?? "")"
        cell.repairerName.text = repairObject["repairer_name"] as? String
        cell.statusLbl.text = repairObject["status"] as? String
        cell.refNoLbl.text = repairObject["application_id"] as? String
        cell.vehicleRegoLbl.text = repairObject["registration_no"] as? String
        
        if let expected_delivery_date = repairObject["expected_delivery_date"] as? String {
            let formDate = getDayMonthWithYear(dateString: expected_delivery_date)
            let formDateArr = formDate.components(separatedBy: "~")
            cell.dayLbl.text = formDateArr[0]
            cell.monthYearLbl.text = formDateArr[1]
        } else {
            cell.dayLbl.text = ""
            cell.monthYearLbl.text = ""
        }
        
        cell.viewMainBorder.layer.borderColor = UIColor(named: AppColors.INPUT_BORDER)?.cgColor
        cell.viewMainBorder.layer.borderWidth =  1
        cell.viewMainBorder.backgroundColor = .white
        return cell
    }
}
extension RepairerBookingVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case dateFromTF,dateToTF:
            return textField.validateDateTyped(shouldChangeCharactersInRange: range, replacementString: string)
        default:
            return true
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateFromTF {
            showDatePickerPopUp(textField: dateFromTF, notificationName: .collectionDate, _isFromUpcomingBooking: true)
        }
        if textField == dateToTF {
            showDatePickerPopUp(textField: dateToTF, notificationName: .collectionDate, _isFromUpcomingBooking: true)
        }
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//    
//        if textField == searchTxtFld && ((searchTxtFld.text?.isEmpty) != nil){
//            let parameters : Parameters = ["application_id" : searchTxtFld.text ?? ""]
//            apiPostCollectionNoteDetail(parameters: parameters, endPoint: EndPoints.GET_NEW_UPCOMING_BOOKINGS)
//        }
//        return true
//    }
}
