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
    
    @IBOutlet weak var imgNewFront: UIImageView!
    @IBOutlet weak var imgNewLeft: UIImageView!
    @IBOutlet weak var imgNewBack: UIImageView!
    @IBOutlet weak var imgNewRight: UIImageView!
    
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
    
    @IBAction func btnOldVehicleFrontImage(_ sender: Any) {
        self.selectedImage = "old_front"
        self.imagePicker?.openPhotoOptions()
    }
    
    @IBAction func btnOldVehicleBackImage(_ sender: Any) {
        self.selectedImage = "old_back"
        self.imagePicker?.openPhotoOptions()
    }
    
    @IBAction func btnOldVehicleLeftImage(_ sender: Any) {
        self.selectedImage = "old_left"
        self.imagePicker?.openPhotoOptions()
    }
    
    @IBAction func btnOldVehicleRightImage(_ sender: Any) {
        self.selectedImage = "old_right"
        self.imagePicker?.openPhotoOptions()
    }
    
    @IBAction func btnNewVehicleFrontImage(_ sender: Any) {
        self.selectedImage = "new_front"
        self.imagePicker?.openPhotoOptions()
    }
    
    @IBAction func btnNewVehicleBackImage(_ sender: Any) {
        self.selectedImage = "new_back"
        self.imagePicker?.openPhotoOptions()
    }
    
    @IBAction func btnNewVehicleLeftImage(_ sender: Any) {
        self.selectedImage = "new_left"
        self.imagePicker?.openPhotoOptions()
    }
    
    @IBAction func btnNewVehicleRightImage(_ sender: Any) {
        self.selectedImage = "new_right"
        self.imagePicker?.openPhotoOptions()
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
        }
        self.present(ctrl, animated: false)
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
        self.swapedVehicle()
    }
    
    func setupUI() {
        apiPostRequest(parameters: [:], endPoint: EndPoints.HIRED_VEHICLE_DROPDOWN_LIST)
        apiPostSwapeVehicleRequest(parameters: [:], endPoint: EndPoints.AVAILABLE_VEHICLE_DROPDOWN_LIST)

        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchListNotificationAction(_:)), name: .searchListReturnVehicle, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchListNotificationAction(_:)), name: .searchListSwapVehicle, object: nil)

        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
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
    
    func apiPostMultipartRequest(parameters: Parameters,endPoint: String,image: [UIImage],isImg: Bool,isMultipleImg: Bool,imgParameter: [String],imgExtension: String){
        CommonObject.sharedInstance.showProgress()
        let obj = SwapVehicleViewModel()
        obj.delegate = self
        obj.postMultipartSwapVehicle(currentController: self, parameters: parameters, endPoint: endPoint, img: image, isImage: isImg, isMultipleImg: isMultipleImg, imgParameter: imgParameter, imgExtension: imgExtension)
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
                    
                    txtModelInfo.text = arrHiredVehicle[i].vehicle_make + " " + arrHiredVehicle[i].vehicle_model
                    
                    self.arrCarImages = arrHiredVehicle[i].fleet_docs
                    self.CarImageCollectionView.reloadData()
//                    let timeOut = arrHiredVehicle[i].time_out
//                    timeOutSegmentedControl.setUpAmPM(time: timeOut)
//                    timeOutTxtFld.text = timeOut.DatePresentable?.getDateAccoringTo(format: .Time12Hr) ?? ""
                }
            }
        }
    }
    
    func validation() {
        
        
        
    }
    
    func swapedVehicle() {
        if txtRefNo.text?.isEmpty ?? true {
            showToast(strMessage: selectOldRego)
            return
        }
        
        if txtMilageIn.text?.isEmpty ?? true {
            showToast(strMessage: "Please enter old milage in.")
            return
        }
        
        
        if txtDateIn.text?.isEmpty ?? true {
            showToast(strMessage: "Please enter old date in")
            return
        }
        
        
        if txtTimeIn.text?.isEmpty ?? true {
            showToast(strMessage: "Please enter old time in")
            return
        }
        
        if txtNewVehivleRefNo.text?.isEmpty ?? true {
            showToast(strMessage: selectNewRego)
            return
        }
        
        if txtNewMileageOut.text?.isEmpty ?? true {
            showToast(strMessage: "Please enter new milage out")
            return
        }
        
        if txtNewDateOut.text?.isEmpty ?? true {
            showToast(strMessage: "Please enter new date out")
            return
        }
        
        if txtNewTimeOut.text?.isEmpty ?? true {
            showToast(strMessage: "Please enter new time out")
            return
        }
        
//        if selectedVehicleId.isEmpty {
//            showToast(strMessage: selectNewRego)
//            return
//        }
//        if Int(txtMilageIn.text ?? "") ?? 0  < Int(txtMilageOut.text ?? "") ?? 0 {
//            showToast(strMessage: mileageInLessThanMileageOut)
//            return
//        }
        
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
        
        
//        parameters["front_img"] = self.imgOldFront.image
//        parameters["back_img"] = self.imgOldBack.image
//        parameters["left_img"] = self.imgOldLeft.image
//        parameters["right_img"] = self.imgOldRight.image
//
//        parameters["newfront_img"] = self.imgNewFront.image
//        parameters["newback_img"] = self.imgNewBack.image
//        parameters["newleft_img"] = self.imgNewLeft.image
//        parameters["newright_img"] = self.imgNewRight.image
        
        var images = [UIImage]()
        var imgParam = [String]()
        
        if let img = self.imgOldFront.image {
            images.append(img)
            imgParam.append("front_img")
        }
        if let img = self.imgOldBack.image {
            images.append(img)
            imgParam.append("back_img")
        }
        if let img = self.imgOldLeft.image {
            images.append(img)
            imgParam.append("left_img")
        }
        if let img = self.imgOldRight.image {
            images.append(img)
            imgParam.append("right_img")
        }
        if let img = self.imgNewFront.image {
            images.append(img)
            imgParam.append("newfront_img")
        }
        if let img = self.imgNewBack.image {
            images.append(img)
            imgParam.append("newback_img")
        }
        if let img = self.imgNewLeft.image {
            images.append(img)
            imgParam.append("newleft_img")
        }
        if let img = self.imgNewRight.image {
            images.append(img)
            imgParam.append("newright_img")
        }
        apiPostMultipartRequest(parameters: parameters, endPoint: EndPoints.SWAP_VEHICLE, image: images, isImg: images.count == 0 ? false : true, isMultipleImg: images.count == 0 ? false : true, imgParameter: imgParam, imgExtension: "png")
        
//        apiPostSwapeVehicleRequest(parameters: parameters, endPoint: EndPoints.SWAP_VEHICLE)
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
        return CGSize(width: (collectionView.frame.width - 18) / 4, height: (collectionView.frame.width - 18) / 4)
    }
    
}

