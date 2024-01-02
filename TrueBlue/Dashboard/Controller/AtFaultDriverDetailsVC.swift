//
//  AtFaultDriverDetailsVC.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 20/08/21.
//

import UIKit
import Alamofire
class AtFaultDriverDetailsVC: UIViewController {
    
    @IBOutlet weak var fullNameTxtFld: UITextField!
    @IBOutlet weak var licenceNumberTxtFld: UITextField!
    @IBOutlet weak var phoneTxtFld: UITextField!
    @IBOutlet weak var dateOfBirthTxtFld: UITextField!
    @IBOutlet weak var makeOrModalOfVehicleTxtFld: UITextField!
    @IBOutlet weak var registrationNumberTxtFld: UITextField!
    @IBOutlet weak var insuranceCompanyLbl: UILabel!
    @IBOutlet weak var claimNumberTxtFld: UITextField!
    @IBOutlet weak var streetAddressTxtFld: UITextField!
    @IBOutlet weak var suburbTxtFld: UITextField!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var postalCodeTxtFld: UITextField!
    var arrInsuranceCompaniesAtFault = [InsuranceCompanyListModelData]()
    var arrStatesAtFault = [StateListModelData]()
    var selectedStateId = String()
    var selectedInsuranceCompanyId = String()
    var dictDetails = AtFaultDriverDetailsModelData()

    override func viewDidLoad() {
        super.viewDidLoad()
//        dateOfBirthTxtFld.isUserInteractionEnabled = false
        CommonObject.sharedInstance.isNewEntry = false
        print(CommonObject.sharedInstance.currentReferenceId)
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchListNotificationAction(_:)), name: .searchListAtFault, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DateNotificationAction(_:)), name: .dateAtFault, object: nil)
        // Do any additional setup after loading the view.
        setViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(CommonObject.sharedInstance.currentReferenceId)
        CommonObject.sharedInstance.isDataChangedInCurrentTab = false//Data has not changed
        if !CommonObject.sharedInstance.currentReferenceId.isEmpty {
            let parameters : Parameters = ["application_id" : CommonObject.sharedInstance.currentReferenceId]
            apiPostRequest(parameters: parameters, endPoint: EndPoints.GET_AT_FAULT_DRIVER_DETAILS)
        }
        
