//
//  FleetServiceVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 31/01/24.
//

import UIKit
import IQKeyboardManagerSwift
import DKImagePickerController
import Alamofire

class FleetServiceVC: UIViewController {

    @IBOutlet weak var txtRegoNo: UITextField!
    @IBOutlet weak var txtMakeModel: UITextField!
    @IBOutlet weak var txtRepairer: UITextField!
    @IBOutlet weak var txtInvoiceNo: UITextField!
    @IBOutlet weak var txtAmountPaid: UITextField!
    @IBOutlet weak var txtAmountPaidDate: UITextField!
    @IBOutlet weak var txtServiceDate: UITextField!
    @IBOutlet weak var txtServiceMileage: UITextField!
    @IBOutlet weak var txtNextServiceDue: UITextField!
    @IBOutlet weak var txtNote: IQTextView!
    @IBOutlet weak var txtKms: UITextField!
    @IBOutlet weak var txtLastServiceDate: UITextField!
    @IBOutlet weak var txtLastServiceBy: UITextField!
    
    @IBOutlet weak var serviceSleepImage: UIImageView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var isFromView = false
    var serviceData: AccidentService?
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

    var arrRego = [RegoListResponse]()
    var selectedRego: RegoListResponse?
    
    var arrRepaired = [RepairerListResponse]()
    var selectedRepairer: RepairerListResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtMakeModel.textColor = UIColor(named: "7D7D7D")
        self.setupNotification()
        self.txtAmountPaidDate.delegate = self
        self.txtServiceDate.delegate = self
        self.txtLastServiceDate.delegate = self
        self.txtInvoiceNo.delegate = self
        DispatchQueue.main.async {
            self.getServiceDetails()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchListNotificationAction(_:)), name: .searchListNotAtFault, object: nil)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnSelectRego(_ sender: Any) {
        if isFromView { return }
        showSearchListPopUp(listForSearch: self.arrRego.map({ $0.registration_no ?? "" }), listNameForSearch: AppDropDownLists.REGO_NUMBER, notificationName: .searchListNotAtFault)
    }
    
    @IBAction func btnSelectRepairer(_ sender: Any) {
        if isFromView { return }
        showSearchListPopUp(listForSearch: self.arrRepaired.map({ $0.repairer_name ?? "" }), listNameForSearch: AppDropDownLists.REPAIRER, notificationName: .searchListNotAtFault)
    }
    
    @IBAction func btnSelectPaidDate(_ sender: Any) {
        self.selectDate(txt: self.txtAmountPaidDate)
    }
    
    @IBAction func btnSelectServiceDate(_ sender: Any) {
        self.selectDate(txt: self.txtServiceDate)
    }
    
    @IBAction func btnUploadImage(_ sender: Any) {
        self.openPicker()
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        if self.validation() {
            self.saveAndSubmit()
        }
    }
    
    func validation() -> Bool {
        
        if txtRegoNo.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please select rego number")
            return false
        }

        if txtRepairer.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please select repairer")
            return false
        }

        if txtInvoiceNo.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please enter invoice number")
            return false
        }
        
        if txtAmountPaid.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please enter paid amount")
            return false
        }
        
        if txtServiceDate.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please enter service date")
            return false
        }
        
        if txtServiceMileage.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please enter service mileage")
            return false
        }
        
        if txtNextServiceDue.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please enter next service due")
            return false
        }
        
        if txtNote.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please enter note")
            return false
        }
        
        if serviceSleepImage.image == nil {
            showAlert(title: "Error!", messsage: "Please select service sleep image")
            return false
        }
        
        if txtKms.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please enter kms")
            return false
        }
        
        if txtLastServiceDate.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please enter last service date")
            return false
        }
        
        if txtLastServiceBy.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please enter last service by")
            return false
        }
        
        return true
    }
    
    func openPicker() {
        if isFromView { return }
        let multipleImgPickerController = DKImagePickerController()
        multipleImgPickerController.maxSelectableCount = 1
        multipleImgPickerController.modalPresentationStyle = .fullScreen
        multipleImgPickerController.assetType = .allPhotos
        multipleImgPickerController.showsCancelButton = true
        multipleImgPickerController.UIDelegate = CustomUIDelegate()
        multipleImgPickerController.didSelectAssets = { (assets: [DKAsset]) in
            for asset in assets {
                asset.fetchOriginalImage(completeBlock: {image,info in
                    guard let img = image else { return }
                    self.serviceSleepImage.image = img
                })
            }
        }
        self.present(multipleImgPickerController, animated: true) {}
    }
    
    @objc func SearchListNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let selectedItem = userInfo["selectedItem"] as! String
