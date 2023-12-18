//
//  BookingDetailsVC.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 26/08/21.
//

//import UIKit
//import Alamofire
//import Toast_Swift
//class BookingDetailsVC: UIViewController {
//    var dictBookingDetails = BookingDetailsModelData()
//    @IBOutlet weak var dateOutTxtFld: UITextField!
//    @IBOutlet weak var timeOutTxtFld: UITextField!
//    @IBOutlet weak var mileageOutTxtFld: UITextField!
//    @IBOutlet weak var fuelOutLbl: UILabel!
//    @IBOutlet weak var cardHolderNameTxtFld: UITextField!
//    @IBOutlet weak var cardTypeLbl: UILabel!
//    @IBOutlet weak var cardNumberTxtFld: UITextField!
//    @IBOutlet weak var expiryDateTxtFld: UITextField!
//    @IBOutlet weak var cvvTxtFld: UITextField!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        hideKeyboardWhenTappedAround()
//        NotificationCenter.default.addObserver(self, selector: #selector(self.ListNotificationAction(_:)), name: .listBookingDetails, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.DateNotificationAction(_:)), name: .dateBookingDetails, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.TimeNotificationAction(_:)), name: .timeBookingDetails, object: nil)
//        setUpExistingBookingDetailsData()
//        //To get already existing details if any
//        //let parameters : Parameters = [:]
//        //apiGetRequest(parameters: parameters, endPoint: EndPoints.GET_BOOKING_DETAILS)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        NotificationCenter.default.removeObserver(self)//Removes all notifications being observed
////        let vc = UIStoryboard(name: AppStoryboards.DASHBOARD, bundle: Bundle.main).instantiateViewController(withIdentifier: AppStoryboardId.UPLOAD_DOCUMENTS) as! UploadDocumentsVC
////        vc.isDataRefreshNeeded = true
//    }
//    
//    func apiPostRequest(parameters: Parameters,endPoint: String){
//        CommonObject.sharedInstance.showProgress()
//        let obj = BookingDetailsViewModel()
//        obj.delegate = self
//        obj.postBookingDetails(currentController: self, parameters: parameters, endPoint: endPoint)
//    }
//    
//    func apiGetRequest(parameters: Parameters?,endPoint: String) {
//        CommonObject.sharedInstance.showProgress()
//        let obj = BookingDetailsViewModel()
//        obj.delegate = self
//        obj.getBookingDetails(currentController: self, parameters: parameters, endPoint: endPoint)
//    }
//    
//    func setUpExistingBookingDetailsData() {
////        dateOutTxtFld.text = dictBookingDetails.dateOut
////        timeOutTxtFld.text = dictBookingDetails.timeOut
////        mileageOutTxtFld.text = dictBookingDetails.mileageOut
////        if !dictBookingDetails.fuelOut.isEmpty {
////            fuelOutLbl.text = dictBookingDetails.fuelOut
////            fuelOutLbl.textColor = UIColor(named: AppColors.BLACK)
////        }
//        cardHolderNameTxtFld.text = dictBookingDetails.cardHolderName
//        if !dictBookingDetails.cardType.isEmpty {
//            cardTypeLbl.text = dictBookingDetails.cardType
//            cardTypeLbl.textColor = UIColor(named: AppColors.BLACK)
//        }
//        cardNumberTxtFld.text = dictBookingDetails.cardNumber
//        expiryDateTxtFld.text = dictBookingDetails.expiryDate
//        cvvTxtFld.text = dictBookingDetails.cvv
//    }
//    
//    @IBAction func fuelOutTapped(_ sender: UITapGestureRecognizer) {
//        let list = ["Empty","Half","Full"]
//        showPickerViewPopUp(list: list, listNameForSelection: AppDropDownLists.FUEL_OUT, notificationName: .listBookingDetails)
//    }
//    
//    @IBAction func cardTypeTapped(_ sender: UITapGestureRecognizer) {
//        let list = ["Master Card","Visa Card","Amex Card", "Diners Card"]
//        showPickerViewPopUp(list: list, listNameForSelection: AppDropDownLists.CARD_TYPE, notificationName: .listBookingDetails)
//    }
//    @IBAction func closeBtn(_ sender: UIButton) {
//        dismiss(animated: true, completion: nil)
//    }
//    @IBAction func submitBtn(_ sender: UIButton) {
//        let parameters : Parameters = ["application_id": CommonObject.sharedInstance.currentReferenceId,
//                                       "date_out":dateOutTxtFld.text!,
//                                       "Mileage_out": mileageOutTxtFld.text!,
//                                       "fuel_out":fuelOutLbl.text!,
//                                       "time_out":timeOutTxtFld.text!,
//                                       "exp_date": expiryDateTxtFld.text!,
//                                       "cardholder_name": cardHolderNameTxtFld.text!,
//                                       "card_type":cardTypeLbl.text!,
//                                       "card_no": cardNumberTxtFld.text!,
//                                       "cvv":cvvTxtFld.text!,
//                                       "user_id" : UserDefaults.standard.userId()]
//        apiPostRequest(parameters: parameters, endPoint: EndPoints.SAVE_BOOKING_DETAILS)
//    }
//
//    
//    @objc func ListNotificationAction(_ notification: NSNotification) {
//        if let userInfo = notification.userInfo {
//           if let selectedItem = userInfo["selectedItem"] as? String {
//            let selectedItemIndex = userInfo["selectedIndex"] as! Int
//            switch userInfo["itemSelectedFromList"] as? String {
//            case AppDropDownLists.CARD_TYPE:
//                cardTypeLbl.textColor = UIColor(named: AppColors.BLACK)
//                cardTypeLbl.text = selectedItem
////                selectedDocumentId = arrDocumentList[selectedItemIndex].documentId
//            case AppDropDownLists.FUEL_OUT:
//                fuelOutLbl.textColor = UIColor(named: AppColors.BLACK)
//                fuelOutLbl.text = selectedItem
//            default:
//                print("Unkown List")
//            }
//            }
//        }
//    }
//    @objc func DateNotificationAction(_ notification: NSNotification) {
//        if let userInfo = notification.userInfo {
//           if let selectedDate = userInfo["selectedDate"] as? String {
//            let selectedTextField = userInfo["dateTextField"] as! UITextField
//            switch selectedTextField {
//            case dateOutTxtFld:
//                dateOutTxtFld.text = selectedDate
////            case expiryDateTxtFld:
////                expiryDateTxtFld.text = selectedDate
////                let selectedYear = userInfo[DatePickerKeys.SELECTED_YEAR] as? String
////                let selectedMonth = userInfo[DatePickerKeys.SELECTED_MONTH] as? String
////                expiryDateTxtFld.text = selectedYear! + "-" + selectedMonth!
//            default:
//                print("Unkown Date Textfield")
//            }
//            }
//        }
//    }
//    @objc func TimeNotificationAction(_ notification: NSNotification) {
//        if let userInfo = notification.userInfo {
//           if let selectedTime = userInfo["selectedTime"] as? String {
//            let selectedTextField = userInfo["timeTextField"] as! UITextField
//            switch selectedTextField {
//            case timeOutTxtFld:
//                timeOutTxtFld.text = selectedTime
//            
//            default:
//                print("Unkown Time Textfield")
//            }
//            }
//        }
//    }
//    
//}
//
//extension BookingDetailsVC : UITextFieldDelegate {
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        
//    }
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        var isKeyboard = true
//        switch textField {
//        case dateOutTxtFld:
//            isKeyboard = false
//            showDatePickerPopUp(textField: textField, notificationName: .dateBookingDetails)
//        case timeOutTxtFld:
//            isKeyboard = false
//            showTimePickerPopUp(textField: textField, notificationName: .timeBookingDetails)
//        default:
//            print("Other TextField")
//        }
//        return isKeyboard
//    }
//    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        var isAllowed = true
//        switch textField {
//        case mileageOutTxtFld,cvvTxtFld:
//            let allowedCharacters = CharacterSet.decimalDigits
//            let characterSet = CharacterSet(charactersIn: string)
//            isAllowed = allowedCharacters.isSuperset(of: characterSet)
////            if textField == cvvTxtFld {
////                //For limiting length
////                guard let textFieldText = textField.text,
////                    let rangeOfTextToReplace = Range(range, in: textFieldText) else {
////                            return false
////                    }
////                //For restricting characters
////                let substringToReplace = textFieldText[rangeOfTextToReplace]
////                let count = textFieldText.count - substringToReplace.count + string.count
////                isAllowed = isAllowed && count < 4
////            }
//        case cardNumberTxtFld:
//            isAllowed =  textField.formatCardNumber(shouldChangeCharactersInRange: range, replacementString: string)
//        case cardHolderNameTxtFld :
//            let allowedCharacters = CharacterSet.letters
//            let characterSet = CharacterSet(charactersIn: string)
//            isAllowed = allowedCharacters.isSuperset(of: characterSet)
//        default:
//            print("TextField without restriction")
//        }
//
//        return isAllowed
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        switch textField {
//        case mileageOutTxtFld:
//            textField.resignFirstResponder()
//        case cardHolderNameTxtFld:
//            textField.resignFirstResponder()
//        case cardNumberTxtFld:
//            textField.resignFirstResponder()
//        case cvvTxtFld:
//            textField.resignFirstResponder()
//        default:
//            print("Error")
//        }
//          return true
//    }
//}
//
//extension BookingDetailsVC : BookingDetailsVMDelegate {
//    func bookingDetailsAPISuccess(strMessage: String, serviceKey: String) {
//        switch serviceKey {
//        case EndPoints.SAVE_BOOKING_DETAILS:
//            NotificationCenter.default.post(name: .reloadUploadDocuments, object: self, userInfo: nil)
//            dismiss(animated: true, completion: nil)
//            let windows = UIApplication.shared.windows
//            windows.last?.makeToast(strMessage)
////            let vc = UIStoryboard(name: AppStoryboards.DASHBOARD, bundle: Bundle.main).instantiateViewController(withIdentifier: AppStoryboardId.UPLOAD_DOCUMENTS)
////            vc.view.makeToast(strMessage)
//        default:
//            print("Unknown Service Key")
//        }
//    }
//    
////    func bookingDetailsAPISuccess(objData: BookingDetailsModel, strMessage: String, serviceKey: String) {
////        print(objData)
////    }
//    
//    func bookingDetailsAPIFailure(strMessage: String, serviceKey: String) {
//        showToast(strMessage: strMessage)
//    }
//}