//        dateOfBirthTxtFld.keyboardType = .numberPad
    }
    
    func setViews() {
        dateOfBirthTxtFld.keyboardType = .numberPad
        phoneTxtFld.keyboardType = .numberPad
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)//Removes all notifications being observed
    }
    func apiPostRequest(parameters: Parameters,endPoint: String){
        CommonObject.sharedInstance.showProgress()
        let obj = AtFaultDriverDetailsViewModel()
        obj.delegate = self
        obj.postAtFaultDriverDetails(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    
    func apiGetRequest(parameters: Parameters?,endPoint: String) {
        CommonObject.sharedInstance.showProgress()
        let obj = AtFaultDriverDetailsViewModel()
        obj.delegate = self
        obj.getAtFaultDriverDetails(currentController: self, parameters: parameters, endPoint: endPoint)
    }

    @IBAction func dateOfBirthCalenderBtnTapped(_ sender: Any) {
        showDatePickerPopUp(textField: dateOfBirthTxtFld, notificationName: .dateAtFault)
    }
    @IBAction func insuranceCompanyListTapped(_ sender: UITapGestureRecognizer) {
        apiGetRequest(parameters: nil, endPoint: EndPoints.INSURANCE_COMPANY_LIST)
    }
    
    @IBAction func stateListTapped(_ sender: UITapGestureRecognizer) {
        apiGetRequest(parameters: nil, endPoint: EndPoints.STATE_LIST)
    }

    @IBAction func saveAsDraftBtn(_ sender: UIButton) {
        
        if !validateAge() {
            showToast(strMessage: requiredHirerAge21)
            return
        }
        
        let parameters : Parameters = ["application_id" : CommonObject.sharedInstance.currentReferenceId,
                                       "user_id" : UserDefaults.standard.userId(),
                                       "atfault_name" : fullNameTxtFld.text ?? "",
                                       "atfault_lic_no" : licenceNumberTxtFld.text ?? "",
                                       "atfault_phone" : phoneTxtFld.text ?? "",
                                       "atfault_dob" : dateOfBirthTxtFld.text ?? "",
                                       "atfault_make_model" : makeOrModalOfVehicleTxtFld.text ?? "",
                                       "atfault_registration_no" : registrationNumberTxtFld.text ?? "",
                                       "atfault_claimno" : claimNumberTxtFld.text ?? "",
                                       "atfault_insurancecompany" : selectedInsuranceCompanyId,
                                       "atfault_street" : streetAddressTxtFld.text ?? "",
                                       "atfault_suburb" : suburbTxtFld.text ?? "",
                                       "atfault_postcode" : postalCodeTxtFld.text ?? "",
                                       "atfault_country" : "Australia",
                                       "atfault_state" : selectedStateId]
        apiPostRequest(parameters: parameters, endPoint: EndPoints.SAVE_AT_FAULT_DRIVER_DETAILS)
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
    
    
    @objc func dateOfBirthAlert() {
        let strDate = dateOfBirthTxtFld.text ?? ""
        let age = strDate.calculateAge(format: DateFormat.ddmmyyyy.rawValue)
        print(age)
        if age.year < 0 {
            dateOfBirthTxtFld.text = ""
            showToast(strMessage: futureDobEntered)
        } 
    }
    
    @objc func SearchListNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
           if let selectedItem = userInfo["selectedItem"] as? String {
            CommonObject.sharedInstance.isDataChangedInCurrentTab = true//Data is edited
            let selectedItemIndex = userInfo["selectedIndex"] as! Int
            switch userInfo["itemSelectedFromList"] as? String {
            case AppDropDownLists.STATE:
                stateLbl.textColor = UIColor(named: AppColors.BLACK)
                stateLbl.text = selectedItem
                selectedStateId = arrStatesAtFault[selectedItemIndex].stateId
            case AppDropDownLists.INSURANCE_COMPANY:
                insuranceCompanyLbl.textColor = UIColor(named: AppColors.BLACK)
                insuranceCompanyLbl.text = selectedItem
                print(arrInsuranceCompaniesAtFault)
                selectedInsuranceCompanyId = arrInsuranceCompaniesAtFault[selectedItemIndex].insuranceCompanyId
            default:
                print("Unkown List")
            }
            }
        }
    }
    
    @objc func DateNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            CommonObject.sharedInstance.isDataChangedInCurrentTab = true//Data is edited
            if let selectedDate = userInfo["selectedDate"] as? String {
                let selectedTextField = userInfo["dateTextField"] as! UITextField
                switch selectedTextField {
                case dateOfBirthTxtFld:
                    dateOfBirthTxtFld.text = selectedDate
                    perform(#selector(dateOfBirthAlert), with: nil, afterDelay: 0.3)
                default:
                    print("Unkown Date Textfield")
                }
            }
        }
    }
}

