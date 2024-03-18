//
//  BookingDetailsVC.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 23/09/21.
//

import UIKit
import Alamofire

class BookingDetailsVC: UIViewController {
    
    @IBOutlet weak var deliveryDateTxtFld: UITextField!
    @IBOutlet weak var deliveryTimeTxtFld: UITextField!
    @IBOutlet weak var deliveryTimeSegmentedControl: UISegmentedControl!
    //@IBOutlet weak var deliveryByTxtFld: UITextField!
    
    @IBOutlet weak var deliveredCollectedByLbl: UILabel!
    @IBOutlet weak var proposedVehicleView: UIView!
    @IBOutlet weak var deliveryByView: UIView!
    
    @IBOutlet weak var proposedVehicleLbl: UILabel!
    @IBOutlet weak var dropLocationTxtFld: UITextField!
    @IBOutlet weak var dateOutTxtFld: UITextField!
    @IBOutlet weak var timeOutTxtFld: UITextField!
    @IBOutlet weak var timeOutSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var mileageOutTxtFld: UITextField!
    @IBOutlet weak var fuelOutTypeLbl: UILabel!
    
    @IBOutlet weak var serviceDueInfo: UIView!
    @IBOutlet weak var lastServiceMiles: UILabel!
    
    var selectedProposedVehicleId = String()//From Not At Fault
    var selectedDateOut = String()//From Not At Fault
    var selectedTimeOut = String()//From Not At Fault
    var selecteddeliveredById = String()
    var arrcollectedBy = [DeliveredCollectedByModelData]()
    var selecteddeliveredByName = String()
    var status : String?
    
    var arrProposedVehicle = [AvailableVehicleDropDownListModelData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.serviceDueInfo.isHidden = true
        selecteddeliveredById = UserDefaults.standard.userId()
        deliveredCollectedByLbl.text = UserDefaults.standard.username()
        deliveredCollectedByLbl.textColor = UIColor(named: AppColors.BLACK)
        // Do any additional setup after loading the view.
        //        hideKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchListNotificationAction(_:)), name: .searchListBookingDetails, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.ListNotificationAction(_:)), name: .listBookingDetails, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DateNotificationAction(_:)), name: .dateBookingDetails, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.TimeNotificationAction(_:)), name: .timeBookingDetails, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DeliveredCollectedBy(_:)), name: .deliveredCollectedBy, object: nil)
        setViews()
    }
    
