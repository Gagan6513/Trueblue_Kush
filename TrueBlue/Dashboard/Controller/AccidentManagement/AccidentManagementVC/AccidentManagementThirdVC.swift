//
//  AccidentManagementThirdVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 18/01/24.
//

import UIKit
import Alamofire

class AccidentManagementThirdVC: UIViewController {

    @IBOutlet weak var txtDateofAccident: UITextField!
    @IBOutlet weak var txtTimeofAccident: UITextField!
    @IBOutlet weak var txtAccidentLocation: UITextField!
    @IBOutlet weak var txtRepairerName: UITextField!
    @IBOutlet weak var txtReferralName: UITextField!
    @IBOutlet weak var txtViewAccidentDescription: UITextView!
    
    @IBOutlet weak var btnSave: UIButton!
    
    var arrRepaired = [RepairerListResponse]()
    var selectedRepairer: RepairerListResponse?
    
    var arrReferral = [ReferalListResponse]()
    var selectedReferral: ReferalListResponse?
    
    var applicationId: String?
    
    var accidentDetails: AccidentDetailsResponse?
    var isFromView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtDateofAccident.delegate = self
        self.txtTimeofAccident.delegate = self
        self.getReparierName()
        self.getReferralName()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchListNotificationAction(_:)), name: .searchListNotAtFault, object: nil)
        self.setupNotification()
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
            
            self.txtDateofAccident.isUserInteractionEnabled = !isFromView
            self.txtTimeofAccident.isUserInteractionEnabled = !isFromView
            self.txtAccidentLocation.isUserInteractionEnabled = !isFromView
            self.txtViewAccidentDescription.isUserInteractionEnabled = !isFromView
            self.txtReferralName.isUserInteractionEnabled = !isFromView
            self.txtRepairerName.isUserInteractionEnabled = !isFromView

            if isFromView {
                self.btnSave.isHidden = true
                self.txtDateofAccident.textColor = UIColor(named: "7D7D7D")
                self.txtTimeofAccident.textColor = UIColor(named: "7D7D7D")
                self.txtAccidentLocation.textColor = UIColor(named: "7D7D7D")
                self.txtViewAccidentDescription.textColor = UIColor(named: "7D7D7D")
                self.txtReferralName.textColor = UIColor(named: "7D7D7D")
                self.txtRepairerName.textColor = UIColor(named: "7D7D7D")
            }
            
            self.txtDateofAccident.text = data.dateof_accident
            self.txtTimeofAccident.text = data.timeofaccident
            self.txtAccidentLocation.text = data.accident_location
            self.txtViewAccidentDescription.text = data.description
            
            self.selectedReferral = self.arrReferral.first(where: { ($0.referral_name ?? "") == data.referral_name })
            self.txtReferralName.text = self.selectedReferral?.referral_name
            
            self.selectedRepairer = self.arrRepaired.first(where: { ($0.repairer_name ?? "") == data.repairer_name })
            self.txtRepairerName.text = self.selectedRepairer?.repairer_name
        }
    }
    
    func validationTextfield() -> Bool {
        
//        if txtDateofAccident.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: dateofAccident)
//            return false
//        }
//        
//        if txtTimeofAccident.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: timeofAccident)
//            return false
//        }
//        
//        if txtAccidentLocation.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: accidentLocation)
//            return false
//        }
        
//        if txtReferralName.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: referralName)
//            return false
//        }
        
//        if txtRepairerName.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: referralName)
//            return false
//        }
        
        if txtViewAccidentDescription.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: viewAccidentDescription)
            return false
        }
        
        return true
    }
    
    @IBAction func btnSaveContinue(_ sender: UIButton) {
        if !isFromView {
            if validationTextfield() {
                saveAndSubmit()
            }
        }
    }
    
    @IBAction func btnDateOfAccident(_ sender: Any) {
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
                self.txtDateofAccident.text = date
            }
            self.present(ctrl, animated: false)
        }
    }
    
    @IBAction func btnTimeOfAccident(_ sender: Any) {
        if !isFromView {
            
            var storyboardName = String()
            var vcId = String()
            if UIDevice.current.userInterfaceIdiom == .pad {
                storyboardName = AppStoryboards.DASHBOARD
                vcId = AppStoryboardId.SELECT_TIME
            } else {
                storyboardName = AppStoryboards.DASHBOARD_PHONE
                vcId = AppStoryboardId.SELECT_TIME_PHONE
            }
            let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
            let ctrl = storyboard.instantiateViewController(withIdentifier: vcId) as! SelectTimeVC
            ctrl.modalPresentationStyle = .overFullScreen
            ctrl.selectedDate = { [weak self] date in
                guard let self else { return }
                self.txtTimeofAccident.text = date
            }
            self.present(ctrl, animated: false)
        }
    }
    
    @IBAction func btnReferralName(_ sender: Any) {
        if !isFromView {
            self.openReferalList()
        }
    }
    
    @IBAction func btnRepairerName(_ sender: Any) {
        if !isFromView {
            self.openRepairerList()
        }
    }
    
    func openRepairerList() {
        showSearchListPopUp(listForSearch: self.arrRepaired.map({ $0.repairer_name ?? "" }), listNameForSearch: AppDropDownLists.REPAIRER,notificationName: .searchListNotAtFault)
    }
    
    func openReferalList() {
        showSearchListPopUp(listForSearch: self.arrReferral.map({ $0.referral_name ?? "" }), listNameForSearch: AppDropDownLists.REFERRAL,notificationName: .searchListNotAtFault)
    }
    
}

