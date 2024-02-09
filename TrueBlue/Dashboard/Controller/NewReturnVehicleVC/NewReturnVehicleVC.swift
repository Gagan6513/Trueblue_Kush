//
//  NewReturnVehicleVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 06/02/24.
//

import UIKit
import DKImagePickerController
import SDWebImage
import Alamofire

class NewReturnVehicleVC: UIViewController {

    @IBOutlet weak var txtChooseRego: UITextField!
    @IBOutlet weak var txtClientName: UITextField!
    @IBOutlet weak var txtModelInfo: UITextField!
    @IBOutlet weak var txtMilageOut: UITextField!
    @IBOutlet weak var txtMilageIn: UITextField!
    @IBOutlet weak var txtMilageInError: UILabel!
    @IBOutlet weak var txtDateOut: UITextField!
    @IBOutlet weak var txtTimeOut: UITextField!
    @IBOutlet weak var txtDateIn: UITextField!
    @IBOutlet weak var txtTimeIn: UITextField!
    @IBOutlet weak var txtDateInError: UILabel!
    @IBOutlet weak var txtCollectedBy: UITextField!
    @IBOutlet weak var txtRepairerName: UITextField!
    
    @IBOutlet weak var btnYesRadio: UIButton!
    @IBOutlet weak var btnNoRadio: UIButton!
    
    @IBOutlet weak var txtLaibilityStatus: UITextField!
    @IBOutlet weak var txtSettlementDate: UITextField!
    
    @IBOutlet weak var txtOther: UITextField!
    
    @IBOutlet weak var imgPreviousFront: UIImageView!
    @IBOutlet weak var imgPreviousBack: UIImageView!
    @IBOutlet weak var imgPreviousLeft: UIImageView!
    @IBOutlet weak var imgPreviousRight: UIImageView!
    @IBOutlet weak var imgPreviousMeter: UIImageView!
    
    @IBOutlet weak var imgNewFront: UIImageView!
    @IBOutlet weak var imgNewBack: UIImageView!
    @IBOutlet weak var imgNewLeft: UIImageView!
    @IBOutlet weak var imgNewRight: UIImageView!
    @IBOutlet weak var imgNewMeter: UIImageView!
    
    var isYourVehicleTotalLoss = ""
    var isFromView = false
    var arrRego = [HiredDataList]()
    var selectedRego: HiredDataList?
    
    var arrCollectedBy = [CollectedDataList]()
    var selectedCollectedBy: CollectedDataList?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNotification()
        
        self.txtDateIn.delegate = self
        self.txtTimeIn.delegate = self
        self.txtDateOut.delegate = self
        self.txtSettlementDate.delegate = self
        self.txtMilageIn.delegate = self
        
