//
//  AnyOtherPartyDetailsVC.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 20/08/21.
//

import UIKit
import Alamofire
class AnyOtherPartyDetailsVC: UIViewController {

    @IBOutlet weak var fullNameTxtFld: UITextField!
    @IBOutlet weak var licenceNumberTxtFld: UITextField!
    @IBOutlet weak var phoneTxtFld: UITextField!
    @IBOutlet weak var dateOfBirthTxtFld: UITextField!
    @IBOutlet weak var makeOrModalOfVehicleTxtFld: UITextField!
    @IBOutlet weak var registrationNumberTxtFld: UITextField!
    @IBOutlet weak var insuranceCompanyLbl: UILabel!
    @IBOutlet weak var claimNumberTxtFld: UITextField!
    @IBOutlet weak var witnessNameTxtFld: UITextField!
    @IBOutlet weak var witnessPhoneTxtFld: UITextField!
    @IBOutlet weak var streetAddressTxtFld: UITextField!
    @IBOutlet weak var suburbTxtFld: UITextField!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var postalCodeTxtFld: UITextField!
    var arrInsuranceCompaniesOther = [InsuranceCompanyListModelData]()
    var arrStatesOther = [StateListModelData]()
    var dictDetails = AnyOtherPartyDetailsModelData()
    var selectedStateId = String()
    var selectedInsuranceCompanyId = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        CommonObject.sharedInstance.isNewEntry = false
        print(CommonObject.sharedInstance.currentReferenceId)
        // Do any additional setup after loading the view.
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchListNotificationAction(_:)), name: .searchListAnyOtherParty, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DateNotificationAction(_:)), name: .dateAnyOtherParty, object: nil)
        setViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(CommonObject.sharedInstance.currentReferenceId)
        CommonObject.sharedInstance.isDataChangedInCurrentTab = false//Data not edited
        if !CommonObject.sharedInstance.currentReferenceId.isEmpty {
            let parameters : Parameters = ["application_id" : CommonObject.sharedInstance.currentReferenceId]
            apiPostRequest(parameters: parameters, endPoint: EndPoints.GET_ANY_OTHER_PARTY_DETAILS)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)//Removes all notifications being observed
    }
    
    func setViews() {
        dateOfBirthTxtFld.keyboardType = .numberPad
        witnessPhoneTxtFld.keyboardType = .numberPad
        phoneTxtFld.keyboardType = .numberPad
        phoneTxtFld.delegate = self
        witnessPhoneTxtFld.delegate = self
    }
    func apiPostRequest(parameters: Parameters,endPoint: String){
        CommonObject.sharedInstance.showProgress()
        let obj = AnyOtherPartyDetailsViewModel()
        obj.delegate = self
        obj.postAnyOtherPartyDetails(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    
    func apiGetRequest(parameters: Parameters?,endPoint: String) {
        CommonObject.sharedInstance.showProgress()
        let obj = AnyOtherPartyDetailsViewModel()
        obj.delegate = self
        obj.getAnyOtherPartyDetails(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    
    @IBAction func dateOfBirthCalenderBtnTapped(_ sender: UIButton) {
        showDatePickerPopUp(textField: dateOfBirthTxtFld, notificationName: .dateAnyOtherParty)
    }
    @IBAction func insuranceCompanyListTapped(_ sender: UITapGestureRecognizer) {
        apiGetRequest(parameters: nil, endPoint: EndPoints.INSURANCE_COMPANY_LIST)
    }
    
    @IBAction func stateListTapped(_ sender: UITapGestureRecognizer) {
        apiGetRequest(parameters: nil, endPoint: EndPoints.STATE_LIST)
    }
    
    @IBAction func saveAsDraftBtn(_ sender: UIButton) {
        
//        if !validateAge() {
//            showToast(strMessage: requiredHirerAge21)
//            return
//        }
        
        let parameters : Parameters = ["application_id" : CommonObject.sharedInstance.currentReferenceId,
                                       "user_id" : UserDefaults.standard.userId(),
                                       "party_name" : fullNameTxtFld.text ?? "",
                                       "party_lic_no" : licenceNumberTxtFld.text ?? "",
                                       "witness_phone" : witnessPhoneTxtFld.text ?? "",
                                       "party_phone" : phoneTxtFld.text ?? "",
                                       "party_dob" : dateOfBirthTxtFld.text ?? "",
                                       "party_street" : streetAddressTxtFld.text ?? "",
                                       "party_suburb" : suburbTxtFld.text ?? "",
                                       "party_state" : selectedStateId,
                                       "party_postcode" : postalCodeTxtFld.text ?? "",
                                       "party_country" : "Australia",
                                       "party_make_model" : makeOrModalOfVehicleTxtFld.text ?? "",
                                       "party_registration_no" : registrationNumberTxtFld.text ?? "",
                                       "party_insurance" : selectedInsuranceCompanyId,
                                       "party_witness_name" : witnessNameTxtFld.text ?? "",
                                       "party_claim_no" : claimNumberTxtFld.text!]
        apiPostRequest(parameters: parameters, endPoint: EndPoints.SAVE_ANY_OTHER_PARTY_DETAILS)
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
//        let strDate = dateOfBirthTxtFld.text ?? ""
//        let age = strDate.calculateAge(format: DateFormat.ddmmyyyy.rawValue)
//        print(age)
//        if age.year < 0 {
//            dateOfBirthTxtFld.text = ""
//            showToast(strMessage: futureDobEntered)
//        }
        
        let result = isDateGreaterThan1910(dateString: self.dateOfBirthTxtFld.text ?? "")
        if !result {
            showToast(strMessage: "Date of birth should be greater than 01-01-1910")
            self.dateOfBirthTxtFld.text = ""
            return
        }
        
        let strDate = dateOfBirthTxtFld.text ?? ""
        let age = strDate.calculateAge(format: DateFormat.ddmmyyyy.rawValue)
        print(age)
        if age.year < 0 {
            dateOfBirthTxtFld.text = ""
            showToast(strMessage: futureDobEntered)
        } else if (age.year == 0 && (age.month >= 0 || age.day >= 0)) ||  (age.year >= 0 && age.year < 21) {
            showAlert(message: requiredHirerAge, yesTitle: "Yes", noTitle: "No", yesAction: {

            }, noAction: {
                self.dateOfBirthTxtFld.text = ""
            })
        }
    }

    @objc func SearchListNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            CommonObject.sharedInstance.isDataChangedInCurrentTab = true//Data edited
            if let selectedItem = userInfo["selectedItem"] as? String {
                let selectedItemIndex = userInfo["selectedIndex"] as! Int
                switch userInfo["itemSelectedFromList"] as? String {
                case AppDropDownLists.STATE:
                    stateLbl.textColor = UIColor(named: AppColors.BLACK)
                    stateLbl.text = selectedItem
                    selectedStateId = arrStatesOther[selectedItemIndex].stateId
                case AppDropDownLists.INSURANCE_COMPANY:
                    insuranceCompanyLbl.textColor = UIColor(named: AppColors.BLACK)
                    insuranceCompanyLbl.text = selectedItem
                    selectedInsuranceCompanyId = arrInsuranceCompaniesOther[selectedItemIndex].insuranceCompanyId
                default:
                    print("Unkown List")
                }
            }
        }
    }
    
    @objc func DateNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            CommonObject.sharedInstance.isDataChangedInCurrentTab = true//Data edited
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

extension AnyOtherPartyDetailsVC : UITextFieldDelegate {
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        var isKeyboard = true
//        switch textField {
//        case dateOfBirthTxtFld:
//            isKeyboard = false
//            showDatePickerPopUp(textField: textField, notificationName: .dateAnyOtherParty)
//        default:
//            print("Other Textfield")
//        }
//        return isKeyboard
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
            witnessNameTxtFld.becomeFirstResponder()
        case witnessNameTxtFld:
            witnessPhoneTxtFld.becomeFirstResponder()
        case witnessPhoneTxtFld:
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
        case phoneTxtFld,postalCodeTxtFld,witnessPhoneTxtFld:
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            isAllowed = allowedCharacters.isSuperset(of: characterSet)
        case fullNameTxtFld,witnessNameTxtFld:
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
//            isAllowed = isAllowed && allowedCharacters.isSuperset(of: characterSet) || allowedCharacters1.isSuperset(of: characterSet)
            isAllowed = textField.isValidNameCharacter(characterTyped: string, range: range)
        case dateOfBirthTxtFld:
            isAllowed = textField.validateDateTyped(shouldChangeCharactersInRange: range, replacementString: string)
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
}

extension AnyOtherPartyDetailsVC : AnyOtherPartyDetailsVMDelegate {
    func anyOtherPartyDetailsAPISuccess(objData: AnyOtherPartyDetailsModel, strMessage: String, serviceKey: String) {
        print(objData.dictResult)
        dictDetails = objData.dictResult
        if !dictDetails.firstName.isEmpty || !dictDetails.lastName.isEmpty {
            fullNameTxtFld.text = dictDetails.firstName + " " + dictDetails.lastName
        }
        licenceNumberTxtFld.text = dictDetails.licenceNo
        phoneTxtFld.text = dictDetails.phoneNumber
        witnessNameTxtFld.text = dictDetails.witnessName
        witnessPhoneTxtFld.text = dictDetails.witnessPhoneNumber
        dateOfBirthTxtFld.text = dictDetails.dateOfBirth
        makeOrModalOfVehicleTxtFld.text = dictDetails.makeModelOfVehicle
        registrationNumberTxtFld.text = dictDetails.registrationNumber
        claimNumberTxtFld.text = dictDetails.claimNo
        if !dictDetails.insuranceCompanyName.isEmpty {
            insuranceCompanyLbl.text = dictDetails.insuranceCompanyName
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
    
    func anyOtherPartyDetailsAPISuccess(strMessage: String, serviceKey: String) {
        switch serviceKey {
        case EndPoints.SAVE_ANY_OTHER_PARTY_DETAILS:
            CommonObject.sharedInstance.isDataChangedInCurrentTab = false//Data has been saved
        default:
            print("Other Service Key")
        }
        showToast(strMessage: strMessage)
    }
    
    func anyOtherPartyDetailsAPISuccess(objData: InsuranceCompanyListModel, strMessage: String, serviceKey: String) {
        print(objData)
        if objData.arrResult.count > 0 {
            var temp = [String] ()
            for i in 0...objData.arrResult.count-1 {
                temp.append(objData.arrResult[i].insuranceCompanyName)
            }
            arrInsuranceCompaniesOther = objData.arrResult
            showSearchListPopUp(listForSearch: temp, listNameForSearch: AppDropDownLists.INSURANCE_COMPANY, notificationName: .searchListAnyOtherParty)
        }
    }
    
    func anyOtherPartyDetailsAPISuccess(objData: StateListModel, strMessage: String, serviceKey: String) {
        print(objData)
        if objData.arrResult.count > 0 {
            var temp = [String] ()
            for i in 0...objData.arrResult.count-1 {
                temp.append(objData.arrResult[i].stateName)
            }
            arrStatesOther = objData.arrResult
            showSearchListPopUp(listForSearch: temp, listNameForSearch: AppDropDownLists.STATE, notificationName: .searchListAnyOtherParty)
        }
    }
    
    func anyOtherPartyDetailsAPIFailure(strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
    }
}
