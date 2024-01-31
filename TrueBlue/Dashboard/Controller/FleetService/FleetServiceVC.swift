//
//  FleetServiceVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 31/01/24.
//

import UIKit
import IQKeyboardManagerSwift
import DKImagePickerController

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
    
    var arrRego = [RegoListResponse]()
    var selectedRego: RegoListResponse?
    
    var arrRepaired = [RepairerListResponse]()
    var selectedRepairer: RepairerListResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtMakeModel.textColor = UIColor(named: "7D7D7D")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getRegoList()
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchListNotificationAction(_:)), name: .searchListNotAtFault, object: nil)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
            let selectedItemIndex = userInfo["selectedIndex"] as! Int
            CommonObject.sharedInstance.isDataChangedInCurrentTab = true
            switch userInfo["itemSelectedFromList"] as? String {
            case AppDropDownLists.REGO_NUMBER:
                self.selectedRego = self.arrRego.first(where: { ($0.registration_no ?? "") == selectedItem })
                self.txtRegoNo.text = self.selectedRego?.registration_no
                self.txtMakeModel.text = "\(self.selectedRego?.vehicle_make ?? "") / \(self.selectedRego?.vehicle_model ?? "")"
            case AppDropDownLists.REPAIRER:
                self.selectedRepairer = self.arrRepaired.first(where: { ($0.repairer_name ?? "") == selectedItem })
                self.txtRepairer.text = self.selectedRepairer?.repairer_name
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
    
}


extension FleetServiceVC {
    
    func getRegoList() {
        CommonObject().showProgress()
        
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
//                    if let data = self.serviceData {
//                        self.selectedRego = self.arrRego.first(where: { ($0.registration_no ?? "") == selectedItem })
//                        self.txtRegoNo.text = self.selectedRego?.registration_no
//                        self.txtMakeModel.text = "\(self.selectedRego?.vehicle_make ?? "") / \(self.selectedRego?.vehicle_model ?? "")"
//                    }
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
                        self.selectedRepairer = self.arrRepaired.first(where: { ($0.repairer_name ?? "") == data.repairer_name })
                        self.txtRepairer.text = self.selectedRepairer?.repairer_name
                    }
                }
            }
        }
    }
}
