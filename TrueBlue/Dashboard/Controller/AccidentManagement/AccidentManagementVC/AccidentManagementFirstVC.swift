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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchListNotificationAction(_:)), name: .searchListNotAtFault, object: nil)

        self.getBranchList()
        self.getInsuranceCompany()
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
   
    @IBAction func btnRegoNumber(_ sender: Any) {
        showSearchListPopUp(listForSearch: self.arrRego.map({ $0.registration_no ?? "" }), listNameForSearch: AppDropDownLists.REGO_NUMBER, notificationName: .searchListNotAtFault)
    }
    
    @IBAction func btnStatePicker(_ sender: Any) {
        showSearchListPopUp(listForSearch: self.arrState.map({ $0.state ?? "" }), listNameForSearch: AppDropDownLists.State_Name, notificationName: .searchListNotAtFault)
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
    @IBAction func btnRadioCarDrivable(_ sender: UIButton) {
        sender.tintColor = .systemGreen
        btnRadioCarNotDrivable.tintColor = UIColor(named: "D9D9D9")
        isYourCarDrivable = "yes"
    }
    @IBAction func btnRadioCarNotDrivable(_ sender: UIButton) {
        sender.tintColor = .systemGreen
        btnRadioCarDrivable.tintColor = UIColor(named: "D9D9D9")
        isYourCarDrivable = "no"
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
        showSearchListPopUp(listForSearch: self.arrBranch.map({ $0.branch_name ?? "" }), listNameForSearch: AppDropDownLists.BRANCH_NAME, notificationName: .searchListNotAtFault)
    }
    
    func showRecoveryFor() {
        showSearchListPopUp(listForSearch: self.recoveryForArr, listNameForSearch: AppDropDownLists.RECOVERY_FOR, notificationName: .searchListNotAtFault)
    }
    
    func showInsuranceCompany() {
        showSearchListPopUp(listForSearch: self.arrInsurance.map({ $0.insurance_company ?? "" }), listNameForSearch: AppDropDownLists.INSURANCE_COMPANY, notificationName: .searchListNotAtFault)
    }
    
    
    func validationTextfield() -> Bool {
        
        if txtSelectBranch.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: selectBranch)
            return false
        }
        
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
        
        if txtRecoverFor.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: recoverFor)
            return false
        }
        
        if isYourVehicleBusinessRegistered.isEmpty ?? true {
            showAlert(title: "Error!", messsage: isVehicleBusinessRegistered)
            return false
        }
        
        if isYourCarDrivable.isEmpty ?? true {
            showAlert(title: "Error!", messsage: isCarDrivable)
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
    
}

extension AccidentManagementFirstVC {

    @objc func SearchListNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let selectedItem = userInfo["selectedItem"] as! String
            let selectedItemIndex = userInfo["selectedIndex"] as! Int
            CommonObject.sharedInstance.isDataChangedInCurrentTab = true
            switch userInfo["itemSelectedFromList"] as? String {
            case AppDropDownLists.BRANCH_NAME:
                self.selectedBranch = self.arrBranch.first(where: { ($0.branch_name ?? "") == selectedItem })
                self.txtSelectBranch.text = self.selectedBranch?.branch_name
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
        parameters["branch"] = self.selectedBranch?.branch_id
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
        parameters["accident_rego"] = self.txtRegistrationNo.text
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