    func setViews() {
        dateOutTxtFld.keyboardType = .numberPad
        mileageOutTxtFld.keyboardType = .numberPad
        timeOutTxtFld.keyboardType = .numberPad
        deliveryTimeSegmentedControl.setUpAmPmSegmentedControl()
        timeOutSegmentedControl.setUpAmPmSegmentedControl()
        let tap = UITapGestureRecognizer(target: self, action: #selector(proposedVehicleViewTapped))
        proposedVehicleView.addGestureRecognizer(tap)
        let deliveryByTap = UITapGestureRecognizer(target: self, action: #selector(deliveryByViewTapped))
        deliveryByView.addGestureRecognizer(deliveryByTap)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        dateOutTxtFld.text = selectedDateOut
        timeOutTxtFld.text = selectedTimeOut
        let parameters: Parameters = ["application_id": CommonObject.sharedInstance.currentReferenceId]
        apiPostRequest(parameters: parameters, endPoint: EndPoints.GET_BOOKING_DETAILS)
    }
    
    func apiPostRequest(parameters: Parameters,endPoint: String){
        CommonObject.sharedInstance.showProgress()
        let obj = BookingDetailsViewModel()
        obj.delegate = self
        obj.postBookingDetails(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    
    func getProposedVehileListAPI() {
        let obj = BookingDetailsViewModel()
        obj.delegate = self
        obj.getProposedVehiclesList(currentController: self, parameters: nil)
    }
    
    func deliveryByListAPI() {
        let obj = DeliveredCollectedByViewModel()
        obj.delegate = self
        obj.deliveredCollectedByAPI(currentController: self, parameters: [:], endPoint: EndPoints.DELIVERED_COLLECTEDBY)
    }
    
    @IBAction func closeBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    @IBAction func deliveryTimeSegmentedControl(_ sender: UISegmentedControl) {
        copyDataIfRequired(isDateEdited: false, isTimeEdited: true)
    }
    
    @IBAction func fuelOutTapped(_ sender: UITapGestureRecognizer) {
        let list = ["Empty", "1/8 of tank","1/4 of tank","3/8 of tank","1/2 of tank","5/8 of tank","3/4 of tank","7/8 of tank", "Full tank"]
        //let list = ["Empty", "1/8 of tank","1/6 of tank", "1/4 of tank", "Half tank", "Full tank"]
        showPickerViewPopUp(list: list, listNameForSelection: AppDropDownLists.FUEL_OUT, notificationName: .listBookingDetails)
    }
    @IBAction func submitBtn(_ sender: UIButton) {
        if selectedProposedVehicleId.isEmpty || selectedProposedVehicleId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showToast(strMessage: selectProposedVehicle)
            return
        }
        
        if self.mileageOutTxtFld.text?.isEmpty ?? true {
            showToast(strMessage: "Please enter mileage out.")
            return
        }
        
        CommonObject.sharedInstance.vehicleId = selectedProposedVehicleId
        
        let expectedDeliveryTime =  (deliveryTimeTxtFld.text ?? "").convertTimeToTwentyFourHr(isAM: deliveryTimeSegmentedControl.selectedSegmentIndex)
        let timeOut = timeOutTxtFld.text?.convertTimeToTwentyFourHr(isAM: timeOutSegmentedControl.selectedSegmentIndex) ?? ""
        let parameters: Parameters = ["application_id": CommonObject.sharedInstance.currentReferenceId,
                                      "proposed_vehicleid": selectedProposedVehicleId,
                                      "expected_delivery_date": deliveryDateTxtFld.text ?? "",
                                      "expected_delivery_time": expectedDeliveryTime,
                                      "delivered_by": UserDefaults.standard.userId(),//selecteddeliveredById,
                                      "delivery_location": dropLocationTxtFld.text ?? "",
                                      "date_out": dateOutTxtFld.text ?? "",
                                      "Mileage_out": mileageOutTxtFld.text ?? "",
                                      "fuel_out": fuelOutTypeLbl.text ?? "",
                                      "time_out": timeOut]//timeOutTxtFld.text ?? ""]
        print(parameters)
        if status == "Returned" {
            apiPostRequest(parameters: parameters, endPoint: EndPoints.UPDATE_BOOKING)
        } else {
            apiPostRequest(parameters: parameters, endPoint: EndPoints.SAVE_BOOKING_DETAILS)
        }
        //apiPostRequest(parameters: parameters, endPoint: EndPoints.SAVE_BOOKING_DETAILS)
    }
    
    @IBAction func deliveryDateCalenderBtnTapped(_ sender: UIButton) {
        showDatePickerPopUp(textField: deliveryDateTxtFld, notificationName: .dateBookingDetails)
    }
    
    @IBAction func dateOutCalenderBtnTapped(_ sender: UIButton) {
        showDatePickerPopUp(textField: dateOutTxtFld, notificationName: .dateBookingDetails)
    }
    
    func copyDataIfRequired(isDateEdited: Bool, isTimeEdited: Bool) {
        if (dateOutTxtFld.text ?? "").isEmpty && isDateEdited {
            dateOutTxtFld.text = deliveryDateTxtFld.text ?? ""
        }
        
        if (timeOutTxtFld.text ?? "").isEmpty && isTimeEdited {
            timeOutTxtFld.text = deliveryTimeTxtFld.text ?? ""
            timeOutSegmentedControl.selectedSegmentIndex = deliveryTimeSegmentedControl.selectedSegmentIndex
        }
    }
    
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEdit))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func endEdit() {
        //        copyDataIfRequired()
        view.endEditing(true)
    }
    @objc func proposedVehicleViewTapped(_ sender: UITapGestureRecognizer) {
        getProposedVehileListAPI()
    }
    @objc func deliveryByViewTapped(_ sender: UITapGestureRecognizer) {
        //deliveryByListAPI()
    }
    
    @objc func ListNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let selectedItem = userInfo["selectedItem"] as? String {
                //                let selectedItemIndex = userInfo["selectedIndex"] as! Int
                switch userInfo["itemSelectedFromList"] as? String {
                case AppDropDownLists.FUEL_OUT:
                    fuelOutTypeLbl.textColor = UIColor(named: AppColors.BLACK)
                    fuelOutTypeLbl.text = selectedItem
                default:
                    print("Unkown List")
                }
            }
        }
    }
    
    @objc func SearchListNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let selectedItem = userInfo["selectedItem"] as! String
            let selectedItemIndex = userInfo["selectedIndex"] as! Int
            switch userInfo["itemSelectedFromList"] as? String {
            case AppDropDownLists.PROPOSED_VEHICLE:
                print(arrProposedVehicle)
                proposedVehicleLbl.textColor = UIColor(named: AppColors.BLACK)
                proposedVehicleLbl.text = selectedItem
                selectedProposedVehicleId = arrProposedVehicle[selectedItemIndex].id
                
//                self.serviceDueInfo.isHidden = arrProposedVehicle[selectedItemIndex].is_service_due == 0
//                self.lastServiceMiles.text = "\(arrProposedVehicle[selectedItemIndex].service_miles_left ?? 0) miles"
                
                
                self.serviceDueInfo.isHidden = false
                if (arrProposedVehicle[selectedItemIndex].service_miles_left ?? 0) < 0 {
                    self.lastServiceMiles.text = "\("\(arrProposedVehicle[selectedItemIndex].service_miles_left ?? 0)".replacingOccurrences(of: "-", with: "")) mi over"
                    self.lastServiceMiles.textColor = UIColor(named: "FF0000")
                } else {
                    self.lastServiceMiles.text = "\(arrProposedVehicle[selectedItemIndex].service_miles_left ?? 0) mi left"
                    self.lastServiceMiles.textColor = UIColor(named: "07B107")
                }
                
//                selectedProposedVehicleId = arrProposedVehicle[selectedItemIndex].fleetId
            default:
                print("Unkown List")
            }
        }
    }
    
    
    @objc func DateNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let selectedDate = userInfo["selectedDate"] as? String {
                let selectedTextField = userInfo["dateTextField"] as! UITextField
                switch selectedTextField {
                case deliveryDateTxtFld:
                    deliveryDateTxtFld.text = selectedDate
                    copyDataIfRequired(isDateEdited: true, isTimeEdited: false)
                case dateOutTxtFld:
                    dateOutTxtFld.text = selectedDate
                default:
                    print("Unkown Date Textfield")
                }
            }
        }
    }
    @objc func TimeNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let selectedTime = userInfo["selectedTime"] as? String {
                let selectedTextField = userInfo["timeTextField"] as! UITextField
                switch selectedTextField {
                case timeOutTxtFld:
                    timeOutTxtFld.text = selectedTime
                    
                default:
                    print("Unkown Time Textfield")
                }
            }
        }
    }
    @objc func DeliveredCollectedBy(_ notification : NSNotification) {
        if let userInfo = notification.userInfo {
            let selectedItem = userInfo["selectedItem"] as! String
            let selectedItemIndex = userInfo["selectedIndex"] as! Int
            switch userInfo["itemSelectedFromList"] as? String {
            case AppDropDownLists.DELIVERED_BY:
                print(arrcollectedBy)
                deliveredCollectedByLbl.textColor = UIColor(named: AppColors.BLACK)
                //print(selectedItem)
                deliveredCollectedByLbl.text = selectedItem
                //Lbl
                print(selectedItem)
            
                selecteddeliveredById = arrcollectedBy[selectedItemIndex].id
                selecteddeliveredByName = arrcollectedBy[selectedItemIndex].user_name
                print(selecteddeliveredById)
                print(selecteddeliveredByName)
            default:
                print("Unknow List")
            }
        }
    }
}

