//
//  AccidentManagementFirstVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 18/01/24.
//

import UIKit
import Alamofire

class AccidentManagementFirstVC: UIViewController {

    @IBOutlet weak var btnRadioVBYes: UIButton!
    
    @IBOutlet weak var txtRefNumber: UILabel!
    @IBOutlet weak var btnRadioVBNo: UIButton!
    @IBOutlet weak var btnRadioCarDrivable: UIButton!
    @IBOutlet weak var btnRadioCarNotDrivable: UIButton!
    @IBOutlet weak var txtSelectBranch: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtRecoverFor: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtSuburb: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtPinCode: UITextField!
    
    @IBOutlet weak var txtModel: UITextField!
    @IBOutlet weak var txtRegistrationNo: UITextField!
    @IBOutlet weak var txtInsuranceCompany: UITextField!
    @IBOutlet weak var txtClaimNo: UITextField!
    
    var accidentData: AccidentDetailsResponse?
    
    var isYourVehicleBusinessRegistered = ""
    var isYourCarDrivable = ""
    var arrBranch = [BranchListResponse]()
    var selectedBranch: BranchListResponse?
    
    var arrInsurance = [InsuranceListResponse]()
    var selectedInsurance: InsuranceListResponse?
    
    var arrState = [StateListResponse]()
    var selectedState: StateListResponse?
    
    var arrRego = [RegoListResponse]()
    var selectedRego: RegoListResponse?
    
    var applicationId: String?
    
    var recoveryForArr = ["Trueblue", "Repairer"]
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchListNotificationAction(_:)), name: .searchListNotAtFault, object: nil)

        self.txtClaimNo.delegate = self
        
        self.getBranchList()
        
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(forName: .AccidentDetails, object: nil, queue: nil, using: { [weak self] noti in
            guard let self else { return }
            
            if let applicationId = (noti.userInfo as? NSDictionary)?.value(forKey: "ApplicationId") as? String {
                self.applicationId = applicationId
            }
        })
    }
   
    @IBAction func btnRegoNumber(_ sender: Any) {
        showSearchListPopUp(listForSearch: self.arrRego.map({ $0.registration_no ?? "" }), listNameForSearch: AppDropDownLists.REGO_NUMBER, notificationName: .searchListNotAtFault)
    }
    
    @IBAction func btnStatePicker(_ sender: Any) {
        showSearchListPopUp(listForSearch: self.arrState.map({ $0.state ?? "" }), listNameForSearch: AppDropDownLists.State_Name, notificationName: .searchListNotAtFault)
    }
    
    @IBAction func btnRadioVBYes(_ sender: UIButton) {
        self.setupBussinessRegisterd(str: "yes")
    }
    @IBAction func btnRadioVBNo(_ sender: UIButton) {
        self.setupBussinessRegisterd(str: "no")
    }
    
    func setupBussinessRegisterd(str: String) {
        btnRadioVBNo.tintColor = str == "no" ? .systemGreen : UIColor(named: "D9D9D9")
        btnRadioVBYes.tintColor = str == "yes" ? .systemGreen : UIColor(named: "D9D9D9")
        isYourVehicleBusinessRegistered = str
    }
    
    @IBAction func btnRadioCarDrivable(_ sender: UIButton) {
        self.setupisYourCarDrivable(str: "yes")
    }
    @IBAction func btnRadioCarNotDrivable(_ sender: UIButton) {
        self.setupisYourCarDrivable(str: "no")
    }
    
    func setupisYourCarDrivable(str: String) {
        btnRadioCarNotDrivable.tintColor = str == "no" ? .systemGreen : UIColor(named: "D9D9D9")
        btnRadioCarDrivable.tintColor = str == "yes" ? .systemGreen : UIColor(named: "D9D9D9")
        isYourCarDrivable = str
    }
    
    @IBAction func btnSaveContinue(_ sender: UIButton) {
//        self.appId?("")
        if validationTextfield() {
            saveAndSubmit()
        }
        
    }
    @IBAction func btnSelectBranch(_ sender: UIButton) {
        showBranchList()
    }
    @IBAction func btnSelecteInsurance(_ sender: Any) {
        self.showInsuranceCompany()
    }
    
    @IBAction func btnRecoveryFor(_ sender: Any) {
        self.showRecoveryFor()
    }
    func showBranchList() {
        showSearchListPopUp(listForSearch: self.arrBranch.map({ $0.name ?? "" }), listNameForSearch: AppDropDownLists.BRANCH_NAME, notificationName: .searchListNotAtFault)
    }
    
    func showRecoveryFor() {
        showSearchListPopUp(listForSearch: self.recoveryForArr, listNameForSearch: AppDropDownLists.RECOVERY_FOR, notificationName: .searchListNotAtFault)
    }
    
    func showInsuranceCompany() {
        showSearchListPopUp(listForSearch: self.arrInsurance.map({ $0.insurance_company ?? "" }), listNameForSearch: AppDropDownLists.INSURANCE_COMPANY, notificationName: .searchListNotAtFault)
    }
    
    func setupDetails() {
        if let data = self.accidentData {
            self.applicationId = data.id
            
            self.selectedBranch = self.arrBranch.first(where: { ($0.id ?? "") == data.branch })
            self.txtSelectBranch.text = self.selectedBranch?.name

            self.txtFirstName.text = data.owner_firstname
            self.txtLastName.text = data.owner_lastname
            self.txtEmail.text = data.owner_email
            self.txtPhone.text = data.owner_phone
            self.txtRecoverFor.text = data.recovery_for?.capitalized
            self.txtClaimNo.text = data.owner_claimno
            
            self.isYourVehicleBusinessRegistered = data.is_business_registered?.lowercased() ?? ""
            self.setupBussinessRegisterd(str: self.isYourVehicleBusinessRegistered)
            
            self.isYourCarDrivable = data.vehicle_drivable?.lowercased() ?? ""
            self.setupisYourCarDrivable(str: self.isYourCarDrivable)
            
            self.txtStreet.text = data.owner_street
            self.txtSuburb.text = data.owner_suburb

            self.selectedState = self.arrState.first(where: { ($0.id ?? "") == data.owner_state })
            self.txtState.text = self.selectedState?.state
            
            self.txtPinCode.text = data.owner_postcode
            
            self.selectedRego = self.arrRego.first(where: { ($0.id ?? "") == data.accident_rego })
            self.txtRegistrationNo.text = self.selectedRego?.registration_no
            self.txtModel.text = "\(self.selectedRego?.vehicle_make ?? "") / \(self.selectedRego?.vehicle_model ?? "")"
         
            self.selectedInsurance = self.arrInsurance.first(where: { ($0.ins_id ?? "") == data.insurance })
            self.txtInsuranceCompany.text = self.selectedInsurance?.insurance_company
            
        }
    }
    
    func validationTextfield() -> Bool {
        
        if txtRegistrationNo.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: registrationNo)
            return false
        }
        
        if txtFirstName.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: firstName)
            return false
        }
        
        if txtPhone.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: phone)
            return false
        }
        
        if txtInsuranceCompany.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: insurancecompany)
            return false
        }
        
        if isYourVehicleBusinessRegistered.isEmpty {
            showAlert(title: "Error!", messsage: isVehicleBusinessRegistered)
            return false
        }
        
        if isYourCarDrivable.isEmpty {
            showAlert(title: "Error!", messsage: isCarDrivable)
            return false
        }
        
        