        DispatchQueue.main.async {
            self.getRegoList()
        }
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.searchListNotificationAction(_:)), name: .searchListReturnVehicle, object: nil)

    }

    @IBAction func btnoldFront(_ sender: Any) {
        if let img = self.imgPreviousFront.image {
            self.setAllImages(currentImg: img, allImages: [img], currentIndex: 0)
        }
    }
    @IBAction func btnOldBack(_ sender: Any) {
        if let img = self.imgPreviousBack.image {
            self.setAllImages(currentImg: img, allImages: [img], currentIndex: 0)
        }
    }
    @IBAction func btnOldLeft(_ sender: Any) {
        if let img = self.imgPreviousLeft.image {
            self.setAllImages(currentImg: img, allImages: [img], currentIndex: 0)
        }
    }
    @IBAction func btnOldRight(_ sender: Any) {
        if let img = self.imgPreviousRight.image {
            self.setAllImages(currentImg: img, allImages: [img], currentIndex: 0)
        }
    }
    @IBAction func btnoldMeter(_ sender: Any) {
        if let img = self.imgPreviousMeter.image {
            self.setAllImages(currentImg: img, allImages: [img], currentIndex: 0)
        }
    }
    
    @IBAction func btnFront(_ sender: Any) {
        if let img = self.imgNewFront.image {
            self.showViewImageOption(currentImg: img, arrImage: [img], currentIndex: 0, imageView: self.imgNewFront)
        } else {
            self.openPicker(imgView: self.imgNewFront)
        }
    }
    
    @IBAction func btnBackImage(_ sender: Any) {
        if let img = self.imgNewBack.image {
            self.showViewImageOption(currentImg: img, arrImage: [img], currentIndex: 0, imageView: self.imgNewBack)
        } else {
            self.openPicker(imgView: self.imgNewBack)
        }
    }
    
    @IBAction func btnLeft(_ sender: Any) {
        if let img = self.imgNewLeft.image {
            self.showViewImageOption(currentImg: img, arrImage: [img], currentIndex: 0, imageView: self.imgNewLeft)
        } else {
            self.openPicker(imgView: self.imgNewLeft)
        }
    }
    
    @IBAction func btnRight(_ sender: Any) {
        if let img = self.imgNewRight.image {
            self.showViewImageOption(currentImg: img, arrImage: [img], currentIndex: 0, imageView: self.imgNewRight)
        } else {
            self.openPicker(imgView: self.imgNewRight)
        }
    }
    
    @IBAction func btnMeter(_ sender: Any) {
        if let img = self.imgNewMeter.image {
            self.showViewImageOption(currentImg: img, arrImage: [img], currentIndex: 0, imageView: self.imgNewMeter)
        } else {
            self.openPicker(imgView: self.imgNewMeter)
        }
    }
    
    @IBAction func btnDateOfSettlement(_ sender: Any) {
        self.selectDate(txt: self.txtSettlementDate)
    }
    
    
    @IBAction func btnRadioVBYes(_ sender: UIButton) {
        if !self.isFromView {
            self.setupVehicleTotalLossButton(str: "yes")
        }
    }
    @IBAction func btnRadioVBNo(_ sender: UIButton) {
        if !self.isFromView {
            self.setupVehicleTotalLossButton(str: "no")
        }
    }
    
    func setupVehicleTotalLossButton(str: String) {
        self.btnNoRadio.tintColor = str == "no" ? .systemGreen : UIColor(named: "D9D9D9")
        self.btnYesRadio.tintColor = str == "yes" ? .systemGreen : UIColor(named: "D9D9D9")
        self.isYourVehicleTotalLoss = str
    }
    
    @IBAction func btnCollectedBy(_ sender: Any) {
        if isFromView { return }
        if self.arrCollectedBy.count != 0 {
            showSearchListPopUp(listForSearch: self.arrCollectedBy.map({ $0.user_name ?? "" }), listNameForSearch: AppDropDownLists.COLLECTED_BY, notificationName: .searchListReturnVehicle)
        }
    }
    
    @IBAction func txtTimeInSelection(_ sender: Any) {
        self.selectTime(txt: self.txtTimeIn)
    }
    
    @IBAction func btnDateInSelection(_ sender: Any) {
        self.selectDate(txt: self.txtDateIn)
    }
    
    @IBAction func btnChooseRego(_ sender: Any) {
        if isFromView { return }
//        if self.arrRego.count != 0 {
//            showSearchListPopUp(listForSearch: self.arrRego.map({ $0.registration_no ?? "" }), listNameForSearch: AppDropDownLists.REGO_NUMBER, notificationName: .searchListReturnVehicle)
//        }
        
        if arrRego.count > 0 {
            var temp = [String] ()
            for i in 0...arrRego.count-1 {
                let refrenceRegoNumber = (arrRego[i].refno ?? "") + " - " + (arrRego[i].registration_no ?? "")
                temp.append(refrenceRegoNumber)
            }
            showSearchListPopUp(listForSearch: temp, listNameForSearch: AppDropDownLists.REGO_NUMBER, notificationName: .searchListReturnVehicle)
        }
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        if validation() {
            self.saveAndSubmit()
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func showViewImageOption(currentImg: UIImage, arrImage: [UIImage], currentIndex: Int, imageView: UIImageView) {
        let alert = UIAlertController(title: nil, message: "Please Select an Option", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "View Picture", style: .default , handler:{ (UIAlertAction)in
            self.setAllImages(currentImg: currentImg, allImages: arrImage, currentIndex: currentIndex)
        }))
        
        alert.addAction(UIAlertAction(title: "Change Picture", style: .default , handler:{ (UIAlertAction)in
            self.openPicker(imgView: imageView)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openPicker(imgView: UIImageView) {
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
                    imgView.image = img
                })
            }
        }
        self.present(multipleImgPickerController, animated: true) {}
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
            self.checkValidation()
        }
        self.present(ctrl, animated: false)
    }
    
    func selectTime(txt: UITextField) {
        if isFromView { return }
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
            txt.text = date
        }
        self.present(ctrl, animated: false)
    }
    
    @objc func searchListNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let selectedItem = userInfo["selectedItem"] as! String
            let selectedIndex = userInfo["selectedIndex"] as! Int
            switch userInfo["itemSelectedFromList"] as? String {
            case AppDropDownLists.REGO_NUMBER:
                self.selectedRego = self.arrRego[safe: selectedIndex]
                self.txtChooseRego.text = self.selectedRego?.registration_no
                self.txtClientName.text = self.selectedRego?.client_name
                self.txtMilageOut.text = self.selectedRego?.Mileage_out
                self.txtDateOut.text = self.selectedRego?.date_out
                self.txtTimeOut.text = self.selectedRego?.time_out
                self.txtModelInfo.text = "\(self.selectedRego?.vehicle_make ?? "") / \(self.selectedRego?.vehicle_model ?? "")"
                self.setOldVehicleImage()
            case AppDropDownLists.COLLECTED_BY:
                self.selectedCollectedBy = self.arrCollectedBy.first(where: { ($0.user_name ?? "") == selectedItem })
                self.txtCollectedBy.text = self.selectedCollectedBy?.user_name
            default : print("")
            }
        }
    }
    
    func setOldVehicleImage() {
        
        self.imgPreviousFront.image = nil
        self.imgPreviousBack.image = nil
        self.imgPreviousLeft.image = nil
        self.imgPreviousRight.image = nil
        self.imgPreviousMeter.image = nil
        
        if let url = URL(string: self.selectedRego?.fleet_docs?[safe: 0]?.image_url ?? "") {
            self.imgPreviousFront.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.imgPreviousFront.sd_setImage(with: url)
        }
        if let url = URL(string: self.selectedRego?.fleet_docs?[safe: 1]?.image_url ?? "") {
            self.imgPreviousBack.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.imgPreviousBack.sd_setImage(with: url)
        }
        if let url = URL(string: self.selectedRego?.fleet_docs?[safe: 2]?.image_url ?? "") {
            self.imgPreviousLeft.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.imgPreviousLeft.sd_setImage(with: url)
        }
        if let url = URL(string: self.selectedRego?.fleet_docs?[safe: 3]?.image_url ?? "") {
            self.imgPreviousRight.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.imgPreviousRight.sd_setImage(with: url)
        }
        if let url = URL(string: self.selectedRego?.fleet_docs?[safe: 4]?.image_url ?? "") {
            self.imgPreviousMeter.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.imgPreviousMeter.sd_setImage(with: url)
        }
    }
    
    func validation() -> Bool {
        
        if txtChooseRego.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please select rego number")
            return false
        }

        if txtModelInfo.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please enter model info")
            return false
        }

        if txtMilageIn.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please enter milage in")
            return false
        }
        
        let milageout = Int(self.txtMilageOut.text ?? "0") ?? 0
        let milagein = Int(self.txtMilageIn.text ?? "0") ?? 0
        
        if milageout > milagein {
            showAlert(title: "Error!", messsage: "Mileage in should be greater than mileage out")
            return false
        }
        
        if txtDateIn.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please select date in")
            return false
        }
        
        if txtDateOut.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please select time in")
            return false
        }
        
        if txtCollectedBy.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please select collected by")
            return false
        }
        
        if txtRepairerName.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please enter repairer name")
            return false
        }
        
        if self.isYourVehicleTotalLoss == "" {
            showAlert(title: "Error!", messsage: "Please select is your vehicle total loss")
            return false
        }
        
        if txtLaibilityStatus.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please enter laibility status")
            return false
        }
        
