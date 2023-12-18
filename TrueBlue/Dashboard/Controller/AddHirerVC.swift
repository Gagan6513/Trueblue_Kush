//
//  AddHirerVC.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 28/08/21.
//

import UIKit
import Alamofire
class AddHirerVC: UIViewController {

    @IBOutlet weak var firstNameTxtFld: UITextField!
    @IBOutlet weak var lastNameTxtFld: UITextField!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var phoneTxtFld: UITextField!
    @IBOutlet weak var licNumberTxtFld: UITextField!
    @IBOutlet weak var expTxtFld: UITextField!
    @IBOutlet weak var dateOfBirthTxtFld: UITextField!
    @IBOutlet weak var streetAddressTxtFld: UITextField!
    @IBOutlet weak var suburbTxtFld: UITextField!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var postalCodeTxtFld: UITextField!
    @IBOutlet weak var countryLbl: UILabel!
    
    @IBOutlet weak var sameAsPreviousHirerImgView: UIImageView!
    @IBOutlet weak var previousHirerAddressBtn: UIButton!
    var arrStatesHirer = [StateListModelData]()
    var listNameForSelection = String()
    var hirerNumber = Int()
    var selectedStateId = String()
    var dictHirerDetails = HirerDetailsModelData()
    var isPreviousHirerAddressBtnSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        CommonObject.sharedInstance.isNewEntry = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.ListNotificationAction(_:)), name: .listAddHirer, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DateNotificationAction(_:)), name: .dateAddHirer, object: nil)
        getHirerdetails()
        setViews()
    }
    
    func setViews() {
        dateOfBirthTxtFld.keyboardType = .numberPad
        expTxtFld.keyboardType = .numberPad
        
//        if hirerNumber == 2 {
//            previousHirerAddressBtn.isHidden = true
//            sameAsPreviousHirerImgView.isHidden = true
//        }
    }
    
    func apiPostRequest(parameters: Parameters,endPoint: String) {
        CommonObject.sharedInstance.showProgress()
        let obj = AddHirerViewModel()
        obj.delegate = self
        obj.postAddHirer(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    func apiGetRequest(parameters: Parameters?,endPoint: String) {
        CommonObject.sharedInstance.showProgress()
        let obj = AddHirerViewModel()
        obj.delegate = self
        obj.getAddHirer(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    
    func getHirerdetails() {
        let parameters : Parameters = ["application_id" : CommonObject.sharedInstance.currentReferenceId,
                                       "hirerno": hirerNumber]
        apiPostRequest(parameters: parameters, endPoint: EndPoints.GET_HIRER_DETAILS)
    }
    
    func isAddressSameAsPreviousHirer() -> Bool {
        
        if (streetAddressTxtFld.text ?? "") == dictHirerDetails.previousStreetAddress && (suburbTxtFld.text ?? "") == dictHirerDetails.previousSuburb && selectedStateId == dictHirerDetails.previousState && (postalCodeTxtFld.text ?? "") == dictHirerDetails.postalCode && (countryLbl.text ?? "") == dictHirerDetails.previousCountry {
            return true
        }
        return false
    }
    
    func updatePreviousHirerAddressCheck() {
        guard isPreviousHirerAddressBtnSelected, !previousHirerAddressBtn.isHidden else {
            return
        }
        if isAddressSameAsPreviousHirer() {
            sameAsPreviousHirerImgView.image = .checkSelected
        } else {
            isPreviousHirerAddressBtnSelected = false
            sameAsPreviousHirerImgView.image = .checkUnselected
        }
    }
    

    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func expCalenderBtnTapped(_ sender: UIButton) {
        showDatePickerPopUp(textField: expTxtFld, notificationName: .dateAddHirer)
    }
    
    @IBAction func dobCalenderBtnTapped(_ sender: UIButton) {
        showDatePickerPopUp(textField: dateOfBirthTxtFld, notificationName: .dateAddHirer)
    }
    
    
    @IBAction func stateListTapped(_ sender: UITapGestureRecognizer) {
        apiGetRequest(parameters: nil, endPoint: EndPoints.STATE_LIST)
    }
    @IBAction func previousAddressBtnTapped(_ sender: UIButton) {
        isPreviousHirerAddressBtnSelected = !isPreviousHirerAddressBtnSelected
        if isPreviousHirerAddressBtnSelected {
            streetAddressTxtFld.text = dictHirerDetails.previousStreetAddress
            suburbTxtFld.text = dictHirerDetails.previousSuburb
            if !dictHirerDetails.previousState.isEmpty {
                stateLbl.text = dictHirerDetails.previousState
                stateLbl.textColor = UIColor(named: AppColors.BLACK)
                selectedStateId = dictHirerDetails.previousStateId
            }
            postalCodeTxtFld.text = dictHirerDetails.previousPostalCode
            if !dictHirerDetails.previousCountry.isEmpty {
                countryLbl.text = dictHirerDetails.previousCountry
                countryLbl.textColor = UIColor(named: AppColors.BLACK)
            }
            sameAsPreviousHirerImgView.image = .checkSelected
        } else {
//            streetAddressTxtFld.text = dictHirerDetails.streetAddress
//            suburbTxtFld.text = dictHirerDetails.suburb
//            if !dictHirerDetails.state.isEmpty {
//                stateLbl.text = dictHirerDetails.state
//                stateLbl.textColor = UIColor(named: AppColors.BLACK)
//                selectedStateId = dictHirerDetails.stateId
//            }
//            postalCodeTxtFld.text = dictHirerDetails.postalCode
//            if !dictHirerDetails.country.isEmpty {
//                countryLbl.text = dictHirerDetails.country
//                countryLbl.textColor = UIColor(named: AppColors.BLACK)
//            }
            streetAddressTxtFld.text = ""
            suburbTxtFld.text = ""
            stateLbl.text = "State/Province"
            stateLbl.textColor = .AppGrey
            selectedStateId = ""
            postalCodeTxtFld.text = ""
            countryLbl.text = "Australia"
            sameAsPreviousHirerImgView.image = .checkUnselected
        }
    }
    @IBAction func submitBtn(_ sender: UIButton) {
        if !emailTxtFld.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            if !emailTxtFld.text!.isValidEmailAddress() {
                showToast(strMessage: validEmailRequired)
                return
            }
        }
        var parameters : Parameters = [:]
        switch hirerNumber {
        case 2:
            parameters = ["application_id" : CommonObject.sharedInstance.currentReferenceId,
                          "hirerno" : hirerNumber,
                          "hire2_firstname": firstNameTxtFld.text ?? "",
                          "hire2_lastname": lastNameTxtFld.text ?? "",
                          "hire2_street":streetAddressTxtFld.text ?? "",
                          "hire2_email":emailTxtFld.text ?? "",
                          "hire2_phone":phoneTxtFld.text ?? "",
                          "hire2_lic_no": licNumberTxtFld.text ?? "",
                          "hire2_exp": expTxtFld.text ?? "",
                          "hire2_dob":dateOfBirthTxtFld.text ?? "",
                          "hire2_suburb":suburbTxtFld.text ?? "",
                          "hire2_state":selectedStateId,
                          "hire2_post_code":postalCodeTxtFld.text ?? "",
                          "hire2_country": "Australia"]
        case 3:
            parameters = ["application_id" : CommonObject.sharedInstance.currentReferenceId,
                          "hirerno" : hirerNumber,
                          "hire3_firstname": firstNameTxtFld.text ?? "",
                          "hire3_lastname": lastNameTxtFld.text ?? "",
                          "hire3_street":streetAddressTxtFld.text ?? "",
                          "hire3_email":emailTxtFld.text ?? "",
                          "hire3_phone":phoneTxtFld.text ?? "",
                          "hire3_lic_no": licNumberTxtFld.text ?? "",
                          "hire3_exp": expTxtFld.text ?? "",
                          "hire3_dob":dateOfBirthTxtFld.text ?? "",
                          "hire3_suburb":suburbTxtFld.text ?? "",
                          "hire3_state":selectedStateId,
                          "hire3_post_code":postalCodeTxtFld.text ?? "",
                          "hire3_country": "Australia"]
        default:
            print("Unkown Hirer Number")
        }
        apiPostRequest(parameters: parameters, endPoint: EndPoints.ADD_HIRER)
    }
    
    @objc func licenceExpiredAlert() {
        let strDate = expTxtFld.text ?? ""
        if let date = strDate.date(from: .ddmmyyyy), date < Date() {
            showAlert(title: "Expired Date!", message: expiredLicenseDateEntered, yesTitle: "Yes", noTitle: "No", yesAction: {
                
            }, noAction: {
                self.expTxtFld.text = ""
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
    
    @objc func ListNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
           if let selectedItem = userInfo["selectedItem"] as? String {
            let selectedItemIndex = userInfo["selectedIndex"] as! Int
            print(arrStatesHirer)
            print(selectedItemIndex)
            switch userInfo["itemSelectedFromList"] as? String {
            case AppDropDownLists.STATE:
                stateLbl.textColor = UIColor(named: AppColors.BLACK)
                stateLbl.text = selectedItem
                print(arrStatesHirer)
                print(arrStatesHirer[selectedItemIndex].stateId)
                selectedStateId = arrStatesHirer[selectedItemIndex].stateId
                updatePreviousHirerAddressCheck()
            default:
                print("Unkown List")
            }
            }
        }
    }
    
    @objc func DateNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
           if let selectedDate = userInfo["selectedDate"] as? String {
            let selectedTextField = userInfo["dateTextField"] as! UITextField
            switch selectedTextField {
            case expTxtFld:
//                let selectedYear = userInfo[DatePickerKeys.SELECTED_YEAR] as? String
//                let selectedMonth = userInfo[DatePickerKeys.SELECTED_MONTH] as? String
//                expTxtFld.text = selectedYear! + "-" + selectedMonth!
                expTxtFld.text = selectedDate
                perform(#selector(licenceExpiredAlert), with: nil, afterDelay: 0.3)
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

extension AddHirerVC : UITextFieldDelegate {
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        var isKeyboard = true
//        switch textField {
//        case expTxtFld,dateOfBirthTxtFld:
//            isKeyboard = false
//            showDatePickerPopUp(textField: textField, notificationName: .dateAddHirer)
//        default:
//            print("Other TextField")
//        }
//        return isKeyboard
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTxtFld:
            textField.resignFirstResponder()
            lastNameTxtFld.becomeFirstResponder()
        case lastNameTxtFld:
            textField.resignFirstResponder()
            emailTxtFld.becomeFirstResponder()
        case emailTxtFld:
            textField.resignFirstResponder()
            phoneTxtFld.becomeFirstResponder()
        case phoneTxtFld:
            textField.resignFirstResponder()
            licNumberTxtFld.becomeFirstResponder()
        case licNumberTxtFld:
            textField.resignFirstResponder()
        case streetAddressTxtFld:
            textField.resignFirstResponder()
            suburbTxtFld.becomeFirstResponder()
        case suburbTxtFld:
            textField.resignFirstResponder()
        case postalCodeTxtFld:
            textField.resignFirstResponder()
        default:
            print("Textfield without keyboard as input")
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        updatePreviousHirerAddressCheck()
        var isAllowed = true
        switch textField {
        case phoneTxtFld,postalCodeTxtFld:
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            isAllowed = allowedCharacters.isSuperset(of: characterSet)
        case firstNameTxtFld,lastNameTxtFld :
            //To avoid getting . in name after typing double spaces between characters
            if textField.text?.last == " " && string == " " {
                textField.text = (textField.text as NSString?)?.replacingCharacters(in: range, with: " ")
                if let pos = textField.position(from: textField.beginningOfDocument, offset: range.location + 1) {
                    // updates the text caret to reflect the programmatic change to the textField
                    textField.selectedTextRange = textField.textRange(from: pos, to: pos)
                    isAllowed = false
                }
            }
            let allowedCharacters = CharacterSet.letters
            let allowedCharacters1 = CharacterSet.whitespaces
            let characterSet = CharacterSet(charactersIn: string)
            isAllowed = isAllowed && allowedCharacters.isSuperset(of: characterSet) || allowedCharacters1.isSuperset(of: characterSet)
        case expTxtFld,dateOfBirthTxtFld:
            isAllowed = textField.validateDateTyped(shouldChangeCharactersInRange: range, replacementString: string)
        default:
            print("TextField without restriction")
        }
        return isAllowed
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case expTxtFld:
            licenceExpiredAlert()
        case dateOfBirthTxtFld:
            dateOfBirthAlert()
        default:
            print("Other textfield")
        }
    }
}
extension AddHirerVC : AddHirerVMDelegate {
    func addHirerAPISuccess(objData: HirerDetailsModel, strMessage: String, serviceKey: String) {
        print(objData.dictResult)
        dictHirerDetails = objData.dictResult
        firstNameTxtFld.text = dictHirerDetails.hirerFirstName
        lastNameTxtFld.text = dictHirerDetails.hirerLastName
        emailTxtFld.text = dictHirerDetails.email
        phoneTxtFld.text = dictHirerDetails.phone
        licNumberTxtFld.text = dictHirerDetails.licenceNumber
        expTxtFld.text = dictHirerDetails.expiryDate
        dateOfBirthTxtFld.text = dictHirerDetails.dateOfBirth
        streetAddressTxtFld.text = dictHirerDetails.streetAddress
        suburbTxtFld.text = dictHirerDetails.suburb
        if !dictHirerDetails.state.isEmpty {
            stateLbl.text = dictHirerDetails.state
            stateLbl.textColor = UIColor(named: AppColors.BLACK)
            selectedStateId = dictHirerDetails.stateId
        }
        postalCodeTxtFld.text = dictHirerDetails.postalCode
        if !dictHirerDetails.country.isEmpty {
            countryLbl.text = dictHirerDetails.country
            countryLbl.textColor = UIColor(named: AppColors.BLACK)
        }
    }
    
    
    
    func addHirerAPISuccess(strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
        if serviceKey == EndPoints.ADD_HIRER {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                self.dismiss(animated: true)
            })
        }
    }
    func addHirerAPISuccess(objData: StateListModel, strMessage: String, serviceKey: String) {
        var temp = [String] ()
        for i in 0...objData.arrResult.count-1 {
            temp.append(objData.arrResult[i].stateName)
        }
        arrStatesHirer = objData.arrResult
        print(arrStatesHirer)
        listNameForSelection = AppDropDownLists.STATE
        showPickerViewPopUp(list: temp, listNameForSelection: listNameForSelection, notificationName: .listAddHirer)
    }
    
    func addHirerAPIFailure(strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
    }
       
}