//        if txtSelectBranch.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: selectBranch)
//            return false
//        }
//
//        if txtLastName.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: lastName)
//            return false
//        }
//
//        if txtEmail.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: email)
//            return false
//        }
//
//        if txtRecoverFor.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: recoverFor)
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
//        if txtClaimNo.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: claimNo)
//            return false
//        }
        
        return true
    }
    
}

extension AccidentManagementFirstVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case txtClaimNo:
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            return (string == filtered)
        default: return true
        }
    }
}

extension AccidentManagementFirstVC {

    @objc func SearchListNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let selectedItem = userInfo["selectedItem"] as! String
            let selectedItemIndex = userInfo["selectedIndex"] as! Int
            CommonObject.sharedInstance.isDataChangedInCurrentTab = true
            switch userInfo["itemSelectedFromList"] as? String {
            case AppDropDownLists.BRANCH_NAME:
                self.selectedBranch = self.arrBranch.first(where: { ($0.name ?? "") == selectedItem })
                self.txtSelectBranch.text = self.selectedBranch?.name
            case AppDropDownLists.RECOVERY_FOR:
                self.txtRecoverFor.text = selectedItem
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
        parameters["branch"] = self.selectedBranch?.id
        parameters["is_accident_ref"] = 1
        parameters["owner_firstname"] = self.txtFirstName.text
        parameters["owner_lastname"] = self.txtLastName.text
        parameters["owner_email"] = self.txtEmail.text
        parameters["owner_phone"] = self.txtPhone.text
        parameters["recovery_for"] = self.txtRecoverFor.text?.lowercased()
        parameters["is_business_registered"] = isYourVehicleBusinessRegistered
        parameters["vehicle_drivable"] = isYourCarDrivable
        parameters["owner_street"] = self.txtStreet.text
        parameters["owner_suburb"] = self.txtSuburb.text
        parameters["owner_state"] = self.selectedState?.id
        parameters["owner_country"] = self.txtCountry.text
        parameters["owner_postcode"] = self.txtPinCode.text
        parameters["owner_make_model"] = self.txtModel.text
        parameters["accident_rego"] = self.selectedRego?.id // self.txtRegistrationNo.text
        parameters["insurance"] = self.selectedInsurance?.ins_id
        parameters["owner_claimno"] = self.txtClaimNo.text
        
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
                    if let appId = data.data?.application_id {
                        self.txtRefNumber.text = "Ref# " + appId
                    }
                    if let appId = data.data?.app_id {
                        let dict: [String: Any] = ["ApplicationId" : appId,
                                                   "currentIndex" : 1 ]
                        
                        NotificationCenter.default.post(name: .AccidentDetails, object: nil, userInfo: dict)
                    }
                }
            }
        }
        
    }
    
    func getBranchList() {
        CommonObject().showProgress()
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.BRANCH_LIST)!
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
            if let data = responseData?.convertData(BranchResponse.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? BranchResponse {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    
                    self.arrBranch = data.data?.response ?? []
                    self.getInsuranceCompany()
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
                    self.getCountryList()
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
                    self.getRegoList()
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
                    self.applicationId != nil ? self.getAccidentDetialsForEditProfile() : nil
                }
            }
        }
    }
    
    func getAccidentDetialsForEditProfile() {
        CommonObject().showProgress()
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.getReferenceDetails)!
        webService.method = .post
        webService.parameters = ["app_id": self.applicationId ?? ""]
        
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
            if let data = responseData?.convertData(AccidentDetailsModel.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? AccidentDetailsModel {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    
                    self.accidentData = data.data?.response
                    
                    if let data = self.accidentData {
                        let data: [String: Any] = ["data": data]
                        NotificationCenter.default.post(name: .AccidentDetailsEdit, object: nil, userInfo: data)
                    }
                    
                    self.setupDetails()
                }
            }
        }
    }
}