extension NewSwapVehicleVC : ReturnVehicleVMDelegate {
    func returnVehicleAPISuccess(objData: ReturnUploadedDocsModel, strMessage: String) {
        arrReturnUploadedDocs = objData.documentDetails
//        CarImageCollectionView.reloadData()
    }


    func returnVehicleAPISuccess(objData: ReturnVehicleModel, strMessage: String) {
//        print(objData)
//        showToast(strMessage: strMessage)
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
//            self.dismiss(animated: true)
//        })
    }


    func returnVehicleAPISuccess(objData: HiredVehicleDropdownListModel, strMessage: String) {
        arrHiredVehicle = objData.arrResult
        setUpData()
        //print(arrHiredVehicle)
    }

    func returnVehicleAPIFailure(strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
    }
}

extension NewSwapVehicleVC: SwapVehicleVMDelegate {
    func swapVehicleAPISuccess(objData: ReturnUploadedDocsModel, strMessage: String) {
        print(objData.documentDetails)
        arrViewSwapVehicle = objData.documentDetails
//        viewSwapVehicleCollectionView.reloadData()
        
    }
    
    func swapVehicleAPISuccess(strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
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
        showToast(strMessage: strMessage)
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
            
        case "new_front":
            self.imgNewFront.image = image
        case "new_back":
            self.imgNewBack.image = image
        case "new_left":
            self.imgNewLeft.image = image
        case "new_right":
            self.imgNewRight.image = image
        default:
            print("")
        }
        self.selectedImage = ""
    }
}
