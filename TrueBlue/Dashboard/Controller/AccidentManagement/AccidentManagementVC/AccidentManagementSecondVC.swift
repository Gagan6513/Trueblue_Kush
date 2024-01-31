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
    
    @IBOutlet weak var txtAviablityStatus: UITextField!
    @IBOutlet weak var txtLicenseNo: UITextField!
    @IBOutlet weak var txtExpiry: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    var isFromView = false

    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    var isClientAtFault = ""
    var isAccess = ""
    var arrInsurance = [InsuranceListResponse]()
    var selectedInsurance: InsuranceListResponse?
    
    var arrState = [StateListResponse]()
    var selectedState: StateListResponse?
    
    var arrRego = [RegoListResponse]()
    var selectedRego: RegoListResponse?
    
    var applicationId: String?
    var accidentDetails: AccidentDetailsResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchListNotificationAction(_:)), name: .searchListAtFault, object: nil)
        
        self.txtClaimNo.delegate = self
        self.txtDateofBirth.delegate = self
        self.txtExpiry.delegate = self
        
        getInsuranceCompany()
        setupNotification()
        self.getCountryList()
//        self.getRegoList()

    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(forName: .AccidentDetails, object: nil, queue: nil, using: { [weak self] noti in
            guard let self else { return }
            
            if let applicationId = (noti.userInfo as? NSDictionary)?.value(forKey: "ApplicationId") as? String {
                self.applicationId = applicationId
            }
        })
        
        NotificationCenter.default.addObserver(forName: .AccidentDetailsEdit, object: nil, queue: nil, using: { [weak self] noti in
            guard let self else { return }
            
            let userInfo = (noti.userInfo as? NSDictionary)?.value(forKey: "data") as? AccidentDetailsResponse
            self.accidentDetails = userInfo
            self.setupDetails()
        })
    }
    
    func setupDetails() {
        if let data = self.accidentDetails {
            self.applicationId = data.id
            
            self.txtFirstName.isUserInteractionEnabled = !isFromView
            self.txtLastName.isUserInteractionEnabled = !isFromView
            self.txtPhone.isUserInteractionEnabled = !isFromView
            self.txtDateofBirth.isUserInteractionEnabled = !isFromView
            self.txtAmount.isUserInteractionEnabled = !isFromView
            self.txtStreet.isUserInteractionEnabled = !isFromView
            self.txtSuburb.isUserInteractionEnabled = !isFromView
            self.txtState.isUserInteractionEnabled = !isFromView
            self.txtPinCode.isUserInteractionEnabled = !isFromView
            self.txtRegistrationNo.isUserInteractionEnabled = !isFromView
            self.txtModel.isUserInteractionEnabled = !isFromView
            self.txtAviablityStatus.isUserInteractionEnabled = !isFromView
            self.txtLicenseNo.isUserInteractionEnabled = !isFromView
            self.txtExpiry.isUserInteractionEnabled = !isFromView
            self.txtInsuranceCompany.isUserInteractionEnabled = !isFromView
            self.txtClaimNo.isUserInteractionEnabled = !isFromView

            if isFromView {
                self.btnSave.isHidden = true

                self.txtFirstName.textColor = UIColor(named: "7D7D7D")
                self.txtLastName.textColor = UIColor(named: "7D7D7D")
                self.txtPhone.textColor = UIColor(named: "7D7D7D")
                self.txtDateofBirth.textColor = UIColor(named: "7D7D7D")
                self.txtAmount.textColor = UIColor(named: "7D7D7D")
                self.txtStreet.textColor = UIColor(named: "7D7D7D")
                self.txtSuburb.textColor = UIColor(named: "7D7D7D")
                self.txtState.textColor = UIColor(named: "7D7D7D")
                self.txtPinCode.textColor = UIColor(named: "7D7D7D")
                self.txtRegistrationNo.textColor = UIColor(named: "7D7D7D")
                self.txtModel.textColor = UIColor(named: "7D7D7D")
                self.txtAviablityStatus.textColor = UIColor(named: "7D7D7D")
                self.txtLicenseNo.textColor = UIColor(named: "7D7D7D")
                self.txtExpiry.textColor = UIColor(named: "7D7D7D")
                self.txtInsuranceCompany.textColor = UIColor(named: "7D7D7D")
                self.txtClaimNo.textColor = UIColor(named: "7D7D7D")
                self.txtCountry.textColor = UIColor(named: "7D7D7D")
                
            }
            
            self.txtFirstName.text = data.atfault_firstname
            self.txtLastName.text = data.atfault_lastname
            self.txtPhone.text = data.atfault_phone
            self.txtDateofBirth.text = data.atfault_dob
            self.isClientAtFault = data.ourdriver_atfault?.lowercased() ?? ""
            self.isAccess = data.excess?.lowercased() ?? ""
            
            self.setupisAccess(str: self.isAccess)
            self.setupisClientAtFault(str: self.isClientAtFault)
            
            self.txtAmount.text = data.excess_amount
            self.txtStreet.text = data.atfault_street
            self.txtSuburb.text = data.atfault_suburb
            
            self.selectedState = self.arrState.first(where: { ($0.state ?? "") == data.atfault_state })
            self.txtState.text = self.selectedState?.state
            
            self.txtPinCode.text = data.atfault_postcode
            
//            self.selectedRego = self.arrRego.first(where: { ($0.id ?? "") == data.atfault_registration_no })
            self.txtRegistrationNo.text = data.atfault_registration_no //self.selectedRego?.registration_no
            
            self.txtModel.text = data.atfault_make_model // "\(self.selectedRego?.vehicle_make ?? "") / \(self.selectedRego?.vehicle_model ?? "")"
            self.txtAviablityStatus.text = data.liability_status
            self.txtLicenseNo.text = data.atfault_lic_no
            self.txtExpiry.text = data.atfault_exp
            
            self.selectedInsurance = self.arrInsurance.first(where: { ($0.ins_id ?? "") == data.atfault_insurancecompany })
            self.txtInsuranceCompany.text = self.selectedInsurance?.insurance_company
            self.txtClaimNo.text = data.atfault_claimno
        }
    }
    
    
    func showInsuranceCompany() {
        showSearchListPopUp(listForSearch: self.arrInsurance.map({ $0.insurance_company ?? "" }), listNameForSearch: AppDropDownLists.INSURANCE_COMPANY, notificationName: .searchListAtFault)
    }
    
    @IBAction func btnExpiry(_ sender: Any) {
        if !isFromView {
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
                self.txtExpiry.text = date
            }
            self.present(ctrl, animated: false)
        }
    }
    
    @IBAction func btnDateOfBirth(_ sender: Any) {
        if !isFromView {
            
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
    }
    

    func validationTextfield() -> Bool {
        
        // ====  // // ====  // // ====  // // ====  // // ====  //
        
//        if txtFirstName.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: firstName)
//            return false
//        }
//
//        if txtPhone.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: phone)
//            return false
//        }
//
//        if txtInsuranceCompany.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: insurancecompany)
//            return false
//        }
//
//        if isAccess.isEmpty {
//            showAlert(title: "Error!", messsage: "Please select excess")
//            return false
//        }
//
//        if isAccess.lowercased() == "paid" {
//            if txtAmount.text?.isEmpty ?? true {
//                showAlert(title: "Error!", messsage: "Please enter amount")
//                return false
//            }
//        }
//
//        if isClientAtFault.isEmpty {
//            showAlert(title: "Error!", messsage: "Please select client at fault")
//            return false
//        }
        
        
        // ====  // // ====  // // ====  // // ====  // // ====  //
//
//        if txtLastName.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: lastName)
//            return false
//        }
//
//        if txtDateofBirth.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: dateofBirth)
//            return false
//        }
//
//        if txtAviablityStatus.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: "Please enter liability status")
//            return false
//        }
//
//        if txtLicenseNo.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: "Please enter license number")
//            return false
//        }
//
//        if txtExpiry.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: "Please enter expiry date")
//            return false
//        }
//
//        if txtDateofBirth.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: dateofBirth)
//            return false
//        }
//
//        if txtDateofBirth.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: dateofBirth)
//            return false
//        }
//
//        if txtAmount.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: "Please enter amount")
//            return false
//        }
//
//        if txtStreet.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: street)
//            return false
//        }
//
//        if txtSuburb.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: suburb)
//            return false
//        }
//
//        if txtState.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: state)
//            return false
//        }
//
//        if txtCountry.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: country)
//            return false
//        }
//
//        if txtPinCode.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: pinCode)
//            return false
//        }
//
//        if txtModel.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: makeModel)
//            return false
//        }
//
//        if txtRegistrationNo.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: registrationNo)
//            return false
//        }
//
//        if txtClaimNo.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: claimNo)
//            return false
//        }
        
        return true
    }
    
    
    @IBAction func btnRadioVBYes(_ sender: UIButton) {
        if !isFromView {
            self.setupisClientAtFault(str: "yes")
        }
    }
    @IBAction func btnRadioVBNo(_ sender: UIButton) {
        if !isFromView {
            self.setupisClientAtFault(str: "no")
        }
    }
    
    func setupisClientAtFault(str: String) {
        btnRadioVBNo.tintColor = str == "no" ? .systemGreen : UIColor(named: "D9D9D9")
        btnRadioVBYes.tintColor = str == "yes" ? .systemGreen : UIColor(named: "D9D9D9")
        isClientAtFault = str
    }
    
    @IBAction func btnAcessPaid(_ sender: UIButton) {
        if !isFromView {
            self.setupisAccess(str: "paid")
        }
    }
    
    @IBAction func btnAcessUnpaid(_ sender: UIButton) {
        if !isFromView {
            self.setupisAccess(str: "unpaid")
        }
    }
    
    func setupisAccess(str: String) {
        btnAcessUnpaid.tintColor = str == "unpaid" ? .systemGreen : UIColor(named: "D9D9D9")
        btnAccessPaid.tintColor = str == "paid" ? .systemGreen : UIColor(named: "D9D9D9")
        isAccess = str
    }
    
    @IBAction func btnSelecteInsurance(_ sender: UIButton) {
        if !isFromView {
            self.showInsuranceCompany()
        }
    }
    
    @IBAction func btnRegistrationNumber(_ sender: Any) {
        showSearchListPopUp(listForSearch: self.arrRego.map({ $0.registration_no ?? "" }), listNameForSearch: AppDropDownLists.REGO_NUMBER, notificationName: .searchListAtFault)
    }
    
    @IBAction func btnSaveContinue(_ sender: UIButton) {
        if !isFromView {
            if validationTextfield() {
                saveAndSubmit()
            }
        }
    }
    
    @IBAction func btnStatePicker(_ sender: Any) {
        if !isFromView {
            showSearchListPopUp(listForSearch: self.arrState.map({ $0.state ?? "" }), listNameForSearch: AppDropDownLists.State_Name, notificationName: .searchListAtFault)
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
        parameters["atfault_registration_no"] = self.txtRegistrationNo.text // self.selectedRego?.registration_no
        parameters["liability_status"] = self.txtAviablityStatus.text?.uppercased()
        parameters["atfault_lic_no"] = self.txtLicenseNo.text
        parameters["atfault_exp"] = self.txtExpiry.text
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
                    if let data = self.accidentDetails {
                        self.selectedInsurance = self.arrInsurance.first(where: { ($0.ins_id ?? "") == data.atfault_insurancecompany })
                        self.txtInsuranceCompany.text = self.selectedInsurance?.insurance_company
                    }
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
                    
                    
                    if let data = self.accidentDetails {
                        self.selectedState = self.arrState.first(where: { ($0.id ?? "") == data.atfault_state })
                        self.txtState.text = self.selectedState?.state
                    }
                    
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
        webService.parameters = ["status": "active"]
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
                    if let data = self.accidentDetails {
                        self.selectedRego = self.arrRego.first(where: { ($0.id ?? "") == data.atfault_registration_no })
                        self.txtRegistrationNo.text = self.selectedRego?.registration_no
                    }
                }
            }
        }
    }
    
}

extension AccidentManagementSecondVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var isAllowed = true
        switch textField {
        case txtDateofBirth, txtExpiry:
            isAllowed = textField.validateDateTyped(shouldChangeCharactersInRange: range, replacementString: string)
        case txtClaimNo:
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            isAllowed = (string == filtered)
        default:
            print("TextField without restriction")
        }
        return isAllowed
    }
 
}
