//
//  SwapVehicleVC.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 18/08/21.
//

import UIKit
import Alamofire
import DKImagePickerController
class SwapVehicleVC: UIViewController {
    
    @IBOutlet weak var viewSwapVehicleCollectionView: UICollectionView!
    @IBOutlet weak var pictureCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    @IBOutlet weak var raRegoLbl: UILabel!
    @IBOutlet weak var mileageOutOldTxtFld: UITextField!
    @IBOutlet weak var dateOutTxtFld: UITextField!
    @IBOutlet weak var timeOutTxtFld: UITextField!
    @IBOutlet weak var timeOutSegmentedControl: UISegmentedControl!
    @IBOutlet weak var newRaRegoLbl: UILabel!
    @IBOutlet weak var mileageOutNewTxtFld: UITextField!
    @IBOutlet weak var dateInTxtFld: UITextField!
    
    @IBOutlet weak var mileageInTxtFld: UITextField!
    
    @IBOutlet weak var timeInTxtFld: UITextField!
    @IBOutlet weak var timeInSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var dateOfReplacementTxtFld: UITextField!
    @IBOutlet weak var timeOfReplacementTxtFld: UITextField!
    @IBOutlet weak var timeOfReplacementSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var numberOfDaysTxtFld: UITextField!
    //    var listNameForSelection = String()
    var arrHiredVehicles = [HiredVehicleDropdownListModelData]()
    var arrAvailableVehicles = [AvailableVehicleDropDownListModelData]()
    var selectedAppId = String()
    var selectedOldvehicleId = String()
    var selectedVehicleId = String()
    var picturesCVInitialHeight = CGFloat()
    var isAddMorePicturesCell = false
    var picturesForUpload = [UIImage]()
    var arrViewSwapVehicle = [DocumentDetailsModelData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchListNotificationAction(_:)), name: .searchListSwapVehicle, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DateNotificationAction(_:)), name: .dateSwapVehicle, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.TimeNotificationAction(_:)), name: .timeSwapVehicle, object: nil)
        setViews()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpPicturesCV()
    }
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        NotificationCenter.default.removeObserver(self)//Removes all notifications being observed
    //    }
    
    func apiPostRequest(parameters: Parameters,endPoint: String){
        CommonObject.sharedInstance.showProgress()
        let obj = SwapVehicleViewModel()
        obj.delegate = self
        obj.postSwapVehicle(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    func apiGetRequest(parameters: Parameters?,endPoint: String) {
        CommonObject.sharedInstance.showProgress()
        let obj = SwapVehicleViewModel()
        obj.delegate = self
        obj.getSwapVehicle(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    
    func setViews() {
        dateOutTxtFld.keyboardType = .numberPad
        dateInTxtFld.keyboardType = .numberPad
        dateOfReplacementTxtFld.keyboardType = .numberPad
        timeInTxtFld.keyboardType = .numberPad
        timeOfReplacementTxtFld.keyboardType = .numberPad
        timeInSegmentedControl.setUpAmPmSegmentedControl()
        timeOfReplacementSegmentedControl.setUpAmPmSegmentedControl()
        timeOutSegmentedControl.setUpAmPmSegmentedControl()
        timeOutSegmentedControl.isUserInteractionEnabled = false
    }
    func setUpPicturesCV() {
        var height = CGFloat()
        if UIDevice.current.userInterfaceIdiom == .pad {
            height = (pictureCollectionView.frame.width-(4*20))/5
        } else {
            height = (pictureCollectionView.frame.width-(3*4))/4
        }
        picturesCVInitialHeight = height
        print(height)
        print(pictureCollectionView.frame)
        pictureCollectionViewHeight.constant = height
        
        let minInRow = (UIDevice.current.userInterfaceIdiom == .pad) ? 5:4
        
        var noOfCells = isAddMorePicturesCell ? picturesForUpload.count+1: picturesForUpload.count
        var noOfRows = 0
        if noOfCells % minInRow == 0 {
            noOfRows = noOfCells/minInRow
        } else {
            noOfRows = Int(noOfCells/minInRow) + 1
        }
        if picturesForUpload.count > minInRow-1 {
            if self.picturesForUpload.count > minInRow-1 {
                //Vertical space
                let vs = (UIDevice.current.userInterfaceIdiom == .pad) ? 20:4
                self.pictureCollectionViewHeight.constant = (self.picturesCVInitialHeight * CGFloat(noOfRows)) + CGFloat((noOfRows-1) * vs)

            } else {
                self.pictureCollectionViewHeight.constant = self.picturesCVInitialHeight
            }
////            self.view.layoutSubviews()
////            self.picturesCollectionView.superview?.layoutSubviews()
        }
//        picturesCollectionView.layoutIfNeeded()
//        picturesCollectionView.reloadData()
//        picturesCollectionView.frame = CGRect(x: picturesCollectionView.frame.minX, y: picturesCollectionView.frame.minY, width: picturesCollectionView.frame.width, height: height)
        print(height)
        print(pictureCollectionView.frame)
    }
    //    func compareDateInAndDateOut(dateOut: String,dateIn: String) {
    //
    //    }
    @IBAction func regoRaListTapped(_ sender: UITapGestureRecognizer) {
        apiPostRequest(parameters: [:], endPoint: EndPoints.HIRED_VEHICLE_DROPDOWN_LIST)
    }
    
    @IBAction func newVehicleRegoRaListTapped(_ sender: UITapGestureRecognizer) {
        apiPostRequest(parameters: [:], endPoint: EndPoints.AVAILABLE_VEHICLE_DROPDOWN_LIST)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dateInCalenderBtnTapped(_ sender: UIButton) {
        showDatePickerPopUp(textField: dateInTxtFld, notificationName: .dateSwapVehicle)
    }
    
    @IBAction func dateOfReplacementCalenderBtnTapped(_ sender: UIButton) {
        showDatePickerPopUp(textField: dateOfReplacementTxtFld, notificationName: .dateSwapVehicle)
    }
    
    @IBAction func submitBtn(_ sender: UIButton) {
        if selectedAppId.isEmpty {
            showToast(strMessage: selectOldRego)
            return
        }
        if selectedVehicleId.isEmpty {
            showToast(strMessage: selectNewRego)
            return
        }
        if Int(mileageInTxtFld.text ?? "") ?? 0  < Int(mileageOutOldTxtFld.text ?? "") ?? 0 {
            showToast(strMessage: mileageInLessThanMileageOut)
            return
        }
        let timeIn = timeInTxtFld.text?.convertTimeToTwentyFourHr(isAM: timeInSegmentedControl.selectedSegmentIndex) ?? ""
        let timeOfReplacement = timeOfReplacementTxtFld.text?.convertTimeToTwentyFourHr(isAM: timeOfReplacementSegmentedControl.selectedSegmentIndex) ?? ""
        let parameters : Parameters = ["app_id": selectedAppId,
                                       "date_in": dateInTxtFld.text ?? "",
                                       "time_in": timeIn,//timeInTxtFld.text!,
                                       "mileage_out" : mileageOutNewTxtFld.text ?? "",
                                       "mileage_in": mileageInTxtFld.text ?? "",
                                       "vehicle_id": selectedVehicleId,
//                                       "noof_days": numberOfDaysTxtFld.text ?? "",
                                       "dateof_replacement":dateOfReplacementTxtFld.text ?? "",
                                       "timeof_replacement":timeOfReplacement, //timeOfReplacementTxtFld.text!,
                                       "user_id" : UserDefaults.standard.userId(),
                                       "oldvehicle_id":selectedOldvehicleId,
                                       "oldmileage_out": mileageOutOldTxtFld.text ?? "",
                                       "olddate_out": dateOutTxtFld.text ?? "",
                                       "user_name": UserDefaults.standard.username()]
        apiPostRequest(parameters: parameters, endPoint: API_URL.SWAP_VEHICLE)
    }
    @objc func SearchListNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let selectedItem = userInfo["selectedItem"] as? String {
                let selectedItemIndex = userInfo["selectedIndex"] as! Int
                print(arrHiredVehicles)
                print(arrAvailableVehicles)
                print(selectedItemIndex)
                switch userInfo["itemSelectedFromList"] as? String {
                case AppDropDownLists.HIRED_VEHICLE_REGO_RA:
                    raRegoLbl.textColor = UIColor(named: AppColors.BLACK)
                    raRegoLbl.text = selectedItem
                    print(arrHiredVehicles)
                    print("Vijay \(arrHiredVehicles[selectedItemIndex].refno)")
                    selectedAppId = arrHiredVehicles[selectedItemIndex].application_id
                    mileageOutOldTxtFld.text = arrHiredVehicles[selectedItemIndex].Mileage_out
                    mileageOutOldTxtFld.isEnabled = false
                    let parameters : Parameters = ["application_id" :arrHiredVehicles[selectedItemIndex].refno]
                    apiPostRequest(parameters: parameters, endPoint: EndPoints.RETURNUPLOADED_DOCS)
                    print(arrHiredVehicles[selectedItemIndex])
                    dateOutTxtFld.text = arrHiredVehicles[selectedItemIndex].date_out
                    dateOutTxtFld.isEnabled = false
                   
                    let timeOut = arrHiredVehicles[selectedItemIndex].time_out
                    timeOutSegmentedControl.setUpAmPM(time: timeOut)
                    timeOutTxtFld.text = timeOut.DatePresentable?.getDateAccoringTo(format: .Time12Hr) ?? ""
                    selectedOldvehicleId = arrHiredVehicles[selectedItemIndex].vehicle_id
                case AppDropDownLists.AVAILABLE_VEHICLE_REGO_RA:
                    newRaRegoLbl.textColor = UIColor(named: AppColors.BLACK)
                    newRaRegoLbl.text = selectedItem
                    selectedVehicleId = arrAvailableVehicles[selectedItemIndex].id
                default:
                    print("Unkown List")
                }
            }
        }
    }
    
    @objc func DateNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let selectedDate = userInfo["selectedDate"] as? String {
                let selectedTextField = userInfo["dateTextField"] as! UITextField
                switch selectedTextField {
                case dateOfReplacementTxtFld:
                    dateOfReplacementTxtFld.text = selectedDate
                case dateInTxtFld:
                    dateInTxtFld.text = selectedDate
                default:
                    print("Unkown Date Textfield")
                }
            }
        }
    }
    
    @objc func TimeNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let selectedTime = userInfo["selectedTime"] as? String {
                let selectedTextField = userInfo["timeTextField"] as! UITextField
                switch selectedTextField {
                case timeInTxtFld:
                    timeInTxtFld.text = selectedTime
                case timeOfReplacementTxtFld:
                    timeOfReplacementTxtFld.text = selectedTime
                default:
                    print("Unkown Time Textfield")
                }
            }
        }
    }
    
    @objc func showImageinLargeSize(sender: UITapGestureRecognizer) {
        if picturesForUpload.count > 0 {
            displayImageOnFullScreen(img: picturesForUpload[sender.view!.tag])
        }
    }
    @objc func showDocumentLargeSize(sender: UITapGestureRecognizer) {
        let index = sender.view!.tag
        print(index)
        let image = arrViewSwapVehicle[index].documentImg
        displayImageOnFullScreen(imgUrl: image)
    }
    @objc func editImages(sender: UIButton) {
        if picturesForUpload.count > 0 {
            picturesForUpload.remove(at: sender.tag)
            if picturesForUpload.count == 0 {
                isAddMorePicturesCell = false
            } else {
                isAddMorePicturesCell = true
            }
            pictureCollectionView.reloadData()
        } else {
            showImgPicker()
        }
        setUpPicturesCV()
    }
    func showImgPicker() {
        let multipleImgPickerController = DKImagePickerController()
        multipleImgPickerController.maxSelectableCount = 15-picturesForUpload.count
        multipleImgPickerController.modalPresentationStyle = .currentContext
        multipleImgPickerController.showsCancelButton = true
        multipleImgPickerController.assetType = .allPhotos
        multipleImgPickerController.UIDelegate = CustomUIDelegate()
        multipleImgPickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets)
