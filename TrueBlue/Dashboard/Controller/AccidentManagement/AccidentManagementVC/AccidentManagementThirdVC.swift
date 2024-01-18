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
    
    var arrRepaired = [RepairerListResponse]()
    var selectedRepairer: RepairerListResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtDateofAccident.delegate = self
        self.txtTimeofAccident.delegate = self
        self.getReferralName()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchListNotificationAction(_:)), name: .searchListNotAtFault, object: nil)

    }
    
    func validationTextfield() -> Bool {
        
        if txtDateofAccident.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: dateofAccident)
            return false
        }
        
        if txtTimeofAccident.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: timeofAccident)
            return false
        }
        
        if txtAccidentLocation.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: accidentLocation)
            return false
        }
        
        if txtReferralName.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: referralName)
            return false
        }
        
        if txtRepairerName.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: referralName)
            return false
        }
        
        if txtViewAccidentDescription.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: viewAccidentDescription)
            return false
        }
        
        return true
    }
    
    @IBAction func btnSaveContinue(_ sender: UIButton) {
        if validationTextfield() {
            saveAndSubmit()
        }
    }
    
    @IBAction func btnDateOfAccident(_ sender: Any) {
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
    
    @IBAction func btnTimeOfAccident(_ sender: Any) {
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
    
    @IBAction func btnReferralName(_ sender: Any) {
        self.openRepairerList()
    }
    
    func openRepairerList() {
        showSearchListPopUp(listForSearch: self.arrRepaired.map({ $0.repairer_name ?? "" }), listNameForSearch: AppDropDownLists.REPAIRER,notificationName: .searchListNotAtFault)
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
        parameters["dateofAccident"] = txtDateofAccident.text
        parameters["timeofaccident"] = txtTimeofAccident.text
        parameters["accidentLocation"] = txtAccidentLocation.text
        parameters["referral_name"] = txtReferralName.text
        
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
    
    func getReferralName() {
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
                self.txtReferralName.text = self.selectedRepairer?.repairer_name
            default : print("")
            }
        }
    }
}
