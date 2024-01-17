//
//  SwapVehicleVC.swift
//  DesignExample
//
//  Created by Kushkumar Katira on 18/12/23.
//

import UIKit
import Applio
import Alamofire
import DKImagePickerController

class NewSwapVehicleVC: UIViewController {

    @IBOutlet weak var CarImageCollectionView: UICollectionView!
    
    @IBOutlet weak var dateInValidation: UILabel!
    @IBOutlet weak var milesInValidation: UILabel!
    
    @IBOutlet weak var txtRefNo: UITextField!
    @IBOutlet weak var txtClientName: UITextField!
    @IBOutlet weak var txtModelInfo: UITextField!
    @IBOutlet weak var txtMilageOut: UITextField!
    @IBOutlet weak var txtMilageIn: UITextField!
    
    @IBOutlet weak var txtDateOut: UITextField!
    @IBOutlet weak var txtTimeOut: UITextField!
    
    @IBOutlet weak var txtDateIn: UITextField!
    @IBOutlet weak var txtTimeIn: UITextField!
    
    @IBOutlet weak var txtReasonForReplacement: UITextView!
    
    @IBOutlet weak var newcarImage: UIImageView!
    @IBOutlet weak var txtNewVehivleRefNo: UITextField!
    @IBOutlet weak var txtNewModelInfo: UITextField!
    @IBOutlet weak var txtNewMileageOut: UITextField!
    @IBOutlet weak var txtNewDateOut: UITextField!
    @IBOutlet weak var txtNewTimeOut: UITextField!
    
    @IBOutlet weak var imgOldFront: UIImageView!
    @IBOutlet weak var imgOldBack: UIImageView!
    @IBOutlet weak var imgOldLeft: UIImageView!
    @IBOutlet weak var imgOldRight: UIImageView!
    @IBOutlet weak var imgOldMeter: UIImageView!
    
    @IBOutlet weak var imgNewFront: UIImageView!
    @IBOutlet weak var imgNewLeft: UIImageView!
    @IBOutlet weak var imgNewBack: UIImageView!
    @IBOutlet weak var imgNewRight: UIImageView!
    @IBOutlet weak var imgNewMeter: UIImageView!

    var applicationID = String()//We get this from Collections Screen
    var arrHiredVehicle = [HiredVehicleDropdownListModelData]()
    var arrReturnUploadedDocs = [DocumentDetailsModelData]()
    var arrCarImages = [fleet_docs]()
    var selectedDropdownItemIndex = -1 as Int
    
    var selectedOldVehicle = HiredVehicleDropdownListModelData()
    var selectedNewVehicle = AvailableVehicleDropDownListModelData()
    
    // NEW VEHICLE
    var arrViewSwapVehicle = [DocumentDetailsModelData]()
    var arrAvailableVehicles = [AvailableVehicleDropDownListModelData]()
    var selectedVehicleId = String()
    
    //Image Picker
    var imagePicker: ImagePicker?
    var multipleImgPicker: MultipleImgPicker!
    
