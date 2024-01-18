//
//  AccidentManagementSecondVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 18/01/24.
//

import UIKit
import Alamofire

class AccidentManagementSecondVC: UIViewController {

    @IBOutlet weak var btnRadioVBYes: UIButton!
    @IBOutlet weak var btnRadioVBNo: UIButton!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtDateofBirth: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtSuburb: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtPinCode: UITextField!
    @IBOutlet weak var txtModel: UITextField!
    @IBOutlet weak var txtRegistrationNo: UITextField!
    @IBOutlet weak var txtInsuranceCompany: UITextField!
    @IBOutlet weak var txtClaimNo: UITextField!
    
    var isYourVehicleBusinessRegistered = ""
    var arrInsurance = [InsuranceListResponse]()
    var selectedInsurance: InsuranceListResponse?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchListNotificationAction(_:)), name: .searchListNotAtFault, object: nil)
        self.txtDateofBirth.delegate = self
        getInsuranceCompany()
    }
    
    func showInsuranceCompany() {
        showSearchListPopUp(listForSearch: self.arrInsurance.map({ $0.insurance_company ?? "" }), listNameForSearch: AppDropDownLists.INSURANCE_COMPANY, notificationName: .searchListNotAtFault)
    }
    
    @IBAction func btnDateOfBirth(_ sender: Any) {
        var storyboardName = String()
        var vcId = String()
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboardName = AppStoryboards.DASHBOARD
            vcId = AppStoryboardId.SELECT_DATE
        } else {
            storyboardName = AppStoryboards.DASHBOARD_PHONE
            vcId = AppStoryboardId.SELECT_DATE_PHONE
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        let ctrl = storyboard.instantiateViewController(identifier: vcId) as! SelectDateVC
        ctrl.modalPresentationStyle = .overFullScreen
        ctrl.selectedDate = { [weak self] date in
            guard let self else { return }
            self.txtDateofBirth.text = date
        }
        self.present(ctrl, animated: false)
    }
    

    func validationTextfield() -> Bool {
        
        if txtFirstName.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: firstName)
            return false
        }
        
        if txtLastName.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: lastName)
            return false
        }
        
        if txtEmail.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: email)
            return false
        }
        
        if txtPhone.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: phone)
            return false
        }
        
        if txtDateofBirth.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: dateofBirth)
            return false
        }
        
        if isYourVehicleBusinessRegistered.isEmpty ?? true {
            showAlert(title: "Error!", messsage: isVehicleBusinessRegistered)
            return false
        }
        
        
        if txtStreet.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: street)
            return false
        }
        
        if txtSuburb.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: suburb)
            return false
        }
        
        if txtState.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: state)
            return false
        }
        
        if txtCountry.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: country)
            return false
        }
        
        if txtPinCode.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: pinCode)
            return false
        }
        
        if txtModel.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: makeModel)
            return false
        }
        
        if txtRegistrationNo.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: registrationNo)
            return false
        }
        
        if txtInsuranceCompany.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: insurancecompany)
            return false
        }
        
        if txtClaimNo.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: claimNo)
            return false
        }
        
        return true
    }
    
    
    @IBAction func btnRadioVBYes(_ sender: UIButton) {
        sender.tintColor = .systemGreen
        btnRadioVBNo.tintColor = UIColor(named: "D9D9D9")
        isYourVehicleBusinessRegistered = "yes"
    }
    @IBAction func btnRadioVBNo(_ sender: UIButton) {
        sender.tintColor = .systemGreen
        btnRadioVBYes.tintColor = UIColor(named: "D9D9D9")
        isYourVehicleBusinessRegistered = "no"
    }
    @IBAction func btnSelecteInsurance(_ sender: UIButton) {
        self.showInsuranceCompany()
    }
    
    @IBAction func btnSaveContinue(_ sender: UIButton) {
        if validationTextfield() {
            saveAndSubmit()
        }
    }
}

extension AccidentManagementSecondVC {
    @objc func SearchListNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let selectedItem = userInfo["selectedItem"] as! String
            let selectedItemIndex = userInfo["selectedIndex"] as! Int
            CommonObject.sharedInstance.isDataChangedInCurrentTab = true
            switch userInfo["itemSelectedFromList"] as? String {
            case AppDropDownLists.INSURANCE_COMPANY:
                self.selectedInsurance = self.arrInsurance.first(where: { ($0.insurance_company ?? "") == selectedItem })
                self.txtInsuranceCompany.text = self.selectedInsurance?.insurance_company
            default : print("")
            }
        }
    }
    
    func saveAndSubmit() {
        var parameters: Parameters = [:]
        parameters["ownerFirstname"] = self.txtFirstName.text
        parameters["ownerLastname"] = self.txtLastName.text
        parameters["ownerEmail"] = self.txtEmail.text
        parameters["ownerPhone"] = self.txtPhone.text
        parameters["atfaultDob"] = self.txtDateofBirth.text
        parameters["is_business_registered"] = isYourVehicleBusinessRegistered
        parameters["ownerStreet"] = self.txtStreet.text
        parameters["ownerSuburb"] = self.txtSuburb.text
        parameters["ownerState"] = self.txtState.text
        parameters["ownerCountry"] = self.txtCountry.text
        parameters["atfaultPostcode"] = self.txtPinCode.text
        parameters["atfaultMakeModel"] = self.txtModel.text
        parameters["atfaultRegistration_no"] = self.txtRegistrationNo.text
        parameters["atfaultInsurancecompany"] = self.selectedInsurance?.ins_id
        parameters["atfaultClaimno"] = self.txtClaimNo.text
        
        CommonObject().showProgress()
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.accidentManagementFirst)!
        webService.method = .post
        
        webService.parameters = parameters
        
        /* API CALLS */
        WebService.shared.performMultipartWebService(model: webService, imageData: []) { [weak self] responseData, error in
            guard let self else { return }
            
            CommonObject().stopProgress()
            
            if let error {
                /* API ERROR */
                showAlert(title: "Error!", messsage: "\(error)")
                return
            }
            
            /* CONVERT JSON DATA TO MODEL */
            if let data = responseData?.convertData(NotesResponse.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? NotesResponse {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    showAlertWithAction(title: alert_title, messsage: data.msg ?? "", isOkClicked: {
                        self.dismiss(animated: true)
                    })
                }
            }
        }
        
    }
    
    func getInsuranceCompany() {
        CommonObject().showProgress()
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.INSURANCE_COMPANY_LIST)!
        webService.method = .post
                
        /* API CALLS */
        WebService.shared.performMultipartWebService(model: webService, imageData: []) { [weak self] responseData, error in
            guard let self else { return }
            
            CommonObject().stopProgress()
            
            if let error {
                /* API ERROR */
                showAlert(title: "Error!", messsage: "\(error)")
                return
            }
            
            /* CONVERT JSON DATA TO MODEL */
            if let data = responseData?.convertData(InsuranceResponse.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? InsuranceResponse {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    
                    self.arrInsurance = data.data?.response ?? []
                    
                }
            }
        }
    }
    
}

extension AccidentManagementSecondVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var isAllowed = true
        switch textField {
        case txtDateofBirth:
            isAllowed = textField.validateDateTyped(shouldChangeCharactersInRange: range, replacementString: string)
        default:
            print("TextField without restriction")
        }
        return isAllowed
    }
 
}