//        if txtSettlementDate.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: "Please select settlement date")
//            return false
//        }
        
//        if self.imgNewFront.image == nil {
//            showAlert(title: "Error!", messsage: "Please select front image")
//            return false
//        }
//
//        if self.imgNewBack.image == nil {
//            showAlert(title: "Error!", messsage: "Please select back image")
//            return false
//        }
//
//        if self.imgNewLeft.image == nil {
//            showAlert(title: "Error!", messsage: "Please select left image")
//            return false
//        }
//
//        if self.imgNewRight.image == nil {
//            showAlert(title: "Error!", messsage: "Please select right image")
//            return false
//        }
//
//        if self.imgNewMeter.image == nil {
//            showAlert(title: "Error!", messsage: "Please select odo meter image")
//            return false
//        }
        
        if (self.txtDateIn.text?.date(from: .ddmmyyyy) ?? Date()) > Date() {
            showAlert(title: "Error!", messsage: "Date in should not be greater than current date!")
            return false
        }
        
//        if (txtServiceDate.text?.date(from: .ddmmyyyy) ?? Date()) < (txtLastServiceDate.text?.date(from: .yyyymmdd) ?? Date()) {
//            showAlert(title: "Error!", messsage: "Current Service due needs to be greater than before")
//            return false
//        }
        
        return true
    }
    
}

