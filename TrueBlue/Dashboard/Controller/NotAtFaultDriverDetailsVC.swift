//
//  NotAtFaultDriverDetailsVC.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 20/08/21.
//

import UIKit
import Alamofire
import JVFloatLabeledTextField
class NotAtFaultDriverDetailsVC: UIViewController {
    
    @IBOutlet weak var referenceIDTxtFld: UITextField!
    
    @IBOutlet weak var deliveryDateTxtFld: UITextField!
    
    @IBOutlet weak var bookingDetailsBtn: UIButton!
    var isProposedVehicleSaved = false
    //    var selectedDeliveryDate = String()
    @IBOutlet weak var proposedVehicleLbl: UILabel!
    @IBOutlet weak var fullNameTxtFld: UITextField!
    @IBOutlet weak var emailTxtFld: UITextField!
    
    @IBOutlet weak var phoneTxtFld: UITextField!
    @IBOutlet weak var licenceNumberTxtFld: UITextField!
    @IBOutlet weak var licenceExpiryTxtFld: UITextField!
//    var selectedLicenceExpiryDate = String()
    @IBOutlet weak var dateOfBirthTxtFld: UITextField!
    
    @IBOutlet weak var diliveryDateTxtFld: UITextField!
    
    @IBOutlet weak var deliveryByTxtFld: UITextField!
    @IBOutlet weak var streetAddressTxtFld: UITextField!
    @IBOutlet weak var suburbTxtFld: UITextField!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var postalCodeTxtFld: UITextField!
    @IBOutlet weak var clientMakeOrModalTxtFld: UITextField!
    @IBOutlet weak var registrationNumberTxtFld: UITextField!
    @IBOutlet weak var insuranceCompanyLbl: UILabel!
    @IBOutlet weak var dateOfAccidentTxtFld: UITextField!
    @IBOutlet weak var timeOfAccidentTxtFld: UITextField!
    @IBOutlet weak var accidentLocationTxtFld: UITextField!
    @IBOutlet weak var claimNumberTxtfld: UITextField!
    @IBOutlet weak var repairerNameLbl: UILabel!
    @IBOutlet weak var referralNameTxtFld: UITextField!
    @IBOutlet weak var expectedDeliveryTimeTxtFld: UITextField!
    
    @IBOutlet weak var branchLbl: UILabel!
    @IBOutlet weak var referralNameLbl: UILabel!
    
    @IBOutlet weak var deliveryTimeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var dropLocationTxtFld: UITextField!
    @IBOutlet weak var vehicleBusinessRegisteredYesBtn: UIButton!
    @IBOutlet weak var vehicleBusinessRegisteredNoBtn: UIButton!
    @IBOutlet weak var accidentDescriptionTxtView: UITextView!
    
    @IBOutlet weak var timeOfAccidentSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var recoveryForView: InputView!
    
//    @IBOutlet weak var recoveryLbl: UILabel!
    
    @IBOutlet weak var txtRecoveryView: JVFloatLabeledTextField!
    
    var isVehicleBusinessRegistered = ""
    var dictDetails = NotAtFaultDriverDetailsModelData()
    var arrInsuranceCompaniesNotAtFault = [InsuranceCompanyListModelData]()
    var arrStatesNotAtFault = [StateListModelData]()
    var arrProposedVehicle = [ProposedVehicleModelData]()
    var arrRepairer = [RepairerListModelData]()
    var arrReferral = [ReferralListModelData]()
    var arrBranch = [BranchListModelData]()
    var selectedStateId = String()
    var selectedRepairerId = String()
    var selectedReferralId = String()
    var selectedBranchID = String()
    var selectedInsuranceCompanyId = String()
    var selectedProposedVehicleId = String()
    var isFromAddSecondTier = false
    var isFromAddThirdTier = false
    var isFromBookingDetails = false
    var selectedRecovery = String()
    
    var picker = UIPickerView()
    
    var recoveryForArr = ["Trueblue", "Repairer"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CommonObject.sharedInstance.vehicleId = ""
        
        self.picker.delegate = self
        self.picker.dataSource = self
        self.txtRecoveryView.inputView = self.picker
        
        
        referenceIDTxtFld.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
        hideKeyboardWhenTappedAround()
        CommonObject.sharedInstance.isDataChangedInCurrentTab = false//Data has not been edited yet
        if CommonObject.sharedInstance.isNewEntry && UserDefaults.standard.GetReferenceId().isEmpty{
            //Getting a new reference id
//            if (fullNameTxtFld.text ?? "").isEmpty {
//
//            } else {
//                apiPostRequest(parameters: [:], endPoint: EndPoints.ADD_NEW_ENTRY_ID)
            CommonObject.sharedInstance.currentReferenceId = "0"
            referenceIDTxtFld.text = CommonObject.sharedInstance.currentReferenceId
            let parameters : Parameters = ["application_id" : CommonObject.sharedInstance.currentReferenceId]
            apiPostRequest(parameters: parameters, endPoint: EndPoints.GET_NOT_AT_FAULT_DRIVER_DETAILS)
//            }
            //apiPostRequest(parameters: [:], endPoint: EndPoints.ADD_NEW_ID)
        } else {
            //Getting details of already existing reference id
//            if CommonObject.sharedInstance.currentReferenceId.isEmpty{
//                CommonObject.sharedInstance.currentReferenceId = UserDefaults.standard.GetReferenceId()
//            }
            if CommonObject.sharedInstance.isNewEntry {
                CommonObject.sharedInstance.currentReferenceId = UserDefaults.standard.GetReferenceId()
            }
            referenceIDTxtFld.text = CommonObject.sharedInstance.currentReferenceId
            let parameters : Parameters = ["application_id" : CommonObject.sharedInstance.currentReferenceId]
            apiPostRequest(parameters: parameters, endPoint: EndPoints.GET_NOT_AT_FAULT_DRIVER_DETAILS)
        }
        
        //Setting up radio button images
        vehicleBusinessRegisteredYesBtn.setImage(UIImage(named: AppImageNames.RADIO_BTN_UNSELECTED), for: .normal)
        vehicleBusinessRegisteredYesBtn.setImage(UIImage(named: AppImageNames.RADIO_BTN_SELECTED), for: .selected)
        vehicleBusinessRegisteredNoBtn.setImage(UIImage(named: AppImageNames.RADIO_BTN_UNSELECTED), for: .normal)
        vehicleBusinessRegisteredNoBtn.setImage(UIImage(named: AppImageNames.RADIO_BTN_SELECTED), for: .selected)
        //Adding Notification observers
        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchListNotificationAction(_:)), name: .searchListNotAtFault, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DateNotificationAction(_:)), name: .dateNotAtFault, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.TimeNotificationAction(_:)), name: .timeNotAtFault, object: nil)