//            self.picturesForUpload.removeAll()//Removing Previous values
            for asset in assets {
                asset.fetchOriginalImage(completeBlock: {image,info in
                    //Gettimg images selected
                    if let img = image {
                        self.picturesForUpload.append(img)
                    }
                    
                    print(self.picturesForUpload.count)
                    if asset == assets[assets.count-1] {
                        if self.picturesForUpload.count > 0 && self.picturesForUpload.count < 15 {
                            self.isAddMorePicturesCell = true
                        } else {
                            self.isAddMorePicturesCell = false
                        }
                        self.setUpPicturesCV()
                        self.pictureCollectionView.reloadData()
                    }
                })
            }
        }
        self.present(multipleImgPickerController, animated: true) //{}
    }
}
extension SwapVehicleVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == pictureCollectionView {
            if isAddMorePicturesCell {
                return picturesForUpload.count+1
            } else {
                if picturesForUpload.count > 0 {
                    return picturesForUpload.count
                } else {
                    return 1
                }
            }
        } else {
            return arrViewSwapVehicle.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == pictureCollectionView {
            let swapVehiclePicturescell = collectionView.dequeueReusableCell(withReuseIdentifier: AppCvCells.SWAP_VEHICLE_PICTURES_CELL, for: indexPath) as! SwapVehiclePicturesCvCell
            //return swapVehiclePicturescell
            let addMoreSwapVehiclePicturesCell = collectionView.dequeueReusableCell(withReuseIdentifier: AppCvCells.SWAP_VEHICLE_ADDMORE_PICTURES_CELL, for: indexPath) as! SwapVehicleAddMorePicturesCvCell
            // return addMoreSwapVehiclePicturesCell
            if isAddMorePicturesCell {
                if indexPath.row == picturesForUpload.count  {
                    return addMoreSwapVehiclePicturesCell
                } else {
                    swapVehiclePicturescell.imgView.image = picturesForUpload[indexPath.row]
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showImageinLargeSize(sender:)))
                    swapVehiclePicturescell.imgView.addGestureRecognizer(tapGesture)
                    tapGesture.view?.tag = indexPath.row
                    swapVehiclePicturescell.editBtn.setImage(UIImage(named: AppImageNames.DELETE), for: .normal)
                    swapVehiclePicturescell.editBtn.addTarget(self, action: #selector(editImages(sender:)), for: .touchUpInside)
                    swapVehiclePicturescell.editBtn.tag = indexPath.row
                    return swapVehiclePicturescell
                }
            } else {
                //Will only execute when there is no image in picturesForUpload array or maximum images(Current limit = 5) in picturesForUpload
                if picturesForUpload.count > 0 {
                    swapVehiclePicturescell.imgView.image = picturesForUpload[indexPath.row]
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showImageinLargeSize(sender:)))
                    swapVehiclePicturescell.imgView.addGestureRecognizer(tapGesture)
                    tapGesture.view?.tag = indexPath.row
                    swapVehiclePicturescell.editBtn.setImage(UIImage(named: AppImageNames.DELETE), for: .normal)
                    swapVehiclePicturescell.editBtn.addTarget(self, action: #selector(editImages(sender:)), for: .touchUpInside)
                    swapVehiclePicturescell.editBtn.tag = indexPath.row
                } else {
                    swapVehiclePicturescell.imgView.image = .none
                    swapVehiclePicturescell.editBtn.setImage(UIImage(named: AppImageNames.ADD), for: .normal)
                    swapVehiclePicturescell.editBtn.addTarget(self, action: #selector(editImages(sender:)), for: .touchUpInside)
                    swapVehiclePicturescell.editBtn.tag = indexPath.row
                }
                return swapVehiclePicturescell
                
            }
            
        } else {
            let viewVehiclecell = collectionView.dequeueReusableCell(withReuseIdentifier: AppCvCells.SWAP_VEHICLE_CV_CELL, for: indexPath as IndexPath) as! SwapVehicleCVCell
            let imgUrl = URL(string:arrViewSwapVehicle[indexPath.row].documentImg)
            viewVehiclecell.swapVehicleDocImageView.kf.setImage(with: imgUrl, placeholder: nil, options: nil, completionHandler: nil)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDocumentLargeSize(sender: )))
            viewVehiclecell.swapVehicleDocImageView.addGestureRecognizer(tapGesture)
            tapGesture.view?.tag = indexPath.row
            
            //viewVehiclecell.swapVehicleDocImageView.addGestureRecognizer(tapGesture)
            return viewVehiclecell
        }
            
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var length = CGFloat()
        if UIDevice.current.userInterfaceIdiom == .pad {
            length = (collectionView.frame.width-(4*20))/5
        } else {
            length = (collectionView.frame.width-(3*4))/4
            }
        return CGSize(width: length, height: length)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isAddMorePicturesCell && indexPath.row == picturesForUpload.count {
            showImgPicker()
        }
    }
}