extension BookingDetailsVC: UITextFieldDelegate {
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        var isKeyboard = true
//        switch textField {
////        case dateOutTxtFld:
////            isKeyboard = false
////            showDatePickerPopUp(textField: textField, notificationName: .dateBookingDetails)
//        case timeOutTxtFld:
//            isKeyboard = false
//            showTimePickerPopUp(textField: textField, notificationName: .timeBookingDetails)
//        default:
//            print("Other TextField")
//        }
//        return isKeyboard
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var isAllowed = true
        switch textField {
        case mileageOutTxtFld:
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            isAllowed = allowedCharacters.isSuperset(of: characterSet)
        case deliveryDateTxtFld, dateOutTxtFld:
            isAllowed = textField.validateDateTyped(shouldChangeCharactersInRange: range, replacementString: string)
        case deliveryTimeTxtFld, timeOutTxtFld:
            isAllowed = textField.validateTimeTyped(shouldChangeCharactersInRange: range, replacementString: string)
        default:
            print("TextField without restriction")
        }
        
        return isAllowed
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case mileageOutTxtFld:
            textField.resignFirstResponder()
        default:
            print("Textfield without keyboard")
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case deliveryDateTxtFld:
            copyDataIfRequired(isDateEdited: true, isTimeEdited: false)
        case deliveryTimeTxtFld:
            copyDataIfRequired(isDateEdited: false, isTimeEdited: true)
        default:
            print("Textfield did end editing")
        }
    }
}