extension AccidentManagementThirdVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var isAllowed = true
        switch textField {
        case txtDateofAccident:
            isAllowed = textField.validateDateTyped(shouldChangeCharactersInRange: range, replacementString: string)
        case txtTimeofAccident:
            isAllowed = textField.validateTimeTyped(shouldChangeCharactersInRange: range, replacementString: string)
        default:
            print("TextField without restriction")
        }
        return isAllowed
    }
    
}


extension AccidentManagementThirdVC {
    
    func saveAndSubmit() {
        var parameters: Parameters = [:]
        parameters["app_id"] = self.applicationId

        parameters["dateof_accident"] = txtDateofAccident.text
        parameters["timeofaccident"] = txtTimeofAccident.text
        parameters["accident_location"] = txtAccidentLocation.text
        parameters["referral_name"] = self.selectedReferral?.ref_id
        parameters["repairer_name"] = self.selectedRepairer?.rep_id
        parameters["description"] = self.txtViewAccidentDescription.text
        
        // Accident Desctiption
        
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
                                                   "currentIndex" : 3 ]
                        
                        NotificationCenter.default.post(name: .AccidentDetails, object: nil, userInfo: dict)
                    }
                }
            }
        }
        
    }
    
    func getReparierName() {
        CommonObject().showProgress()
        
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
                    
                    
                    if let data = self.accidentDetails {
                        self.selectedRepairer = self.arrRepaired.first(where: { ($0.repairer_name ?? "") == data.repairer_name })
                        self.txtRepairerName.text = self.selectedRepairer?.repairer_name
                    }
                }
            }
        }
    }
    
    func getReferralName() {
        CommonObject().showProgress()
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.REFERRAL_LIST)!
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
            if let data = responseData?.convertData(ReferalResponse.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? ReferalResponse {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    
                    self.arrReferral = data.data?.response ?? []
                    
                    if let data = self.accidentDetails {
                        
                        self.selectedReferral = self.arrReferral.first(where: { ($0.referral_name ?? "") == data.referral_name })
                        self.txtReferralName.text = self.selectedReferral?.referral_name
                    }
                }
            }
        }
    }
    
    @objc func SearchListNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let selectedItem = userInfo["selectedItem"] as! String
            let selectedItemIndex = userInfo["selectedIndex"] as! Int
            CommonObject.sharedInstance.isDataChangedInCurrentTab = true
            switch userInfo["itemSelectedFromList"] as? String {
            case AppDropDownLists.REPAIRER:
                self.selectedRepairer = self.arrRepaired.first(where: { ($0.repairer_name ?? "") == selectedItem })
                self.txtRepairerName.text = self.selectedRepairer?.repairer_name
            case AppDropDownLists.REFERRAL:
                self.selectedReferral = self.arrReferral.first(where: { ($0.referral_name ?? "") == selectedItem })
                self.txtReferralName.text = self.selectedReferral?.referral_name
            default : print("")
            }
        }
    }
}