extension NewReturnVehicleVC {
    
    func getRegoList() {
        CommonObject().showProgress()
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.hiredvehicleslist)!
        webService.method = .post
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
            if let data = responseData?.convertData(HiredData.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? HiredData {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    
                    self.arrRego = data.data?.response ?? []
                    
//                    if let rego = self.arrRego.first(where: { $0.registration_no?.lowercased() == self.regoNumber.lowercased() }) {
//                        self.selectedRego = rego
//                        self.txtRegoNo.text = self.selectedRego?.registration_no
//                        self.txtMakeModel.text = "\(self.selectedRego?.vehicle_make ?? "") / \(self.selectedRego?.vehicle_model ?? "")"
//                    }
                    
                    self.getCollectedBy()
                }
            }
        }
    }
    
    func getCollectedBy() {
//        CommonObject().showProgress()
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.delivered_collectedby)!
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
            if let data = responseData?.convertData(CollectedByData.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? CollectedByData {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    
                    self.arrCollectedBy = data.data?.response ?? []
                    
//                    if let rego = self.arrRego.first(where: { $0.registration_no?.lowercased() == self.regoNumber.lowercased() }) {
//                        self.selectedRego = rego
//                        self.txtRegoNo.text = self.selectedRego?.registration_no
//                        self.txtMakeModel.text = "\(self.selectedRego?.vehicle_make ?? "") / \(self.selectedRego?.vehicle_model ?? "")"
//                    }
                    
//                    self.getReparierName()
                }
            }
        }
    }
    
    func saveAndSubmit() {
        var parameters: Parameters = [:]
        parameters["app_id"] = self.selectedRego?.application_id
        parameters["application_id"] = self.selectedRego?.refno
        parameters["vehicle_id"] = self.selectedRego?.vehicle_id
        parameters["booking_id"] = self.selectedRego?.booking_id
        parameters["date_in"] = self.txtDateIn.text
        parameters["time_in"] = self.txtTimeIn.text
        parameters["mileage_in"] = self.txtMilageIn.text
        parameters["dateofsattlement"] = self.txtSettlementDate.text
        parameters["return_remarks"] = self.txtOther.text
        parameters["returned_repairer_name"] = self.txtRepairerName.text
        parameters["liability_status"] = self.txtLaibilityStatus.text
        parameters["collected_by_id"] = self.selectedCollectedBy?.id
        parameters["collected_by_name"] = self.selectedCollectedBy?.user_name
        
        parameters["user_id"] = UserDefaults.standard.userId()
        parameters["user_name"] = UserDefaults.standard.username()
        parameters["request_from"] = request_from
        
        CommonObject().showProgress()
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.returnVehicle)!
        webService.method = .post
        
        webService.parameters = parameters
        
        var profileImageData: [Dictionary<String, Any>] = []