extension BookingDetailsVC: BookingDetailsVMDelegate {
    
    
    func bookingDetailsAPISuccess(objData: BookingDetailsModel, strMessage: String, serviceKey: String) {
        if !objData.dictResult.expectedDeliveryDate.isEmpty {
            deliveryDateTxtFld.text = objData.dictResult.expectedDeliveryDate
        }
        
        if !objData.dictResult.expectedDeliveryTime.isEmpty {
            deliveryTimeTxtFld.text = objData.dictResult.expectedDeliveryTime
        }
        
        if !objData.dictResult.deliveryLocation.isEmpty {
            dropLocationTxtFld.text = objData.dictResult.deliveryLocation
        }
        
//        self.serviceDueInfo.isHidden = objData.dictResult.is_service_due == 0
//        self.lastServiceMiles.text = "\(objData.dictResult.service_miles_left ?? 0) miles"
        
 
        
//        if !objData.dictResult.deliveredBy.isEmpty {
//            deliveryByTxtFld.text = objData.dictResult.deliveredBy
//        }
        
        //Proposed vehicle
        if !objData.dictResult.proposedVehicle.isEmpty {
            proposedVehicleLbl.text = objData.dictResult.proposedVehicle
            proposedVehicleLbl.textColor = UIColor(named: AppColors.BLACK)
            selectedProposedVehicleId = objData.dictResult.vehicleId
            
            if let miles = objData.dictResult.service_miles_left {
                self.serviceDueInfo.isHidden = false
                if (miles) < 0 {
                    self.lastServiceMiles.text = "\("\(miles)".replacingOccurrences(of: "-", with: "")) mi over"
                    self.lastServiceMiles.textColor = UIColor(named: "FF0000")
                } else {
                    self.lastServiceMiles.text = "\(miles) mi left"
                    self.lastServiceMiles.textColor = UIColor(named: "07B107")
                }
            } else {
                self.serviceDueInfo.isHidden = true
            }
        }
        if !objData.dictResult.deliveredBy.isEmpty {
            deliveredCollectedByLbl.text = objData.dictResult.deliveredByname
            deliveredCollectedByLbl.textColor = UIColor(named: AppColors.BLACK)
            selecteddeliveredById = objData.dictResult.deliveredBy
        }
        
        if !objData.dictResult.dateOut.isEmpty {
            dateOutTxtFld.text = objData.dictResult.dateOut
        }
        if !objData.dictResult.mileageOut.isEmpty {
            mileageOutTxtFld.text = objData.dictResult.mileageOut
        }
        if !objData.dictResult.fuelOut.isEmpty {
            fuelOutTypeLbl.text = objData.dictResult.fuelOut
            fuelOutTypeLbl.textColor = UIColor(named: AppColors.BLACK)
        }
        if !objData.dictResult.timeOut.isEmpty {
            let timeOut = objData.dictResult.timeOut
            timeOutSegmentedControl.setUpAmPM(time: timeOut)
            timeOutTxtFld.text = timeOut.DatePresentable?.getDateAccoringTo(format: .Time12Hr) ?? ""
        }
        if !objData.dictResult.status.isEmpty {
            status = objData.dictResult.status
            print(status)
            if status == "Returned" {
                print("Returned")
            } else {
                print("Hired")
            }
        }
    }
    
    func bookingDetailsAPISuccess(objData: ProposedVehicleModel, strMessage: String, serviceKey: String) {
//        if objData.arrResult.count > 0 {
//            var temp = [String] ()
//            for i in 0...objData.arrResult.count-1 {
//                temp.append(objData.arrResult[i].registrationNumber)
//            }
//            arrProposedVehicle = objData.arrResult
//            showSearchListPopUp(listForSearch: temp, listNameForSearch: AppDropDownLists.PROPOSED_VEHICLE, notificationName: .searchListBookingDetails)
//        }
    }
    
    func bookingDetailsAPISuccess(objData: AvailableVehicleDropDownListModel, strMessage: String, serviceKey: String) {
        if objData.arrResult.count > 0 {
            var temp = [String] ()
            for i in 0...objData.arrResult.count-1 {
                temp.append(objData.arrResult[i].registration_no)
            }
            arrProposedVehicle = objData.arrResult
            showSearchListPopUp(listForSearch: temp, listNameForSearch: AppDropDownLists.PROPOSED_VEHICLE, notificationName: .searchListBookingDetails)
        }
    }
    
    
    
    func bookingDetailsAPISuccess(strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
        if serviceKey == EndPoints.SAVE_BOOKING_DETAILS {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                self.dismiss(animated: true)
            })
        }
        if serviceKey == EndPoints.UPDATE_BOOKING {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                self.dismiss(animated: true)
            })
        }
    }
    
    func bookingDetailsAPIFailure(strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
    }
}
extension BookingDetailsVC : DeliveredCollectedByVMDelegate {
    func deliveredCollectedByAPISuccess(strMessage: String, serviceKey: String) {
        
    }
    
    func deliveredCollectedByAPISuccess(objData: DeliveredCollectedByModel, strMessage: String, serviceKey: String) {
        print("\(objData.arrResult)")
        if objData.arrResult.count > 0 {
            var temp = [String] ()
            for i in 0...objData.arrResult.count-1 {
                temp.append(objData.arrResult[i].user_name)
            }
            arrcollectedBy = objData.arrResult
            showSearchListPopUp(listForSearch: temp, listNameForSearch: AppDropDownLists.DELIVERED_BY, notificationName: .deliveredCollectedBy)
        }
    }
    
    func deliveredCollectedByAPIFailure(strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
    }
}