//            let selectedItemIndex = userInfo["selectedIndex"] as! Int
            CommonObject.sharedInstance.isDataChangedInCurrentTab = true
            switch userInfo["itemSelectedFromList"] as? String {
            case AppDropDownLists.REGO_NUMBER:
                self.selectedRego = self.arrRego.first(where: { ($0.registration_no ?? "") == selectedItem })
                self.txtRegoNo.text = self.selectedRego?.registration_no
                self.txtMakeModel.text = "\(self.selectedRego?.vehicle_make ?? "") / \(self.selectedRego?.vehicle_model ?? "")"
            case AppDropDownLists.REPAIRER:
                self.selectedRepairer = self.arrRepaired.first(where: { ($0.repairer_name ?? "") == selectedItem })
                self.txtRepairer.text = self.selectedRepairer?.repairer_name
                self.txtLastServiceBy.text = self.selectedRepairer?.repairer_name
            default : print("")
            }
        }
    }
    
    func selectDate(txt: UITextField) {
        if isFromView { return }
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
            txt.text = date
        }
        self.present(ctrl, animated: false)
    }
    
    func setupDetails() {
        self.txtRegoNo.isUserInteractionEnabled = !isFromView
        self.txtMakeModel.isUserInteractionEnabled = !isFromView
        self.txtRepairer.isUserInteractionEnabled = !isFromView
        self.txtInvoiceNo.isUserInteractionEnabled = !isFromView
        self.txtAmountPaid.isUserInteractionEnabled = !isFromView
        self.txtAmountPaidDate.isUserInteractionEnabled = !isFromView
        self.txtServiceDate.isUserInteractionEnabled = !isFromView
        self.txtServiceMileage.isUserInteractionEnabled = !isFromView
        self.txtNextServiceDue.isUserInteractionEnabled = !isFromView
        self.txtNote.isUserInteractionEnabled = !isFromView
        self.txtKms.isUserInteractionEnabled = !isFromView
        self.txtLastServiceDate.isUserInteractionEnabled = !isFromView
        self.txtLastServiceBy.isUserInteractionEnabled = !isFromView
        
        if isFromView {
            self.btnSubmit.isHidden = true
            self.txtRegoNo.textColor = UIColor(named: "7D7D7D")
            self.txtMakeModel.textColor = UIColor(named: "7D7D7D")
            self.txtRepairer.textColor = UIColor(named: "7D7D7D")
            self.txtInvoiceNo.textColor = UIColor(named: "7D7D7D")
            self.txtAmountPaid.textColor = UIColor(named: "7D7D7D")
            self.txtAmountPaidDate.textColor = UIColor(named: "7D7D7D")
            self.txtServiceDate.textColor = UIColor(named: "7D7D7D")
            self.txtServiceMileage.textColor = UIColor(named: "7D7D7D")
            self.txtNextServiceDue.textColor = UIColor(named: "7D7D7D")
            self.txtNote.textColor = UIColor(named: "7D7D7D")
            self.txtKms.textColor = UIColor(named: "7D7D7D")
            self.txtLastServiceDate.textColor = UIColor(named: "7D7D7D")
            self.txtLastServiceBy.textColor = UIColor(named: "7D7D7D")
        }
        
        self.txtInvoiceNo.text = self.serviceData?.invoice_number
        self.txtAmountPaid.text = self.serviceData?.amount_paid
        self.txtAmountPaidDate.text = self.serviceData?.amount_paid_date
        self.txtServiceDate.text = self.serviceData?.service_date
        self.txtServiceMileage.text = self.serviceData?.service_mileage
        self.txtNextServiceDue.text = self.serviceData?.nextserviceduekm
        self.txtNote.text = self.serviceData?.Notes
        self.txtKms.text = self.serviceData?.last_service_mileage
        self.txtLastServiceDate.text = self.serviceData?.last_service_date
        
        if let url = URL(string: self.serviceData?.service_slip ?? "") {
            self.serviceSleepImage.sd_setImage(with: url)
        }
    }
    
}