extension SwapVehicleVC : UITextFieldDelegate {
    //    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    //        var isKeyboard = true
    //        switch textField {
    //        case dateOfReplacementTxtFld,dateInTxtFld:
    //            isKeyboard = false
    //            showDatePickerPopUp(textField: textField, notificationName: .dateSwapVehicle)
    //        case timeInTxtFld,timeOfReplacementTxtFld:
    //            isKeyboard = false
    //            showTimePickerPopUp(textField: textField, notificationName: .timeSwapVehicle)
    //        default:
    //            print("Other TextField")
    //        }
    //        return isKeyboard
    //    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case mileageInTxtFld:
            textField.resignFirstResponder()
        case mileageOutNewTxtFld:
            textField.resignFirstResponder()
        case numberOfDaysTxtFld:
            textField.resignFirstResponder()
        default:
            print("Textfield does not return")
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var isAllowed = true
        switch textField {
        case mileageInTxtFld,mileageOutNewTxtFld,numberOfDaysTxtFld:
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            isAllowed = allowedCharacters.isSuperset(of: characterSet)
        case dateOfReplacementTxtFld,dateInTxtFld:
            isAllowed = textField.validateDateTyped(shouldChangeCharactersInRange: range, replacementString: string)
        case timeInTxtFld,timeOfReplacementTxtFld:
            isAllowed = textField.validateTimeTyped(shouldChangeCharactersInRange: range, replacementString: string)
        default:
            print("TextField without restriction")
        }
        return isAllowed
    }
    
}

extension SwapVehicleVC: SwapVehicleVMDelegate {
    func swapVehicleAPISuccess(objData: ReturnUploadedDocsModel, strMessage: String) {
        print(objData.documentDetails)
        arrViewSwapVehicle = objData.documentDetails
        viewSwapVehicleCollectionView.reloadData()
        
    }
    
    func swapVehicleAPISuccess(strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.dismiss(animated: true)
        })
    }
    
    func swapVehicleAPISuccess(objData: HiredVehicleDropdownListModel, strMessage: String) {
        arrHiredVehicles = objData.arrResult
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
        showToast(strMessage: strMessage)
        if objData.arrResult.count > 0 {
            arrAvailableVehicles = objData.arrResult
            print(objData)
            var temp = [String] ()
            for i in 0...objData.arrResult.count-1 {
                temp.append(objData.arrResult[i].registration_no)
            }
            print(arrAvailableVehicles)
            showSearchListPopUp(listForSearch: temp, listNameForSearch: AppDropDownLists.AVAILABLE_VEHICLE_REGO_RA, notificationName: .searchListSwapVehicle)
        }
    }
    
    func swapVehicleAPIFailure(strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
    }
}