    var selectedImage = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.setupUI()
    }
    
    func setupCollectionView() {
        self.CarImageCollectionView.delegate = self
        self.CarImageCollectionView.dataSource = self
        self.CarImageCollectionView.registerNib(for: "CarImageCVC")
    }
    
    // Upload Image ================
    
    func showViewImageOption(currentImg: UIImage, arrImage: [UIImage], currentIndex: Int) {
        let alert = UIAlertController(title: nil, message: "Please Select an Option", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "View Picture", style: .default , handler:{ (UIAlertAction)in
            self.setAllImages(currentImg: currentImg, allImages: arrImage, currentIndex: currentIndex)
        }))
        
        alert.addAction(UIAlertAction(title: "Retake Picture", style: .default , handler:{ (UIAlertAction)in
            self.selectImage()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func getOldImageArray(currentImage: UIImage) -> ([UIImage], Int) {
        
        var images = [UIImage]()
         
        if let img = self.imgOldFront.image {
            images.append(img)
        }
        if let img = self.imgOldBack.image {
            images.append(img)
        }
        if let img = self.imgOldLeft.image {
            images.append(img)
        }
        if let img = self.imgOldRight.image {
            images.append(img)
        }
        if let img = self.imgOldMeter.image {
            images.append(img)
        }
        
        let index = images.firstIndex(of: currentImage) ?? 0
        
        return (images, index)
    }
    
    func getNewImageArray(currentImage: UIImage) -> ([UIImage], Int) {
        var images = [UIImage]()

        if let img = self.imgNewFront.image {
            images.append(img)
        }
        if let img = self.imgNewBack.image {
            images.append(img)
        }
        if let img = self.imgNewLeft.image {
            images.append(img)
        }
        if let img = self.imgNewRight.image {
            images.append(img)
        }
        if let img = self.imgNewMeter.image {
            images.append(img)
        }

        let index = images.firstIndex(of: currentImage) ?? 0
        
        return (images, index)
    }
    
    @IBAction func btnOldVehicleFrontImage(_ sender: Any) {
        self.selectedImage = "old_front"
        
        if let img = self.imgOldFront.image {
            let images = self.getOldImageArray(currentImage: img)
            self.showViewImageOption(currentImg: img, arrImage: images.0, currentIndex: images.1)
        } else {
            self.selectImage()
        }
    }
    
    @IBAction func btnOldVehicleBackImage(_ sender: Any) {
        self.selectedImage = "old_back"

        if let img = self.imgOldBack.image {
            let images = self.getOldImageArray(currentImage: img)
            self.showViewImageOption(currentImg: img, arrImage: images.0, currentIndex: images.1)
        } else {
            self.selectImage()
        }
        
    }
    
    @IBAction func btnOldVehicleLeftImage(_ sender: Any) {
        self.selectedImage = "old_left"

        if let img = self.imgOldLeft.image {
            let images = self.getOldImageArray(currentImage: img)
            self.showViewImageOption(currentImg: img, arrImage: images.0, currentIndex: images.1)
        } else {
            self.selectImage()
        }
    }
    
    @IBAction func btnOldVehicleRightImage(_ sender: Any) {
        self.selectedImage = "old_right"

        if let img = self.imgOldRight.image {
            let images = self.getOldImageArray(currentImage: img)
            self.showViewImageOption(currentImg: img, arrImage: images.0, currentIndex: images.1)
        } else {
            self.selectImage()
        }
    }
    @IBAction func btnOldVehicleMeterImage(_ sender: Any) {
        self.selectedImage = "odometer_img"

        if let img = self.imgOldMeter.image {
            let images = self.getOldImageArray(currentImage: img)
            self.showViewImageOption(currentImg: img, arrImage: images.0, currentIndex: images.1)
        } else {
            self.selectImage()
        }
    }
    
    @IBAction func btnNewVehicleFrontImage(_ sender: Any) {
        self.selectedImage = "new_front"
        if let img = self.imgNewFront.image {
            let images = self.getNewImageArray(currentImage: img)
            self.showViewImageOption(currentImg: img, arrImage: images.0, currentIndex: images.1)
        } else {
            self.selectImage()
        }
    }
    
    @IBAction func btnNewVehicleBackImage(_ sender: Any) {
        self.selectedImage = "new_back"
        if let img = self.imgNewBack.image {
            let images = self.getNewImageArray(currentImage: img)
            self.showViewImageOption(currentImg: img, arrImage: images.0, currentIndex: images.1)
        } else {
            self.selectImage()
        }
    }
    
    @IBAction func btnNewVehicleLeftImage(_ sender: Any) {
        self.selectedImage = "new_left"
        if let img = self.imgNewLeft.image {
            let images = self.getNewImageArray(currentImage: img)
            self.showViewImageOption(currentImg: img, arrImage: images.0, currentIndex: images.1)
        } else {
            self.selectImage()
        }
    }
    
    @IBAction func btnNewVehicleRightImage(_ sender: Any) {
        self.selectedImage = "new_right"
        if let img = self.imgNewRight.image {
            let images = self.getNewImageArray(currentImage: img)
            self.showViewImageOption(currentImg: img, arrImage: images.0, currentIndex: images.1)
        } else {
            self.selectImage()
        }
    }
    
    @IBAction func btnNewVehicleMeterImage(_ sender: Any) {
        self.selectedImage = "newodometer_img"
        if let img = self.imgNewMeter.image {
            let images = self.getNewImageArray(currentImage: img)
            self.showViewImageOption(currentImg: img, arrImage: images.0, currentIndex: images.1)
        } else {
            self.selectImage()
        }
    }
    
    // =============================
    
    @IBAction func btnChooseRefNo(_ sender: Any) {
        if applicationID.isEmpty {
            //User comes from dashboard
            if arrHiredVehicle.count > 0 {
                var temp = [String] ()
                for i in 0...arrHiredVehicle.count-1 {
                    
                    if arrHiredVehicle[i].registration_no != "" {
                        temp.append(arrHiredVehicle[i].refno.appendingFormat(" - %@", arrHiredVehicle[i].registration_no))
                    }else {
                        temp.append(arrHiredVehicle[i].refno)
                    }
                }
                showSearchListPopUp(listForSearch: temp, listNameForSearch: AppDropDownLists.RETURN_VEHICLE_REGO, notificationName: .searchListReturnVehicle)
            } else {
                showToast(strMessage: noRecordAvailable)
            }
        }
    }
    
    @IBAction func btnChooseNewRefNo(_ sender: Any) {
        if arrAvailableVehicles.count > 0 {
            var temp = [String] ()
            for i in 0...arrAvailableVehicles.count-1 {
                temp.append(arrAvailableVehicles[i].registration_no)
            }
            print(arrAvailableVehicles)
            showSearchListPopUp(listForSearch: temp, listNameForSearch: AppDropDownLists.AVAILABLE_VEHICLE_REGO_RA, notificationName: .searchListSwapVehicle)
        }else {
            showToast(strMessage: noRecordAvailable)
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnOldVehicleDateOut(_ sender: Any) {
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
            self.txtDateOut.text = date
        }
        self.present(ctrl, animated: false)
    }
    
    @IBAction func btnOldVehicleTimeOut(_ sender: Any) {
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
            self.txtTimeOut.text = date
        }
        self.present(ctrl, animated: false)
    }
    
    @IBAction func btnOldVehicleDateIn(_ sender: Any) {
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
            self.txtDateIn.text = date
            self.checkValidation()
        }
        self.present(ctrl, animated: false)
    }
    
    func checkValidation() {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-MM-yyyy"
        dateFormater.timeZone = .current
        dateInValidation.isHidden = true
        if let dateOut = dateFormater.date(from: self.txtDateOut.text ?? "\(Date())") {
            if let dateIn = dateFormater.date(from: self.txtDateIn.text ?? "\(Date())") {
                let new = dateIn.offset(from: dateOut)
                print("Diff ", new)
                if new != "" {
                    dateInValidation.text = "Days Out: \(new)"
                    dateInValidation.isHidden = false
                    self.dateInValidation.isHidden = dateOut > dateIn
                }
            }
        }
    }
    
    @IBAction func btnOldVehicleTimeIn(_ sender: Any) {
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
            self.txtTimeIn.text = date
        }
        self.present(ctrl, animated: false)
    }
    
    @IBAction func btnNewVehicleDateOut(_ sender: Any) {
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
            self.txtNewDateOut.text = date
        }
        self.present(ctrl, animated: false)
    }
    
    @IBAction func btnNewVehicleTimeOut(_ sender: Any) {
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
            self.txtNewTimeOut.text = date
        }
        self.present(ctrl, animated: false)
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        if self.validationTextfield() {
            self.swapedVehicle()
        }
    }
    
    func setupUI() {
        
        self.txtDateIn.delegate = self
        self.txtTimeIn.delegate = self
        self.txtNewDateOut.delegate = self
        self.txtNewTimeOut.delegate = self
        
        
        apiPostRequest(parameters: [:], endPoint: EndPoints.HIRED_VEHICLE_DROPDOWN_LIST)
        apiPostSwapeVehicleRequest(parameters: [:], endPoint: EndPoints.AVAILABLE_VEHICLE_DROPDOWN_LIST)

        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchListNotificationAction(_:)), name: .searchListReturnVehicle, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchListNotificationAction(_:)), name: .searchListSwapVehicle, object: nil)

        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        multipleImgPicker = MultipleImgPicker(presentationController: self,delegate: self)
        
        self.txtMilageIn.delegate = self
    }
    
    @objc func SearchListNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let selectedItem = userInfo["selectedItem"] as? String {
                
                selectedDropdownItemIndex = userInfo["selectedIndex"] as! Int
                print(selectedDropdownItemIndex)
                
                switch userInfo["itemSelectedFromList"] as? String {
                case AppDropDownLists.RETURN_VEHICLE_REGO:
                    self.selectedOldVehicle = arrHiredVehicle[selectedDropdownItemIndex]
                    txtRefNo.text = selectedItem
                    txtMilageOut.text = arrHiredVehicle[selectedDropdownItemIndex].Mileage_out
                    txtDateOut.text = arrHiredVehicle[selectedDropdownItemIndex].date_out
                    
                    txtClientName.text = arrHiredVehicle[selectedDropdownItemIndex].client_name
                    
                    print(arrHiredVehicle[selectedDropdownItemIndex])
                    
                    let time = arrHiredVehicle[selectedDropdownItemIndex].time_out
                    print("--------------Time------------", time)
                    let timeFormater = DateFormatter()
                    timeFormater.dateFormat = "HH:mm:ss"
                    
                    let newTime = timeFormater.date(from: time)
                    timeFormater.dateFormat = "HH:mm"
                    self.txtTimeOut.text = timeFormater.string(from: newTime ?? Date())
                    
                    txtModelInfo.text = arrHiredVehicle[selectedDropdownItemIndex].vehicle_make + " " + arrHiredVehicle[selectedDropdownItemIndex].vehicle_model
                    
                    self.arrCarImages = arrHiredVehicle[selectedDropdownItemIndex].fleet_docs
                    self.CarImageCollectionView.reloadData()
                    
                    let parameters : Parameters = ["application_id" :arrHiredVehicle[selectedDropdownItemIndex].refno ]
                    apiPostRequest(parameters: parameters, endPoint: EndPoints.RETURNUPLOADED_DOCS)
                    
                    self.checkValidation()
                    self.validationMiles(milageinStr: self.txtMilageIn.text ?? "0", milageOutStr: self.txtMilageOut.text ?? "0")
                    
                case AppDropDownLists.AVAILABLE_VEHICLE_REGO_RA:

                    self.selectedNewVehicle = arrAvailableVehicles[selectedDropdownItemIndex]
                    selectedVehicleId = arrAvailableVehicles[selectedDropdownItemIndex].id
                    self.txtNewVehivleRefNo.text = selectedItem
                    self.txtNewModelInfo.text = arrAvailableVehicles[selectedDropdownItemIndex].vehicle_make + " " + arrAvailableVehicles[selectedDropdownItemIndex].vehicle_model
                    
                    self.newcarImage.sd_setImage(with: URL(string: arrAvailableVehicles[selectedDropdownItemIndex].fleet_img))
                default:
                    print("Unkown List")
                }
            }
        }
    }
    
    func apiPostRequest(parameters: Parameters,endPoint: String){
        CommonObject.sharedInstance.showProgress()
        let obj = ReturnVehicleViewModel()
        obj.delegate = self
        obj.postReturnVehicle(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    
    func apiPostSwapeVehicleRequest(parameters: Parameters,endPoint: String){
        CommonObject.sharedInstance.showProgress()
        let obj = SwapVehicleViewModel()
        obj.delegate = self
        obj.postSwapVehicle(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    
    func apiPostMultipartRequest(parameters: Parameters, endPoint: String, imageData: [Dictionary<String, Any>]){
        CommonObject.sharedInstance.showProgress()
        let obj = SwapVehicleViewModel()
        obj.delegate = self
        obj.postMultipartSwapVehicle(currentController: self, parameters: parameters, endPoint: endPoint, imageData: imageData)
    }
    
    func setUpData() {
        if !applicationID.isEmpty {
            // User comes from collection screen
            for i in 0...arrHiredVehicle.count-1 {
                if applicationID == arrHiredVehicle[i].refno {
                    txtRefNo.text = arrHiredVehicle[i].refno + "-" + arrHiredVehicle[i].registration_no
                    txtMilageOut.text = arrHiredVehicle[i].Mileage_out
                    txtDateOut.text = arrHiredVehicle[i].date_out
                    txtTimeOut.text = arrHiredVehicle[i].time_out
                    txtClientName.text = arrHiredVehicle[i].client_name
                    
                    txtModelInfo.text = arrHiredVehicle[i].vehicle_make + " " + arrHiredVehicle[i].vehicle_model
                    
                    self.arrCarImages = arrHiredVehicle[i].fleet_docs
                    self.CarImageCollectionView.reloadData()
                }
            }
        }
    }
    
    func validationTextfield() -> Bool {
        
        if txtRefNo.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: selectOldRego)
            return false
        }
        
        if txtMilageIn.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please enter old milage in.")
            return false
        }
        
        if txtDateIn.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please enter old date in")
            return false
        }
        
        if txtTimeIn.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please enter old time in")
            return false
        }
        
        let milageout = Int(self.txtMilageOut.text ?? "0") ?? 0
        let milagein = Int(self.txtMilageIn.text ?? "0") ?? 0
        
        if milageout > milagein {
            showAlert(title: "Error!", messsage: "Mileage in should be greater than mileage out")
            
            return false
        }
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-MM-yyyy"
        
        if let dateOut = dateFormater.date(from: self.txtDateOut.text ?? "\(Date())") {
            if let dateIn = dateFormater.date(from: self.txtDateIn.text ?? "\(Date())") {
                if dateOut > dateIn {
                    showAlert(title: "Error!", messsage: "Date In should be greater than date out")
                    return false
                }
            }
        }
        
        
        if txtNewVehivleRefNo.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: selectNewRego)
            return false
        }
        
        if txtNewMileageOut.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please enter new milage out")
            return false
        }
        
        if txtNewDateOut.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please enter new date out")
            return false
        }
        
        if txtNewTimeOut.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please enter new time out")
            return false
        }
        
        return true
    }
    
    func swapedVehicle() {
        
        var parameters: Parameters = [:]
        parameters["reasonfor_replacement"] = self.txtReasonForReplacement.text
        parameters["app_id"] = self.selectedOldVehicle.application_id
        parameters["booking_id"] = self.selectedOldVehicle.booking_id
        parameters["oldvehicle_id"] = self.selectedOldVehicle.vehicle_id
        
        parameters["vehicle_id"] = self.selectedNewVehicle.id // NEW VEHICLE
        parameters["olddate_in"] = self.txtDateIn.text
        parameters["time_in"] = self.txtTimeIn.text
        
        parameters["dateof_replacement"] = self.txtNewDateOut.text // NEW VEHICLE
        parameters["timeof_replacement"] = self.txtNewTimeOut.text // NEW VEHICLE
        
        parameters["mileage_in"] = self.txtMilageIn.text

        parameters["user_id"] = UserDefaults.standard.userId() // USER INFO
        parameters["user_name"] = UserDefaults.standard.username() // USER INFO

        parameters["request_from"] = request_from
        
        parameters["mileage_out"] = self.txtNewMileageOut.text // NEW VEHICLE
        
        var profileImageData: [Dictionary<String, Any>] = []
        
        if let img = self.imgOldFront.image, let data = img.jpeg(.medium) {
            #if DEBUG
            
            debugLog("actual size front_img = \(img.getSizeIn(.megabyte)) MB")
            debugLog("after compression size front_img = \(data.getSizeIn(.megabyte)) MB")

            #endif
            profileImageData.append(["title": "front_img", "image": data])
        }
        if let img = self.imgOldBack.image, let data = img.jpeg(.medium) {
            #if DEBUG
            
            debugLog("actual size back_img = \(img.getSizeIn(.megabyte)) MB")
            debugLog("after compression size back_img = \(data.getSizeIn(.megabyte)) MB")
            
            #endif
            profileImageData.append(["title": "back_img", "image": data])
        }
        if let img = self.imgOldLeft.image, let data = img.jpeg(.medium) {
            #if DEBUG
            
            debugLog("actual size left_img = \(img.getSizeIn(.megabyte)) MB")
            debugLog("after compression size left_img = \(data.getSizeIn(.megabyte)) MB")
            
            #endif
            profileImageData.append(["title": "left_img", "image": data])
        }
        if let img = self.imgOldRight.image, let data = img.jpeg(.medium) {
            #if DEBUG
            
            debugLog("actual size right_img = \(img.getSizeIn(.megabyte)) MB")
            debugLog("after compression size right_img = \(data.getSizeIn(.megabyte)) MB")
            
            #endif
            profileImageData.append(["title": "right_img", "image": data])
        }
        if let img = self.imgOldMeter.image, let data = img.jpeg(.medium) {
            #if DEBUG
            
            debugLog("actual size odometer_img = \(img.getSizeIn(.megabyte)) MB")
            debugLog("after compression size odometer_img = \(data.getSizeIn(.megabyte)) MB")
            
            #endif
            profileImageData.append(["title": "odometer_img", "image": data])
        }
        if let img = self.imgNewFront.image, let data = img.jpeg(.medium) {
            #if DEBUG
            
            debugLog("actual size newfront_img = \(img.getSizeIn(.megabyte)) MB")
            debugLog("after compression size newfront_img = \(data.getSizeIn(.megabyte)) MB")
            
            #endif
            profileImageData.append(["title": "newfront_img", "image": data])
        }
        if let img = self.imgNewBack.image, let data = img.jpeg(.medium) {
            #if DEBUG
            
            debugLog("actual size newback_img = \(img.getSizeIn(.megabyte)) MB")
            debugLog("after compression size newback_img = \(data.getSizeIn(.megabyte)) MB")
            
            #endif
            profileImageData.append(["title": "newback_img", "image": data])
        }
        if let img = self.imgNewLeft.image, let data = img.jpeg(.medium) {
            #if DEBUG
            
            debugLog("actual size newleft_img = \(img.getSizeIn(.megabyte)) MB")
            debugLog("after compression size newleft_img = \(data.getSizeIn(.megabyte)) MB")
            
            #endif
            profileImageData.append(["title": "newleft_img", "image": data])
        }
        if let img = self.imgNewRight.image, let data = img.jpeg(.medium) {
            #if DEBUG
            
            debugLog("actual size newright_img = \(img.getSizeIn(.megabyte)) MB")
            debugLog("after compression size newright_img = \(data.getSizeIn(.megabyte)) MB")
            
            #endif
            profileImageData.append(["title": "newright_img", "image": data])
        }
        if let img = self.imgNewMeter.image, let data = img.jpeg(.medium) {
            #if DEBUG
            
            debugLog("actual size newodometer_img = \(img.getSizeIn(.megabyte)) MB")
            debugLog("after compression size newodometer_img = \(data.getSizeIn(.megabyte)) MB")
            
            #endif
            profileImageData.append(["title": "newodometer_img", "image": data])
        }
        
//        apiPostMultipartRequest(parameters: parameters, endPoint: API_URL.SWAP_VEHICLE, imageData: profileImageData)
        
    }
    
}