extension AtFaultDriverDetailsVC : UITextFieldDelegate {
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        var isKeyBoard = true
//        switch textField {
//        case dateOfBirthTxtFld:
//            isKeyBoard = false
//            showDatePickerPopUp(textField: textField, notificationName: .dateAtFault)
//        default:
//            print("Other Textfield")
//        }
//        return isKeyBoard
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField {
        case fullNameTxtFld:
            licenceNumberTxtFld.becomeFirstResponder()
        case licenceNumberTxtFld:
            phoneTxtFld.becomeFirstResponder()
        case makeOrModalOfVehicleTxtFld:
            registrationNumberTxtFld.becomeFirstResponder()
        case claimNumberTxtFld:
            streetAddressTxtFld.becomeFirstResponder()
        case streetAddressTxtFld:
            suburbTxtFld.becomeFirstResponder()
        default:
            print("Textfield does not return")
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        CommonObject.sharedInstance.isDataChangedInCurrentTab = true//Data edited
        var isAllowed = true
        switch textField {
        case phoneTxtFld,postalCodeTxtFld:
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            isAllowed = allowedCharacters.isSuperset(of: characterSet)
        case fullNameTxtFld :
//            //To avoid getting . in name after typing double spaces between characters
//            if textField.text?.last == " " && string == " " {
//                textField.text = (textField.text as NSString?)?.replacingCharacters(in: range, with: " ")
//                if let pos = textField.position(from: textField.beginningOfDocument, offset: range.location + 1) {
//                    // updates the text caret to reflect the programmatic change to the textField
//                    textField.selectedTextRange = textField.textRange(from: pos, to: pos)
//                    isAllowed = false
//                }
//            }
//            let allowedCharacters = CharacterSet.letters
//            let allowedCharacters1 = CharacterSet.whitespaces
//            let characterSet = CharacterSet(charactersIn: string)
//            isAllowed = isAllowed && allowedCharacters.isSuperset(of: characterSet) || allowedCharacters1.isSuperset(of: characterSet)h
            isAllowed = textField.isValidNameCharacter(characterTyped: string, range: range)
        case dateOfBirthTxtFld:
//            let obj = DateTextField()
//            obj.textField = dateOfBirthTxtFld
//            obj.separator = "-"
//            obj.dateFormat = .dayMonthYear
            isAllowed = dateOfBirthTxtFld.validateDateTyped(shouldChangeCharactersInRange: range, replacementString: string)//obj.dateTxtFld(shouldChangeCharactersIn: range, replacementString: string)
//           isAllowed = dateOfBirthTxtFld.formatDate(shouldChangeCharactersInRange: range, replacementString: string)
        default:
            print("TextField without restriction")
        }
        return isAllowed
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case dateOfBirthTxtFld:
            dateOfBirthAlert()
        default:
            print("textFieldDidEndEditing")
        }
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == dateOfBirthTxtFld {
//            showDatePickerPopUp(textField: dateOfBirthTxtFld, notificationName: .dateAtFault)
//        }
//    }
}
extension AtFaultDriverDetailsVC : AtFaultDriverDetailsVMDelegate {
    func atFaultDriverDetailsAPISuccess(objData: AtFaultDriverDetailsModel, strMessage: String, serviceKey: String) {
        print(objData.dictResult)
        dictDetails = objData.dictResult
        if !dictDetails.firstName.isEmpty || !dictDetails.lastName.isEmpty {
            fullNameTxtFld.text = dictDetails.firstName + " " + dictDetails.lastName
        }
        licenceNumberTxtFld.text = dictDetails.licenceNo
        phoneTxtFld.text = dictDetails.phoneNumber
        dateOfBirthTxtFld.text = dictDetails.dateOfBirth == "01-01-1970" ? "" : dictDetails.dateOfBirth
        makeOrModalOfVehicleTxtFld.text = dictDetails.makeModelOfVehicle
        registrationNumberTxtFld.text = dictDetails.registrationNo
        claimNumberTxtFld.text = dictDetails.claimNo
        if !dictDetails.insuranceCompany.isEmpty {
            insuranceCompanyLbl.text = dictDetails.insuranceCompany
            insuranceCompanyLbl.textColor = UIColor(named: AppColors.BLACK)
            selectedInsuranceCompanyId = dictDetails.insuranceCompanyId
        }
        streetAddressTxtFld.text = dictDetails.street
        suburbTxtFld.text = dictDetails.suburb
        if !dictDetails.state.isEmpty {
            stateLbl.text = dictDetails.state
            stateLbl.textColor = UIColor(named: AppColors.BLACK)
            selectedStateId = dictDetails.stateId
        }
        postalCodeTxtFld.text = dictDetails.postalCode
    }
    
    func atFaultDriverDetailsAPISuccess(strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
        switch serviceKey {
        case EndPoints.SAVE_AT_FAULT_DRIVER_DETAILS:
            CommonObject.sharedInstance.isDataChangedInCurrentTab = false//Data saved
            let parameters : Parameters = ["application_id" : CommonObject.sharedInstance.currentReferenceId]
            apiPostRequest(parameters: parameters, endPoint: EndPoints.GET_AT_FAULT_DRIVER_DETAILS)
        default:
            print("Unkown Service Key")
        }
    }
    
    func atFaultDriverDetailsAPISuccess(objData: InsuranceCompanyListModel, strMessage: String, serviceKey: String) {
        print(objData)
        if objData.arrResult.count > 0 {
            var temp = [String] ()
            for i in 0...objData.arrResult.count-1 {
                temp.append(objData.arrResult[i].insuranceCompanyName)
            }
            arrInsuranceCompaniesAtFault = objData.arrResult
            showSearchListPopUp(listForSearch: temp, listNameForSearch: AppDropDownLists.INSURANCE_COMPANY, notificationName: .searchListAtFault)
        }
    }
    
    func atFaultDriverDetailsAPISuccess(objData: StateListModel, strMessage: String, serviceKey: String) {
        print(objData)
        if objData.arrResult.count > 0 {
            print(arrStatesAtFault.count)
            var temp = [String] ()
            for i in 0...objData.arrResult.count-1 {
                temp.append(objData.arrResult[i].stateName)
            }
            arrStatesAtFault = objData.arrResult
            showSearchListPopUp(listForSearch: temp, listNameForSearch: AppDropDownLists.STATE, notificationName: .searchListAtFault)
        }
    }
    
    func atFaultDriverDetailsAPIFailure(strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
    }
}