extension FleetServiceVC {
    
    
    func getServiceDetails() {
        CommonObject().showProgress()
        
        if self.serviceData == nil {
            self.getRegoList()
            return
        }
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.getServiceDetails)!
        webService.method = .post
        webService.parameters = ["service_id": self.serviceData?.id ?? "0"]
        /* API CALLS */
        WebService.shared.performMultipartWebService(model: webService, imageData: []) { [weak self] responseData, error in
            guard let self else { return }
            
//            CommonObject().stopProgress()
            
            if let error {
                /* API ERROR */
                showAlert(title: "Error!", messsage: "\(error)")
                return
            }
            
            /* CONVERT JSON DATA TO MODEL */
            if let data = responseData?.convertData(AccidentServiceDetailsModel.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? AccidentServiceDetailsModel {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    
                    if let serviceDataa = data.data?.response {
                        self.serviceData = serviceDataa
                    }
                    self.setupDetails()
                    self.getRegoList()
                }
            }
        }
    }
    
    func getRegoList() {
//        CommonObject().showProgress()
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.getAllFleets)!
        webService.method = .post
        webService.parameters = ["status": "all"]
        /* API CALLS */
        WebService.shared.performMultipartWebService(model: webService, imageData: []) { [weak self] responseData, error in
            guard let self else { return }
            
//            CommonObject().stopProgress()
            
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
                    if let data = self.serviceData {
                        self.selectedRego = self.arrRego.first(where: { ($0.registration_no ?? "") == self.serviceData?.registration_no })
                        self.txtRegoNo.text = self.selectedRego?.registration_no
                        self.txtMakeModel.text = "\(self.selectedRego?.vehicle_make ?? "") / \(self.selectedRego?.vehicle_model ?? "")"
                    }
                    self.getReparierName()
                }
            }
        }
    }
    
    func getReparierName() {
//        CommonObject().showProgress()
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.REPAIRER_LIST)!
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
            if let data = responseData?.convertData(RepairerResponse.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? RepairerResponse {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    
                    self.arrRepaired = data.data?.response ?? []
                    
                    if let data = self.serviceData {
                        self.selectedRepairer = self.arrRepaired.first(where: { ($0.rep_id ?? "") == data.repairer_id })
                        self.txtRepairer.text = self.selectedRepairer?.repairer_name
                        self.txtLastServiceBy.text = self.selectedRepairer?.repairer_name
                    }
                }
            }
        }
    }
    
    func saveAndSubmit() {
        var parameters: Parameters = [:]
        parameters["vehicle_id"] = self.selectedRego?.id
        parameters["repairer_id"] = self.selectedRepairer?.rep_id
        parameters["invoice_number"] = self.txtInvoiceNo.text
        parameters["amount_paid"] = self.txtAmountPaid.text
        parameters["amount_paid_date"] = self.txtAmountPaidDate.text
        parameters["service_date"] = self.txtServiceDate.text
        parameters["service_mileage"] = self.txtServiceMileage.text
        parameters["notes"] = self.txtNote.text
//        parameters["service_slip"] = isYourVehicleBusinessRegistered
        parameters["nextserviceduekm"] = self.txtNextServiceDue.text
        parameters["service_id"] = self.serviceData?.id ?? ""
        
        parameters["user_id"] = UserDefaults.standard.userId()
        parameters["user_name"] = UserDefaults.standard.username()
        parameters["request_from"] = request_from
        
        CommonObject().showProgress()
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.saveServiceDetails)!
        webService.method = .post
        
        webService.parameters = parameters
        
        var profileImageData: [Dictionary<String, Any>] = []
//
        if let img = self.serviceSleepImage.image, let data = img.jpeg(.medium) {
            profileImageData.append(["title": "service_slip", "image": data])
        }
        
        /* API CALLS */
//        WebService.shared.performMultipartWebService(model: webService, imageData: profileImageData) { [weak self] responseData, error in
            
        WebService.shared.performMultipartWebService(endPoint: API_URL.saveServiceDetails, parameters: parameters, imageData: profileImageData) { [weak self] responseData, error in
            
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
                    
                    NotificationCenter.default.post(name: .refreshFleetList, object: nil)
                    
                    self.dismiss(animated: true)
                    
                }
            }
        }
        
    }
}

extension FleetServiceVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var isAllowed = true
        switch textField {
        case txtServiceDate, txtAmountPaidDate, txtLastServiceDate:
            isAllowed = textField.validateDateTyped(shouldChangeCharactersInRange: range, replacementString: string)
        case txtInvoiceNo:
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            isAllowed = (string == filtered)
        default:
            print("TextField without restriction")
        }
        return isAllowed
    }
 
}