extension NewSwapVehicleVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var isAllowed = true
        switch textField {
        case txtDateIn, txtNewDateOut:
            isAllowed = textField.validateDateTyped(shouldChangeCharactersInRange: range, replacementString: string)
            self.checkValidation()
        case txtTimeIn, txtNewTimeOut :
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
        self.milesInValidation.isHidden = (milageinStr == "") || (milageOutStr == "")
        let milageout = Int(milageOutStr) ?? 0
        let milagein = Int(milageinStr) ?? 0
        let finalCount = milagein - milageout
        self.milesInValidation.text = "Mileage Consumed: \(finalCount)"
        self.milesInValidation.isHidden = finalCount < 0
    }
}

extension NewSwapVehicleVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrCarImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarImageCVC", for: indexPath) as? CarImageCVC else { return UICollectionViewCell() }
        cell.carImages.sd_setImage(with: URL(string: self.arrCarImages[indexPath.row].image_url ?? ""))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var tempArray = [String]()
        for item in self.arrCarImages {
            tempArray.append(item.image_url ?? "")
        }
        setAllImages(currentImg: self.arrCarImages[indexPath.row].image_url ?? "", allImages: tempArray, currentIndex: indexPath.row)
    }
    
}

extension NewSwapVehicleVC : ReturnVehicleVMDelegate {
    func returnVehicleAPISuccess(objData: ReturnUploadedDocsModel, strMessage: String) {
        arrReturnUploadedDocs = objData.documentDetails
//        CarImageCollectionView.reloadData()
    }