//
        if let img = self.imgNewFront.image, let data = img.jpeg(.medium) {
            profileImageData.append(["title": "front_img", "image": data])
        }
        if let img = self.imgNewBack.image, let data = img.jpeg(.medium) {
            profileImageData.append(["title": "back_img", "image": data])
        }
        if let img = self.imgNewLeft.image, let data = img.jpeg(.medium) {
            profileImageData.append(["title": "left_img", "image": data])
        }
        if let img = self.imgNewRight.image, let data = img.jpeg(.medium) {
            profileImageData.append(["title": "right_img", "image": data])
        }
        if let img = self.imgNewMeter.image, let data = img.jpeg(.medium) {
            profileImageData.append(["title": "odometer_img", "image": data])
        }
        
        WebService.shared.performMultipartWebService(model: webService, imageData: profileImageData) { [weak self] responseData, error in
//        WebService.shared.performMultipartWebService(endPoint: API_URL.returnVehicle, isMultipleImage: false, parameters: parameters, imageData: profileImageData) { [weak self] responseData, error in

            guard let self else { return }
            
            CommonObject().stopProgress()
            
            if let error {
                /* API ERROR */
                showAlert(title: "Error!", messsage: "\(error)")
                return
            }
            
            /* CONVERT JSON DATA TO MODEL */
            if let data = responseData?.convertData(SuccessModel.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? SuccessModel {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    
                    NotificationCenter.default.post(name: .refreshFleetList, object: nil)
                    NotificationCenter.default.post(name: .AccidentDetails, object: nil)
                    
                    showAlertWithAction(title: alert_title, messsage: data.msg ?? "", isOkClicked: { [weak self] in
                        guard let self else { return }
                        self.dismiss(animated: true)
                    })
                    
                }
            }
        }
        
    }
}

extension NewReturnVehicleVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var isAllowed = true
        switch textField {
        case txtDateIn, txtDateOut:
            isAllowed = textField.validateDateTyped(shouldChangeCharactersInRange: range, replacementString: string)
            self.checkValidation()
        case txtTimeIn :
            isAllowed = textField.validateTimeTyped(shouldChangeCharactersInRange: range, replacementString: string)
        case txtMilageIn:
            if let text = textField.text, let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange, with: string)
                self.validationMiles(milageinStr: updatedText, milageOutStr: self.txtMilageOut.text ?? "0")
            }
        default:
            print("TextField without restriction")
        }
        return isAllowed
    }
    
    func validationMiles(milageinStr: String, milageOutStr: String) {
        self.txtMilageInError.isHidden = (milageinStr == "") || (milageOutStr == "")
        let milageout = Int(milageOutStr) ?? 0
        let milagein = Int(milageinStr) ?? 0
        let finalCount = milagein - milageout
        self.txtMilageInError.text = "Mileage Consumed: \(finalCount)"
        self.txtMilageInError.isHidden = finalCount < 0
    }
    
    func checkValidation() {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-MM-yyyy"
        dateFormater.timeZone = .current
        txtDateInError.isHidden = true
        if let dateOut = dateFormater.date(from: self.txtDateOut.text ?? "\(Date())") {
            if let dateIn = dateFormater.date(from: self.txtDateIn.text ?? "\(Date())") {
                let new = dateIn.offset(from: dateOut)
                print("Diff ", new)
                if new != "" {
                    txtDateInError.text = "Days Out: \(new)"
                    txtDateInError.isHidden = false
                    self.txtDateInError.isHidden = dateOut > dateIn
                }
            }
        }
    }
}