//        setUpTimeSegmentedControls()
        setViews()
        
//        let recoveryTap = UITapGestureRecognizer(target: self, action: #selector(recoveryForViewTapped))
//        recoveryForView.addGestureRecognizer(recoveryTap)
    }
    
    func setViews() {
        deliveryDateTxtFld.keyboardType = .numberPad
        licenceExpiryTxtFld.keyboardType = .numberPad
        dateOfBirthTxtFld.keyboardType = .numberPad
        diliveryDateTxtFld.keyboardType = .numberPad
        dateOfAccidentTxtFld.keyboardType = .numberPad
        timeOfAccidentTxtFld.keyboardType = .numberPad
        expectedDeliveryTimeTxtFld.keyboardType = .numberPad
        deliveryTimeSegmentedControl.setUpAmPmSegmentedControl()
        timeOfAccidentSegmentedControl.setUpAmPmSegmentedControl()
        deliveryTimeSegmentedControl.addTarget(self, action: #selector(isSegmentIndexChanged), for: .valueChanged)
        timeOfAccidentSegmentedControl.addTarget(self, action: #selector(isSegmentIndexChanged), for: .valueChanged)
    }
    
    func apiPostRequest(parameters: Parameters,endPoint: String){
        CommonObject.sharedInstance.showProgress()
        let obj = NotAtFaultDriverDetailsViewModel()
        obj.delegate = self
        obj.postNotAtFaultDriverDetails(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    func apiGetRequest(parameters: Parameters?,endPoint: String) {
        CommonObject.sharedInstance.showProgress()
        let obj = NotAtFaultDriverDetailsViewModel()
        obj.delegate = self
        obj.getNotAtFaultDriverDetails(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    
    
    func saveNotAtFaultDetails() {
        
        if (self.referenceIDTxtFld.text ?? "") == "" || (self.referenceIDTxtFld.text ?? "") == "0" {
            if !(emailTxtFld.text ??  "").trimmingCharacters(in: .whitespaces).isEmpty {
                if !(emailTxtFld.text ??  "").isValidEmailAddress() {
                    showToast(strMessage: validEmailRequired)
                    return
                }
            }
            if (fullNameTxtFld.text ?? "").isEmpty {
                showToast(strMessage: fullNameRequired)
                return
            }
            
            if (phoneTxtFld.text ?? "").isEmpty {
                showToast(strMessage: phoneNumberRequired)
                return
            }
            
            if (licenceExpiryTxtFld.text ?? "").isEmpty {
                showToast(strMessage: licenceexpirydateRequired)
                return
            }
            
            if (dateOfBirthTxtFld.text ?? "").isEmpty {
                showToast(strMessage: dobdateRequired)
                return
            }
            
            if (diliveryDateTxtFld.text ?? "").isEmpty {
                showToast(strMessage: diliverydateRequired)
                return
            }
            
//            if !validateAge() {
//                showToast(strMessage: requiredHirerAge21)
//                return
//            }
            
//            if !isFromBookingDetails {
//                if CommonObject.sharedInstance.vehicleId == "" {
//                    showToast(strMessage: "Please add booking details")
//                    return
//                }
//            }
        }


        
        print(selectedBranchID)
        
        let expectedDeliveryTime = expectedDeliveryTimeTxtFld.text?.convertTimeToTwentyFourHr(isAM: timeOfAccidentSegmentedControl.selectedSegmentIndex) ?? ""
        let timeOfAccident = timeOfAccidentTxtFld.text?.convertTimeToTwentyFourHr(isAM: timeOfAccidentSegmentedControl.selectedSegmentIndex) ?? ""
        let parameters : Parameters = ["application_id" : CommonObject.sharedInstance.currentReferenceId,
                                       "user_id" : UserDefaults.standard.userId(),
//                                       "expected_delivery_date" : deliveryDateTxtFld.text ?? "",
                                       "owner_name" : fullNameTxtFld.text ?? "",
                                       "owner_email" : emailTxtFld.text ?? "",
                                       "owner_phone" : phoneTxtFld.text ?? "",
                                       "owner_lic" : licenceNumberTxtFld.text ?? "",
                                       "ownerlic_exp" : licenceExpiryTxtFld.text ?? "",
                                       "owner_dob" : dateOfBirthTxtFld.text ?? "",
                                       "expected_delivery_date" : diliveryDateTxtFld.text ?? "",
//                                       "delivered_by" : deliveryByTxtFld.text ?? "",
                                       "is_business_registered" : isVehicleBusinessRegistered,
                                       "owner_street" : streetAddressTxtFld.text ?? "",
                                       "owner_suburb" : suburbTxtFld.text ?? "",
                                       "owner_state" : selectedStateId,
                                       "owner_postcode" : postalCodeTxtFld.text ?? "",
                                       "owner_country" : "Australia",
                                       "owner_make_model" : clientMakeOrModalTxtFld.text ?? "",
                                       "owner_registration_no" : registrationNumberTxtFld.text ?? "",
                                       "insurance" : selectedInsuranceCompanyId,
                                       "dateof_accident" : dateOfAccidentTxtFld.text ?? "",
                                       "timeofaccident" : timeOfAccident, //timeOfAccidentTxtFld.text!,
                                       "accident_location": accidentLocationTxtFld.text ?? "",
                                       "owner_claimno": claimNumberTxtfld.text ?? "",
                                       "repairer_name" : selectedRepairerId,
                                       "referral_name" : selectedReferralId,
                                       "branch"  : selectedBranchID,
//                                       "expected_delivery_time": expectedDeliveryTime, //expectedDeliveryTimeTxtFld.text ?? "",
//                                       "delivery_location" :dropLocationTxtFld.text ?? "",
//                                       "proposed_vehicle": selectedProposedVehicleId,
                                       "recovery_for"  : selectedRecovery.lowercased(),
                                       "description": accidentDescriptionTxtView.text ?? ""]
        print(parameters)
        apiPostRequest(parameters: parameters, endPoint: EndPoints.SAVE_NOT_AT_FAULT_DRIVER_DETAILS)
    }
    
    func getDetailsForReferenceID() {
        if !CommonObject.sharedInstance.isDataChangedInCurrentTab {
            //Calling API only if data has not been changed , reference id not equal to current one or user does not want to save data
            if CommonObject.sharedInstance.currentReferenceId != referenceIDTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines) {
                let parameters : Parameters = ["application_id" : referenceIDTxtFld.text ?? ""]
                apiPostRequest(parameters: parameters, endPoint: EndPoints.GET_NOT_AT_FAULT_DRIVER_DETAILS)
            }
        }
    }
    
    func openBookingDetails() {
        var storyboardName = String()
        var vcId = String()
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboardName = AppStoryboards.DASHBOARD
            vcId = AppStoryboardId.BOOKING_DETAILS
        } else {
            storyboardName = AppStoryboards.DASHBOARD_PHONE
            vcId = AppStoryboardId.BOOKING_DETAILS_PHONE
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        let alertVc = storyboard.instantiateViewController(identifier: vcId) as! BookingDetailsVC
//        alertVc.selectedProposedVehicleId = self.selectedProposedVehicleId
//        alertVc.selectedDateOut = deliveryDateTxtFld.text ?? ""
//        alertVc.selectedTimeOut = (expectedDeliveryTimeTxtFld.text ?? "").convertTimeToTwentyFourHr(isAM: deliveryTimeSegmentedControl.selectedSegmentIndex)
        alertVc.modalPresentationStyle = .overFullScreen
        self.present(alertVc, animated: true, completion: nil)
    }
    
    
    
    @IBAction func deliveryDateCalenderBtn(_ sender: UIButton) {
        showDatePickerPopUp(textField: deliveryDateTxtFld, notificationName: .dateNotAtFault)
    }
    
    @IBAction func licenceExpiryCalenderBtn(_ sender: UIButton) {
        showDatePickerPopUp(textField: licenceExpiryTxtFld, notificationName: .dateNotAtFault)
    }
    @IBAction func dateOfBirthCalenderBtn(_ sender: UIButton) {
        showDatePickerPopUp(textField: dateOfBirthTxtFld, notificationName: .dateNotAtFault)
    }
    
    @IBAction func diliveryDateCalenderBtn(_ sender: UIButton) {
        showDatePickerPopUp(textField: diliveryDateTxtFld, notificationName: .dateNotAtFault)
    }
    
    @IBAction func dateOfAccidentCalenderBtn(_ sender: UIButton) {
        showDatePickerPopUp(textField: dateOfAccidentTxtFld, notificationName: .dateNotAtFault)
    }
    
    @IBAction func bookingDetailsBtn(_ sender: UIButton) {
//        if !isProposedVehicleSaved {
//            showToast(strMessage: saveProposedVehicle)
//            return
//        }
        
        
//        isFromBookingDetails
        
        if (self.referenceIDTxtFld.text ?? "") != "" || (self.referenceIDTxtFld.text ?? "") != "0" {
            isFromBookingDetails = true
            saveNotAtFaultDetails()
            return
        }
        
        if (fullNameTxtFld.text ?? "").isEmpty {
            showToast(strMessage: fullNameRequired)
            return
        }
        
        if (phoneTxtFld.text ?? "").isEmpty {
            showToast(strMessage: phoneNumberRequired)
            return
        }
        
        if UserDefaults.standard.GetReferenceId().isEmpty{
            isFromBookingDetails = true
            saveNotAtFaultDetails()

        }else{
            
            if CommonObject.sharedInstance.isDataChangedInCurrentTab {
                let alert = UIAlertController(title: "Warning!", message: unsavedData, preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                    CommonObject.sharedInstance.isDataChangedInCurrentTab = false
                    self.openBookingDetails()
                }
                let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                alert.addAction(yesAction)
                alert.addAction(noAction)
                present(alert, animated: true, completion: nil)
            } else {
                openBookingDetails()
            }
        }
    }
    
    
    
    @IBAction func stateListTapped(_ sender: UITapGestureRecognizer) {
        apiGetRequest(parameters: nil, endPoint: EndPoints.STATE_LIST)
    }
    
    @IBAction func proposedVehicleListTapped(_ sender: UITapGestureRecognizer) {
        apiGetRequest(parameters: nil, endPoint: EndPoints.PROPOSED_VEHICLE)
    }
    @IBAction func insuranceListTapped(_ sender: UITapGestureRecognizer) {
        apiGetRequest(parameters: nil, endPoint: EndPoints.INSURANCE_COMPANY_LIST)
    }
    
    @objc func recoveryForViewTapped(_ sender: UITapGestureRecognizer) {
//        getProposedVehileListAPI()
        var recoveryForArr = [String] ()
        recoveryForArr.append("Trueblue")
        recoveryForArr.append("Repairer")
        
        showSearchListPopUp(listForSearch: recoveryForArr, listNameForSearch: AppDropDownLists.RECOVERY_FOR, notificationName: .searchListNotAtFault)
    }
    
    
//    @IBAction func refferralName(_ sender: Any) {
//        apiGetRequest(parameters: nil, endPoint: EndPoints.REPAIRER_LIST)
//    }
    @IBAction func refferralNameTapped(_ sender: UITapGestureRecognizer) {
       apiGetRequest(parameters: nil, endPoint: EndPoints.REFERRAL_LIST)
    }
    
    @IBAction func repairerListTapped(_ sender: UITapGestureRecognizer) {
        apiGetRequest(parameters: nil, endPoint: EndPoints.REPAIRER_LIST)
    }
    
    @IBAction func branchListTapped(_ sender: UITapGestureRecognizer) {
        apiGetRequest(parameters: nil, endPoint: EndPoints.BRANCH_LIST)
    }
    
    @IBAction func vehicleBusinessRegisteredYesBtn(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.vehicleBusinessRegisteredNoBtn.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                }) { (success) in
                    UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                        sender.isSelected = !sender.isSelected
                        if sender.isSelected {
                            self.isVehicleBusinessRegistered = "yes"
                        }
                        self.vehicleBusinessRegisteredNoBtn.isSelected = !self.vehicleBusinessRegisteredYesBtn.isSelected
                        self.vehicleBusinessRegisteredNoBtn.transform = .identity
                        sender.transform = .identity
                    }, completion: nil)
                }
    }
    
    @IBAction func vehicleBusinessRegisteredNoBtn(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.vehicleBusinessRegisteredYesBtn.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                }) { (success) in
                    UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                        sender.isSelected = !sender.isSelected
                        if sender.isSelected {
                            self.isVehicleBusinessRegistered = "no"
                        }
                        self.vehicleBusinessRegisteredYesBtn.isSelected = !self.vehicleBusinessRegisteredNoBtn.isSelected
                        self.vehicleBusinessRegisteredYesBtn.transform = .identity
                        sender.transform = .identity
                    }, completion: nil)
                }
    }
    
    @IBAction func accidentDiagramBtnTapped(_ sender: UIButton) {
        var vc = UIViewController()
        if UIDevice.current.userInterfaceIdiom == .pad {
            vc = UIStoryboard(name: AppStoryboards.DASHBOARD, bundle: .main).instantiateViewController(withIdentifier: AppStoryboardId.DIAGRAM)
        } else {
            vc = UIStoryboard(name: AppStoryboards.DASHBOARD_PHONE, bundle: .main).instantiateViewController(withIdentifier: AppStoryboardId.DIAGRAM)
        }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    @IBAction func addSeconHirerBtn(_ sender: UIButton) {
        
        if (self.referenceIDTxtFld.text ?? "") != "" || (self.referenceIDTxtFld.text ?? "") != "0" {
            isFromAddSecondTier = true
            saveNotAtFaultDetails()
            return
        }
        
        if (fullNameTxtFld.text ?? "").isEmpty {
            showToast(strMessage: fullNameRequired)
            return
        }
        
        if (phoneTxtFld.text ?? "").isEmpty {
            showToast(strMessage: phoneNumberRequired)
            return
        }
        
        if UserDefaults.standard.GetReferenceId().isEmpty{
            isFromAddSecondTier = true
            saveNotAtFaultDetails()

        }else{
            var storyboard = String()
            var vcId = String()
            if UIDevice.current.userInterfaceIdiom == .pad {
                storyboard = AppStoryboards.DASHBOARD
                vcId = AppStoryboardId.ADD_HIRER
            } else {
                storyboard = AppStoryboards.DASHBOARD_PHONE
                vcId = AppStoryboardId.ADD_HIRER_PHONE
            }
            let vc = UIStoryboard(name: storyboard, bundle: Bundle.main).instantiateViewController(withIdentifier: vcId) as! AddHirerVC
            vc.hirerNumber = 2
            present(vc, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func addThirdHirerBtn(_ sender: UIButton) {
        
        if (self.referenceIDTxtFld.text ?? "") != "" || (self.referenceIDTxtFld.text ?? "") != "0" {
            isFromAddThirdTier = true
            saveNotAtFaultDetails()
            return
        }
        
        if (fullNameTxtFld.text ?? "").isEmpty {
            showToast(strMessage: fullNameRequired)
            return
        }
        
        if (phoneTxtFld.text ?? "").isEmpty {
            showToast(strMessage: phoneNumberRequired)
            return
        }
        
        if UserDefaults.standard.GetReferenceId().isEmpty{
            isFromAddThirdTier = true
            saveNotAtFaultDetails()
        }else{
            var storyboard = String()
            var vcId = String()
            if UIDevice.current.userInterfaceIdiom == .pad {
                storyboard = AppStoryboards.DASHBOARD
                vcId = AppStoryboardId.ADD_HIRER
            } else {
                storyboard = AppStoryboards.DASHBOARD_PHONE
                vcId = AppStoryboardId.ADD_HIRER_PHONE
            }
            let vc = UIStoryboard(name: storyboard, bundle: Bundle.main).instantiateViewController(withIdentifier: vcId) as! AddHirerVC
            vc.hirerNumber = 3
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveAsDraftBtn(_ sender: UIButton) {
        if CommonObject.sharedInstance.isDataChangedInCurrentTab {
//            if !(fullNameTxtFld.text ?? "").isEmpty {
//                showToast(strMessage: fullNameRequired)
//                return
//            }
            saveNotAtFaultDetails()
        } else {
            showToast(strMessage: noChangeinData)
            
        }
    }
    
    @objc func licenceExpiredAlert() {
        let strDate = licenceExpiryTxtFld.text ?? ""
        if let date = strDate.date(from: .ddmmyyyy), date < Date() {
            showAlert(title: "Expired Date!", message: expiredLicenseDateEntered, yesTitle: "Yes", noTitle: "No", yesAction: {
                
            }, noAction: {
                self.licenceExpiryTxtFld.text = ""
            })
        }
    }
    
    @objc func dateOfBirthAlert() {
        let strDate = dateOfBirthTxtFld.text ?? ""
        let age = strDate.calculateAge(format: DateFormat.ddmmyyyy.rawValue)
        print(age)
        if age.year < 0 {
            dateOfBirthTxtFld.text = ""
            showToast(strMessage: futureDobEntered)
        } else if (age.year == 0 && (age.month > 0 || age.day > 0)) ||  (age.year > 0 && age.year < 21) {
            showAlert(message: requiredHirerAge, yesTitle: "Yes", noTitle: "No", yesAction: {

            }, noAction: {
                self.dateOfBirthTxtFld.text = ""
            })
        }
    }
    
    func validateAge() -> Bool {
        let strDate = dateOfBirthTxtFld.text ?? ""
        let age = strDate.calculateAge(format: DateFormat.ddmmyyyy.rawValue)
        print(age)
        if (age.year == 0 && (age.month > 0 || age.day > 0)) ||  (age.year > 0 && age.year < 21) {
            print("Please select age above 21")
            return false
        }
        return true
    }
    
    @objc func dateOfAccidentAlert() {
        let strDate = dateOfAccidentTxtFld.text ?? ""
        if let date = strDate.date(from: .ddmmyyyy), date > Date() {
            dateOfAccidentTxtFld.text = ""
            showToast(strMessage: futureDateOfAccidentEntered)
        }
    }
    
    
    @objc func SearchListNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let selectedItem = userInfo["selectedItem"] as! String
            let selectedItemIndex = userInfo["selectedIndex"] as! Int
            CommonObject.sharedInstance.isDataChangedInCurrentTab = true
            switch userInfo["itemSelectedFromList"] as? String {
            case AppDropDownLists.PROPOSED_VEHICLE:
                print(arrProposedVehicle)
                proposedVehicleLbl.textColor = UIColor(named: AppColors.BLACK)
                proposedVehicleLbl.text = selectedItem
                selectedProposedVehicleId = arrProposedVehicle[selectedItemIndex].fleetId
            case AppDropDownLists.STATE:
                print(arrStatesNotAtFault)
                stateLbl.textColor = UIColor(named: AppColors.BLACK)
                stateLbl.text = selectedItem
                selectedStateId = arrStatesNotAtFault[selectedItemIndex].stateId
            case AppDropDownLists.INSURANCE_COMPANY:
                print(arrInsuranceCompaniesNotAtFault)
                insuranceCompanyLbl.textColor = UIColor(named: AppColors.BLACK)
                insuranceCompanyLbl.text = selectedItem
                print(arrInsuranceCompaniesNotAtFault[selectedItemIndex].insuranceCompanyId)
                selectedInsuranceCompanyId = arrInsuranceCompaniesNotAtFault[selectedItemIndex].insuranceCompanyId
            case AppDropDownLists.REPAIRER:
                print(arrRepairer)
                repairerNameLbl.textColor = UIColor(named: AppColors.BLACK)
                repairerNameLbl.text = selectedItem
                selectedRepairerId = arrRepairer[selectedItemIndex].repairerId
            case AppDropDownLists.REFERRAL :
                referralNameLbl.text = selectedItem
                referralNameLbl.textColor = UIColor(named: AppColors.BLACK)
                selectedReferralId = arrReferral[selectedItemIndex].referralId
            case AppDropDownLists.BRANCH_NAME:
                branchLbl.text = selectedItem
                branchLbl.textColor = UIColor(named: AppColors.BLACK)
                print(arrBranch[selectedItemIndex].branchID)
                selectedBranchID = arrBranch[selectedItemIndex].branchID
                print(selectedBranchID)
            case AppDropDownLists.RECOVERY_FOR:
                self.txtRecoveryView.textColor = UIColor(named: AppColors.BLACK)
                self.txtRecoveryView.text = selectedItem
                selectedRecovery = selectedItem
            default:
                print("Unkown List")
            }
        }
    }
    
    @objc func DateNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
           if let selectedDate = userInfo["selectedDate"] as? String {
            let selectedTextField = userInfo["dateTextField"] as! UITextField
            CommonObject.sharedInstance.isDataChangedInCurrentTab = true
            switch selectedTextField {
            case deliveryDateTxtFld:
                deliveryDateTxtFld.text = selectedDate
            case licenceExpiryTxtFld:
                licenceExpiryTxtFld.text = selectedDate
                perform(#selector(licenceExpiredAlert), with: nil, afterDelay: 0.3)
            case dateOfBirthTxtFld:
                dateOfBirthTxtFld.text = selectedDate
                perform(#selector(dateOfBirthAlert), with: nil, afterDelay: 0.3)
            case diliveryDateTxtFld:
                diliveryDateTxtFld.text = selectedDate
            case dateOfAccidentTxtFld:
                dateOfAccidentTxtFld.text = selectedDate
                perform(#selector(dateOfAccidentAlert), with: nil, afterDelay: 0.3)
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
            CommonObject.sharedInstance.isDataChangedInCurrentTab = true
            switch selectedTextField {
            case timeOfAccidentTxtFld:
                timeOfAccidentTxtFld.text = selectedTime
            case expectedDeliveryTimeTxtFld:
                expectedDeliveryTimeTxtFld.text = selectedTime
            default:
                print("Unkown Time Textfield")
            }
            }
        }
    }
    
}

extension NotAtFaultDriverDetailsVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        CommonObject.sharedInstance.isDataChangedInCurrentTab = true
        return true
    }
    
}
extension NotAtFaultDriverDetailsVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case referenceIDTxtFld:
            getDetailsForReferenceID()
        case licenceExpiryTxtFld:
            licenceExpiredAlert()
        case dateOfBirthTxtFld:
            dateOfBirthAlert()
        case dateOfAccidentTxtFld:
            dateOfAccidentAlert()
        default:
            print("Other textfield")
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print(CommonObject.sharedInstance.currentReferenceId)
        var isKeyboard = true
        switch textField {
        case referenceIDTxtFld:
            //Showing alert if there is data is not saved by user
            if CommonObject.sharedInstance.isDataChangedInCurrentTab {
                let alert = UIAlertController(title: "Warning!", message: unsavedData, preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                    CommonObject.sharedInstance.isDataChangedInCurrentTab = false
                    self.referenceIDTxtFld.becomeFirstResponder()
                }
                let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                alert.addAction(yesAction)
                alert.addAction(noAction)
                present(alert, animated: true, completion: nil)
            }
//        case deliveryDateTxtFld://,licenceExpiryTxtFld,dateOfBirthTxtFld,dateOfAccidentTxtFld:
//            isKeyboard = false
//            showDatePickerPopUp(textField: textField, notificationName: .dateNotAtFault)
//        case expectedDeliveryTimeTxtFld: //timeOfAccidentTxtFld:
//            isKeyboard = false
//            showTimePickerPopUp(textField: textField, notificationName: .timeNotAtFault)
        default:
            print("Other TextField")
        }
        return isKeyboard
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField {
        case referenceIDTxtFld:
            getDetailsForReferenceID()
        case fullNameTxtFld:
            emailTxtFld.becomeFirstResponder()
        case emailTxtFld:
            phoneTxtFld.becomeFirstResponder()
        case phoneTxtFld:
            licenceNumberTxtFld.becomeFirstResponder()
        case streetAddressTxtFld:
            suburbTxtFld.becomeFirstResponder()
        case clientMakeOrModalTxtFld:
            registrationNumberTxtFld.becomeFirstResponder()
        case accidentLocationTxtFld:
            claimNumberTxtfld.becomeFirstResponder()
        case referralNameTxtFld:
            accidentDescriptionTxtView.becomeFirstResponder()
        default:
            print("Textfield without keyboard as input")
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField != referenceIDTxtFld {
            CommonObject.sharedInstance.isDataChangedInCurrentTab = true//Data is changed
        }
        
        var isAllowed = true
        switch textField {
        case phoneTxtFld,postalCodeTxtFld:
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            isAllowed = allowedCharacters.isSuperset(of: characterSet)
        case fullNameTxtFld :
            isAllowed = textField.isValidNameCharacter(characterTyped: string, range: range)
        case deliveryDateTxtFld,licenceExpiryTxtFld,dateOfBirthTxtFld,dateOfAccidentTxtFld,diliveryDateTxtFld:
            isAllowed = textField.validateDateTyped(shouldChangeCharactersInRange: range, replacementString: string)
        case expectedDeliveryTimeTxtFld,timeOfAccidentTxtFld:
            isAllowed = textField.validateTimeTyped(shouldChangeCharactersInRange: range, replacementString: string)
        default:
            print("TextField without restriction")
        }
        return isAllowed
    }
}

extension NotAtFaultDriverDetailsVC : NotAtFaultDriverDetailsVMDelegate {
    
    func notAtFaultDriverDetailsAPISuccess(dictData: Dictionary<String, Any>, strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
        switch serviceKey {
        case EndPoints.SAVE_NOT_AT_FAULT_DRIVER_DETAILS:
            CommonObject.sharedInstance.isDataChangedInCurrentTab = false
            if let data = dictData["response"] as? Dictionary<String, Any> {
                CommonObject.sharedInstance.currentReferenceId = data["application_id"] as? String ?? ""
            }
            referenceIDTxtFld.text = CommonObject.sharedInstance.currentReferenceId
            if CommonObject.sharedInstance.isNewEntry{
                UserDefaults.standard.setReferenceId(refID: CommonObject.sharedInstance.currentReferenceId)
            }
            let parameters : Parameters = ["application_id" : CommonObject.sharedInstance.currentReferenceId]
            apiPostRequest(parameters: parameters, endPoint: EndPoints.GET_NOT_AT_FAULT_DRIVER_DETAILS)
        default:
            print("Other Service Key")
        }
    }
    
    func notAtFaultDriverDetailsAPISuccess(objData: NotAtFaultDriverDetailsModel, strMessage: String, serviceKey: String) {
        
//        if CommonObject.sharedInstance.isNewEntry{
//            UserDefaults.standard.setReferenceId(refID: CommonObject.sharedInstance.currentReferenceId)
//        }
        
        CommonObject.sharedInstance.currentReferenceId = referenceIDTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        CommonObject.sharedInstance.clientEmail = objData.dictResult.email
        CommonObject.sharedInstance.deliveryBy = objData.dictResult.deliveredBy
        print("ADMIN EMAIL \(CommonObject.sharedInstance.clientEmail)")
        dictDetails = objData.dictResult
        
        //Full Name
        fullNameTxtFld.text = dictDetails.firstName
        
        //Licence Number
        licenceNumberTxtFld.text = dictDetails.lic
        
        //Licence Expiry Date
        licenceExpiryTxtFld.text = dictDetails.licenceExpiry
        
        //Email
        emailTxtFld.text = dictDetails.email
        
        //Phone
        phoneTxtFld.text = dictDetails.phone
        
        //Date of birth
        dateOfBirthTxtFld.text = dictDetails.dateOfBirth
        
        diliveryDateTxtFld.text = dictDetails.expectedDeliveryDate
        
        //Delivery Date
        deliveryByTxtFld.text = dictDetails.deliveredBy
        
        //Street Address
        streetAddressTxtFld.text = dictDetails.street
        
        //Suburb
        suburbTxtFld.text = dictDetails.suburb
        
        //State
        if !dictDetails.state.isEmpty {
            stateLbl.text = dictDetails.state
            stateLbl.textColor = UIColor(named: AppColors.BLACK)
            selectedStateId = dictDetails.stateId
        }
        
        //Delivery Date
        deliveryDateTxtFld.text = dictDetails.expectedDeliveryDate
        
        //Postal Code
        postalCodeTxtFld.text = dictDetails.postalCode
        
        //Client Make or Modal
        clientMakeOrModalTxtFld.text = dictDetails.makeModel
        
        //Registration Number
        registrationNumberTxtFld.text = dictDetails.registrationNo
        
        //Insurance Company
        if !dictDetails.insuranceCompanyName.isEmpty {
            insuranceCompanyLbl.text = dictDetails.insuranceCompanyName
            insuranceCompanyLbl.textColor = UIColor(named: AppColors.BLACK)
            selectedInsuranceCompanyId = dictDetails.insuranceCompanyId
        }
        
        //Date Of Accident
        dateOfAccidentTxtFld.text = dictDetails.dateOfAccident
        if (!dictDetails.recoveryFor.isEmpty) {
//            recoveryLbl.text = dictDetails.recoveryFor
            self.txtRecoveryView.text = dictDetails.recoveryFor.capitalized
        }
        
        //Time Of Accident
        let timeOfAccident = dictDetails.timeOfAccident
        timeOfAccidentSegmentedControl.setUpAmPM(time: timeOfAccident)
        timeOfAccidentTxtFld.text = timeOfAccident.DatePresentable?.getDateAccoringTo(format: .Time12Hr) ?? ""
        
        //Accident Location
        accidentLocationTxtFld.text = dictDetails.accidentLocation
        
        //Claim Number
        claimNumberTxtfld.text = dictDetails.claimNo
        
        //isBusinessRegistered Buttons
        switch dictDetails.isBusinessRegistered.lowercased() {
        case "yes":
            isVehicleBusinessRegistered = "yes"
            vehicleBusinessRegisteredYesBtn.isSelected = true
        case "no":
            isVehicleBusinessRegistered = "no"
            vehicleBusinessRegisteredNoBtn.isSelected = true
        default:
            print("Nil or Unknown value in is_business_registered parameter")
        }
        
        //Proposed vehicle
        if !dictDetails.proposedVehicle.isEmpty {
            isProposedVehicleSaved = true//To enable Booking Details button if Proposed Vehicle is saved
            proposedVehicleLbl.text = dictDetails.proposedVehicle
            proposedVehicleLbl.textColor = UIColor(named: AppColors.BLACK)
            selectedProposedVehicleId = dictDetails.proposedVehicleId
            CommonObject.sharedInstance.vehicleId = dictDetails.proposedVehicleId
        
        }
        //Expected delivery time
        let expectedDeliveryTime = dictDetails.expectedDeliveryTime
        deliveryTimeSegmentedControl.setUpAmPM(time: expectedDeliveryTime)
        expectedDeliveryTimeTxtFld.text = expectedDeliveryTime.DatePresentable?.getDateAccoringTo(format: .Time12Hr) ?? ""
        
        //Referral Name
        //referralNameTxtFld.text = dictDetails.referralName
        
        //Repairer Name
        if !dictDetails.repairerName.isEmpty {
            repairerNameLbl.text = dictDetails.repairerName
            repairerNameLbl.textColor = UIColor(named: AppColors.BLACK)
            selectedRepairerId = dictDetails.repairerId
        }
        //Referral Name
        if !dictDetails.referralName.isEmpty {
            referralNameLbl.text = dictDetails.referralName
            referralNameLbl.textColor = UIColor(named: AppColors.BLACK)
            selectedReferralId = dictDetails.referralId
        }
        //branch name
        print(dictDetails.branchName)
        if !dictDetails.branchName.isEmpty {
            print(dictDetails.branchName)
            branchLbl.text = dictDetails.branchName
            branchLbl.textColor = UIColor(named: AppColors.BLACK)
            selectedBranchID = dictDetails.branchId
        }
        
        //Drop location
        dropLocationTxtFld.text = dictDetails.dropLocation
        
        //Accident Description
        accidentDescriptionTxtView.text = dictDetails.accidentDescription
        
        if isFromAddSecondTier || isFromAddThirdTier{
            isFromAddSecondTier = false
            isFromAddThirdTier = false
            var storyboard = String()
            var vcId = String()
            if UIDevice.current.userInterfaceIdiom == .pad {
                storyboard = AppStoryboards.DASHBOARD
                vcId = AppStoryboardId.ADD_HIRER
            } else {
                storyboard = AppStoryboards.DASHBOARD_PHONE
                vcId = AppStoryboardId.ADD_HIRER_PHONE
            }
            let vc = UIStoryboard(name: storyboard, bundle: Bundle.main).instantiateViewController(withIdentifier: vcId) as! AddHirerVC
            vc.hirerNumber = isFromAddSecondTier ? 2 : 3
            present(vc, animated: true, completion: nil)
        }else if isFromBookingDetails {
            isFromBookingDetails = false
            openBookingDetails()
        }
    }
    
    func notAtFaultDriverDetailsAPISuccess(objData: NewReferenceIdModel, strMessage: String, serviceKey: String) {
        print(objData.dictResult)
        CommonObject.sharedInstance.currentReferenceId = objData.dictResult.appid
//        if CommonObject.sharedInstance.isNewEntry{
//            UserDefaults.standard.setReferenceId(refID: CommonObject.sharedInstance.currentReferenceId)
//        }
       // CommonObject.sharedInstance.vehicleId = objData.dictResu
        print(CommonObject.sharedInstance.currentReferenceId)
        
        
        
        referenceIDTxtFld.text = objData.dictResult.appid
    }
    
    func notAtFaultDriverDetailsAPISuccess(objData: InsuranceCompanyListModel, strMessage: String, serviceKey: String) {
        print(objData)
        if objData.arrResult.count > 0 {
            var temp = [String] ()
            for i in 0...objData.arrResult.count-1 {
                temp.append(objData.arrResult[i].insuranceCompanyName)
            }
            arrInsuranceCompaniesNotAtFault = objData.arrResult
            print(arrInsuranceCompaniesNotAtFault)
            showSearchListPopUp(listForSearch: temp, listNameForSearch: AppDropDownLists.INSURANCE_COMPANY,notificationName: .searchListNotAtFault)
        }
    }
    
    func notAtFaultDriverDetailsAPISuccess(objData: StateListModel, strMessage: String,serviceKey: String) {
        print(objData)
        if objData.arrResult.count > 0 {
            var temp = [String] ()
            for i in 0...objData.arrResult.count-1 {
                temp.append(objData.arrResult[i].stateName)
            }
            
            arrStatesNotAtFault = objData.arrResult
            print(arrStatesNotAtFault)
            showSearchListPopUp(listForSearch: temp, listNameForSearch: AppDropDownLists.STATE, notificationName: .searchListNotAtFault)
        }
    }
    
    func notAtFaultDriverDetailsAPISuccess(objData: RepairerListModel, strMessage: String, serviceKey: String) {
        print(objData)
        if objData.arrResult.count > 0 {
            var temp = [String] ()
            for i in 0...objData.arrResult.count-1 {
                temp.append(objData.arrResult[i].repairerName)
            }
            arrRepairer = objData.arrResult
            print(arrRepairer)
            showSearchListPopUp(listForSearch: temp, listNameForSearch: AppDropDownLists.REPAIRER,notificationName: .searchListNotAtFault)
        }
    }
    func notAtFaultDriverDetailsAPISuccess(objData: ReferralListModel, strMessage: String, serviceKey: String) {
        print(objData)
        if objData.arrResult.count > 0 {
            var temp = [String] ()
            for i in 0...objData.arrResult.count-1 {
                temp.append(objData.arrResult[i].referralName)
            }
            arrReferral = objData.arrResult
            print(arrReferral)
            showSearchListPopUp(listForSearch: temp, listNameForSearch: AppDropDownLists.REFERRAL,notificationName: .searchListNotAtFault)
        }
    }
    func notAtFaultDriverDetailsAPISuccess(objData: BranchListModel, strMessage: String, serviceKey: String) {
        print(objData)
        if objData.arrResult.count > 0 {
            var temp = [String] ()
            for i in 0...objData.arrResult.count-1 {
                temp.append(objData.arrResult[i].branchName)
            }
            
            
            print(objData.arrResult)
            
            arrBranch = objData.arrResult
            print(arrBranch)
            showSearchListPopUp(listForSearch: temp, listNameForSearch: AppDropDownLists.BRANCH_NAME,notificationName: .searchListNotAtFault)
        }
    }
    
    
    func notAtFaultDriverDetailsAPISuccess(objData: ProposedVehicleModel, strMessage: String, serviceKey: String) {
        print(objData)
        if objData.arrResult.count > 0 {
            var temp = [String] ()
            for i in 0...objData.arrResult.count-1 {
                temp.append(objData.arrResult[i].registrationNumber)
            }
            arrProposedVehicle = objData.arrResult
            showSearchListPopUp(listForSearch: temp, listNameForSearch: AppDropDownLists.PROPOSED_VEHICLE, notificationName: .searchListNotAtFault)
        }
    }
    
    func notAtFaultDriverDetailsAPIFailure(strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
        if serviceKey == EndPoints.GET_NOT_AT_FAULT_DRIVER_DETAILS {
            referenceIDTxtFld.text = ""
        }
    }
}

extension NotAtFaultDriverDetailsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        self.txtRecoveryView.textColor = UIColor(named: AppColors.BLACK)
//        self.txtRecoveryView.text = self.recoveryForArr[0]
//        self.selectedRecovery = self.recoveryForArr[0]
        return self.recoveryForArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.recoveryForArr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        CommonObject.sharedInstance.isDataChangedInCurrentTab = true
        self.txtRecoveryView.textColor = UIColor(named: AppColors.BLACK)
        self.txtRecoveryView.text = self.recoveryForArr[row]
        self.selectedRecovery = self.recoveryForArr[row]
    }
    
}