    func returnVehicleAPISuccess(objData: ReturnVehicleModel, strMessage: String) {

    }

    func returnVehicleAPISuccess(objData: HiredVehicleDropdownListModel, strMessage: String) {
        arrHiredVehicle = objData.arrResult
        setUpData()
        //print(arrHiredVehicle)
    }

    func returnVehicleAPIFailure(strMessage: String, serviceKey: String) {
        showGlobelAlert(title: "Error!", msg: strMessage)
    }
}

extension NewSwapVehicleVC: SwapVehicleVMDelegate {
    func swapVehicleAPISuccess(objData: ReturnUploadedDocsModel, strMessage: String) {
        print(objData.documentDetails)
        arrViewSwapVehicle = objData.documentDetails
//        viewSwapVehicleCollectionView.reloadData()
    }
    
    func swapVehicleAPISuccess(strMessage: String, serviceKey: String) {
//        showToast(strMessage: strMessage)
        showGlobelAlert(title: alert_title, msg: strMessage, doneAction: {_ in
            self.dismiss(animated: true)
        })
    }
    
    func swapVehicleAPISuccess(objData: HiredVehicleDropdownListModel, strMessage: String) {
//        arrHiredVehicles = objData.arrResult
        if objData.arrResult.count > 0 {
            var temp = [String] ()
            for i in 0...objData.arrResult.count-1 {
                let refrenceRegoNumber = objData.arrResult[i].refno + "-" + objData.arrResult[i].registration_no
                temp.append(refrenceRegoNumber)
            }
            showSearchListPopUp(listForSearch: temp, listNameForSearch: AppDropDownLists.HIRED_VEHICLE_REGO_RA, notificationName: .searchListSwapVehicle)
        }
    }
    
