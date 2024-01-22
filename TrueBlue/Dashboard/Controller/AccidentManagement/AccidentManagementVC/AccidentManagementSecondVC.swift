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
    
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var btnAccessPaid: UIButton!
    @IBOutlet weak var btnAcessUnpaid: UIButton!
    
    var isClientAtFault = ""
    var isAccess = ""
    var arrInsurance = [InsuranceListResponse]()
    var selectedInsurance: InsuranceListResponse?
    
    var arrState = [StateListResponse]()
    var selectedState: StateListResponse?
    
    var arrRego = [RegoListResponse]()
    var selectedRego: RegoListResponse?
    
    var applicationId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchListNotificationAction(_:)), name: .searchListAtFault, object: nil)
        self.txtDateofBirth.delegate = self
        getInsuranceCompany()
        setupNotification()
        self.getCountryList()
        self.getRegoList()

    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(forName: .AccidentDetails, object: nil, queue: nil, using: { [weak self] noti in
            guard let self else { return }
            
            if let applicationId = (noti.userInfo as? NSDictionary)?.value(forKey: "ApplicationId") as? String {
                self.applicationId = applicationId
            }
        })
    }
    
    
    func showInsuranceCompany() {
        showSearchListPopUp(listForSearch: self.arrInsurance.map({ $0.insurance_company ?? "" }), listNameForSearch: AppDropDownLists.INSURANCE_COMPANY, notificationName: .searchListAtFault)
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
        
//        if txtEmail.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: email)
//            return false
//        }
        
        if txtPhone.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: phone)
            return false
        }
        
        if txtDateofBirth.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: dateofBirth)
            return false
        }
        
        if isClientAtFault.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please select client at fault")
            return false
        }
        
        if isAccess.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please select acess")
            return false
        }
        
        if txtAmount.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please enter amount")
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
        isClientAtFault = "yes"
    }
    @IBAction func btnRadioVBNo(_ sender: UIButton) {
        sender.tintColor = .systemGreen
        btnRadioVBYes.tintColor = UIColor(named: "D9D9D9")
        isClientAtFault = "no"
    }
    
    @IBAction func btnAcessPaid(_ sender: UIButton) {
        sender.tintColor = .systemGreen
        btnAcessUnpaid.tintColor = UIColor(named: "D9D9D9")
        isAccess = "paid"
    }
    
    @IBAction func btnAcessUnpaid(_ sender: UIButton) {
        sender.tintColor = .systemGreen
        btnAccessPaid.tintColor = UIColor(named: "D9D9D9")
        isAccess = "unpaid"
    }
    
    @IBAction func btnSelecteInsurance(_ sender: UIButton) {
        self.showInsuranceCompany()
    }
    
    @IBAction func btnRegistrationNumber(_ sender: Any) {
        showSearchListPopUp(listForSearch: self.arrRego.map({ $0.registration_no ?? "" }), listNameForSearch: AppDropDownLists.REGO_NUMBER, notificationName: .searchListAtFault)
    }
    
    @IBAction func btnSaveContinue(_ sender: UIButton) {
        if validationTextfield() {
            saveAndSubmit()
        }
    }
    
    @IBAction func btnStatePicker(_ sender: Any) {
        showSearchListPopUp(listForSearch: self.arrState.map({ $0.state ?? "" }), listNameForSearch: AppDropDownLists.State_Name, notificationName: .searchListAtFault)
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
            case AppDropDownLists.State_Name:
                self.selectedState = self.arrState.first(where: { ($0.state ?? "") == selectedItem })
                self.txtState.text = self.selectedState?.state
            case AppDropDownLists.REGO_NUMBER:
                self.selectedRego = self.arrRego.first(where: { ($0.registration_no ?? "") == selectedItem })
                self.txtRegistrationNo.text = self.selectedRego?.registration_no
                self.txtModel.text = "\(self.selectedRego?.vehicle_make ?? "") / \(self.selectedRego?.vehicle_model ?? "")"
            default : print("")
            }
        }
    }
    
    func saveAndSubmit() {
        var parameters: Parameters = [:]
        parameters["app_id"] = self.applicationId
        
        parameters["atfault_firstname"] = self.txtFirstName.text
        parameters["atfault_lastname"] = self.txtLastName.text
//        parameters["ownerEmail"] = self.txtEmail.text
        parameters["atfault_phone"] = self.txtPhone.text
        parameters["atfault_dob"] = self.txtDateofBirth.text
        parameters["ourdriver_atfault"] = isClientAtFault
        parameters["excess"] = isAccess
        parameters["excess_amount"] = self.txtAmount.text
        parameters["atfault_street"] = self.txtStreet.text
        parameters["atfault_suburb"] = self.txtSuburb.text
        parameters["atfault_state"] = self.selectedState?.id
        parameters["atfault_country"] = self.txtCountry.text
        parameters["atfault_postcode"] = self.txtPinCode.text
        parameters["atfault_make_model"] = self.txtModel.text
        parameters["atfault_registration_no"] = self.txtRegistrationNo.text
        parameters["atfault_insurancecompany"] = self.selectedInsurance?.ins_id
        parameters["atfault_claimno"] = self.txtClaimNo.text
        
        parameters["user_id"] = UserDefaults.standard.userId()
        parameters["user_name"] = UserDefaults.standard.username()
        parameters["request_from"] = request_from
        
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
            if let data = responseData?.convertData(AccidentModel.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? AccidentModel {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    if let appId = data.data?.app_id {
                        let dict: [String: Any] = ["ApplicationId" : appId,
                                                   "currentIndex" : 2 ]
                        
                        NotificationCenter.default.post(name: .AccidentDetails, object: nil, userInfo: dict)
                    }
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
    
    func getCountryList() {
        CommonObject().showProgress()
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.stateList)!
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
            if let data = responseData?.convertData(StateResponse.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? StateResponse {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    
                    self.arrState = data.data?.response ?? []
                    
                }
            }
        }
    }
    
    func getRegoList() {
        CommonObject().showProgress()
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.getAllFleets)!
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
            if let data = responseData?.convertData(RegoResponse.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? RegoResponse {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    
                    self.arrRego = data.data ?? []
                    
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