    func swapVehicleAPISuccess(objData: AvailableVehicleDropDownListModel, strMessage: String) {
//        showToast(strMessage: strMessage)
        if objData.arrResult.count > 0 {
            arrAvailableVehicles = objData.arrResult
            print(objData)
//            var temp = [String] ()
//            for i in 0...objData.arrResult.count-1 {
//                temp.append(objData.arrResult[i].registration_no)
//            }
//            print(arrAvailableVehicles)
//            showSearchListPopUp(listForSearch: temp, listNameForSearch: AppDropDownLists.AVAILABLE_VEHICLE_REGO_RA, notificationName: .searchListSwapVehicle)
        }
    }
    
    func swapVehicleAPIFailure(strMessage: String, serviceKey: String) {
        showGlobelAlert(title: "Error!", msg: strMessage)
    }
}

extension NewSwapVehicleVC: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        switch self.selectedImage {
        case "old_front":
            self.imgOldFront.image = image
        case "old_back":
            self.imgOldBack.image = image
        case "old_left":
            self.imgOldLeft.image = image
        case "old_right":
            self.imgOldRight.image = image
        case "odometer_img":
            self.imgOldMeter.image = image
            
        case "new_front":
            self.imgNewFront.image = image
        case "new_back":
            self.imgNewBack.image = image
        case "new_left":
            self.imgNewLeft.image = image
        case "new_right":
            self.imgNewRight.image = image
        case "newodometer_img":
            self.imgNewMeter.image = image
            
        default:
            print("")
        }
        
        if let img = image, let data = img.jpeg(.medium) {
            #if DEBUG
            // .resizeImage(image: img, newWidth: 2360, newHeight: 2360)
            debugLog("actual size front_img = \(img.getSizeIn(.megabyte)) MB")
            debugLog("after compression size front_img = \(data.getSizeIn(.megabyte)) MB")
            
            if let imageSizeInfo = img.getImageSizeInfo() {
                print("Image size: \(imageSizeInfo.sizeInMB) MB")
                print("Image width: \(imageSizeInfo.width) pixels")
                print("Image height: \(imageSizeInfo.height) pixels")
            } else {
                print("Failed to get image size info")
            }

            #endif
        }
        
        self.selectedImage = ""
    }
}

extension NewSwapVehicleVC {
    
    func selectImage() {

//        self.imagePicker?.openPhotoOptions()

        let multipleImgPickerController = DKImagePickerController()
        multipleImgPickerController.maxSelectableCount = 1
        multipleImgPickerController.modalPresentationStyle = .fullScreen
        multipleImgPickerController.assetType = .allPhotos
        multipleImgPickerController.showsCancelButton = true
        multipleImgPickerController.UIDelegate = CustomUIDelegate()
        multipleImgPickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets)

            for asset in assets {
                asset.fetchOriginalImage(completeBlock: {image,info in
                    //Gettimg images selected
                    self.didSelect(image: image)
                })
            }
        }
        self.present(multipleImgPickerController, animated: true) {}
        
    }
}

extension NewSwapVehicleVC: MultipleImagePickerDelegate {
    func didSelect(images: [UIImage], imgExtension: String) {
        print(images.count)
    }
      
}
