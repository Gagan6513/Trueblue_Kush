//
//  ReturnVehicleVC.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 18/08/21.
//

import UIKit
import Alamofire
import DKImagePickerController
class ReturnVehicleVC: UIViewController {
    
    var applicationID = String()//We get this from Collections Screen
    @IBOutlet weak var picturesCollectionView: UICollectionView!
    @IBOutlet weak var returnUploadedDocsCollectionView: UICollectionView!
    var picturesCVInitialHeight = CGFloat()
    var picturesForUpload = [UIImage]()
    var isAddMorePicturesCell = false
    var selecteddeliveredById = String()
    var returnedRepairerName = String()
    var return_remarks  = String()
    var dateofsattlement = String()
    var arrcollectedBy = [DeliveredCollectedByModelData]()

//    var isLastImageDeleted = false
//    @IBOutlet weak var picturesCVHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionByLbl: UILabel!
    @IBOutlet weak var picturesViewHeightConstraint: NSLayoutConstraint!
    var arrHiredVehicle = [HiredVehicleDropdownListModelData]()
    var arrReturnUploadedDocs = [DocumentDetailsModelData]()
    @IBOutlet weak var regoRaLbl: UILabel!
    @IBOutlet weak var mileageOutTxtFld: UITextField!
    @IBOutlet weak var dateOutTxtFld: UITextField!
    @IBOutlet weak var timeOutTxtFld: UITextField!
    
    @IBOutlet weak var timeOutSegmentedControl: UISegmentedControl!
    @IBOutlet weak var dateInTxtFld: UITextField!
    @IBOutlet weak var timeInTxtFld: UITextField!
    
    @IBOutlet weak var timeInSegmentedControl: UISegmentedControl!
    @IBOutlet weak var milageInTxtFld: UITextField!
    @IBOutlet weak var collectionByView: UIView!
    @IBOutlet weak var collectionByTxtFld: UITextField!
    
    var selectedDropdownItemIndex = -1 as Int
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.DateNotificationAction(_:)), name: .dateReturnVehicle, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.TimeNotificationAction(_:)), name: .timeReturnVehicle, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DeliveredCollectedBy(_:)), name: .deliveredCollectedBy, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchListNotificationAction(_:)), name: .searchListReturnVehicle, object: nil)
        
        mileageOutTxtFld.isUserInteractionEnabled = false
        dateOutTxtFld.isUserInteractionEnabled = false
        timeOutTxtFld.isUserInteractionEnabled = false
        apiPostRequest(parameters: [:], endPoint: EndPoints.HIRED_VEHICLE_DROPDOWN_LIST)
        setViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpPicturesCV()
    }
    
    func setViews() {
        dateOutTxtFld.keyboardType = .numberPad
        dateInTxtFld.keyboardType = .numberPad
        timeInTxtFld.keyboardType = .numberPad
        timeOutSegmentedControl.isUserInteractionEnabled = false
        timeOutSegmentedControl.setUpAmPmSegmentedControl()
        timeInSegmentedControl.setUpAmPmSegmentedControl()
        let deliveryByTap = UITapGestureRecognizer(target: self, action: #selector(deliveryByViewTapped))
        collectionByView.addGestureRecognizer(deliveryByTap)
//        timeInSegmentedControl.setTitle("AM", forSegmentAt: 0)
//        timeInSegmentedControl.setTitle("PM", forSegmentAt: 1)
//        var font = UIFont()
//        if UIDevice.current.userInterfaceIdiom == .pad  {
//            font = UIFont.systemFont(ofSize: 20)
//        } else {
//            font = UIFont.systemFont(ofSize: 10)
//        }
//        timeInSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
    }
    func setUpPicturesCV() {
        var height = CGFloat()
        if UIDevice.current.userInterfaceIdiom == .pad {
            height = (picturesCollectionView.frame.width-(4*20))/5
        } else {
            height = (picturesCollectionView.frame.width-(3*4))/4
        }
        picturesCVInitialHeight = height
        print(height)
        print(picturesCollectionView.frame)
        picturesViewHeightConstraint.constant = height
        
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
                self.picturesViewHeightConstraint.constant = (self.picturesCVInitialHeight * CGFloat(noOfRows)) + CGFloat((noOfRows-1) * vs)
                
            } else {
                self.picturesViewHeightConstraint.constant = self.picturesCVInitialHeight
            }
//            self.view.layoutSubviews()
//            self.picturesCollectionView.superview?.layoutSubviews()
        }
//        picturesCollectionView.layoutIfNeeded()
//        picturesCollectionView.reloadData()
//        picturesCollectionView.frame = CGRect(x: picturesCollectionView.frame.minX, y: picturesCollectionView.frame.minY, width: picturesCollectionView.frame.width, height: height)
        print(height)
        print(picturesCollectionView.frame)
    }
    
    func setUpData() {
        if !applicationID.isEmpty {
            // User comes from collection screen
            for i in 0...arrHiredVehicle.count-1 {
                if applicationID == arrHiredVehicle[i].refno {
                    regoRaLbl.textColor = UIColor(named: AppColors.BLACK)
                    regoRaLbl.text = arrHiredVehicle[i].refno + "-" + arrHiredVehicle[i].registration_no
                    mileageOutTxtFld.text = arrHiredVehicle[i].Mileage_out
                    dateOutTxtFld.text = arrHiredVehicle[i].date_out
//                    timeOutTxtFld.text = arrHiredVehicle[i].time_out
                    let timeOut = arrHiredVehicle[i].time_out
                    timeOutSegmentedControl.setUpAmPM(time: timeOut)
                    timeOutTxtFld.text = timeOut.DatePresentable?.getDateAccoringTo(format: .Time12Hr) ?? ""
                }
            }
        }
    }
    @IBAction func submitTapped(_ sender: Any) {
        if mileageOutTxtFld.text == "" {
            showToast(strMessage: milageOutRequired)
            return
        }
        if dateOutTxtFld.text == "" {
            showToast(strMessage: dateOutRequired)
            return
        }
        
        if timeOutTxtFld.text == "" {
            showToast(strMessage: timeOutRequired)
            return
        }
        if Int(milageInTxtFld.text ?? "") ?? 0 < Int(mileageOutTxtFld.text ?? "") ?? 0 {
            showToast(strMessage: mileageInLessThanMileageOut)
            return
        }
        let timeIn = timeInTxtFld.text?.convertTimeToTwentyFourHr(isAM: timeInSegmentedControl.selectedSegmentIndex) ?? ""
        var storyboardName = String()
        var vcID = String()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            vcID = AppStoryboardId.ADD_MORE_DETAILS
            storyboardName = AppStoryboards.DASHBOARD
            
        } else {
            vcID = AppStoryboardId.ADD_MORE_DETAILS_PHONE
            storyboardName = AppStoryboards.DASHBOARD_PHONE
        }
        let storyboard = UIStoryboard(name:storyboardName , bundle: .main)
        let addMoreDetailVc = storyboard.instantiateViewController(identifier: vcID) as! AddMoreDetailsVC
        addMoreDetailVc.appID = arrHiredVehicle[selectedDropdownItemIndex].application_id
        addMoreDetailVc.vechicleId = arrHiredVehicle[selectedDropdownItemIndex].vehicle_id
        addMoreDetailVc.dateInValue = dateInTxtFld.text ?? ""
        addMoreDetailVc.mileageInValue = milageInTxtFld.text ?? ""
        addMoreDetailVc.selectedDeliveredBy = selecteddeliveredById
        addMoreDetailVc.timeInValue = timeInTxtFld.text ?? ""
        
        present(addMoreDetailVc, animated: true, completion: nil)
        
        
    }
    
    func apiPostRequest(parameters: Parameters,endPoint: String){
        CommonObject.sharedInstance.showProgress()
        let obj = ReturnVehicleViewModel()
        obj.delegate = self
        obj.postReturnVehicle(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    
    func apiGetRequest(parameters: Parameters?,endPoint: String) {
        CommonObject.sharedInstance.showProgress()
        let obj = ReturnVehicleViewModel()
        obj.delegate = self
        obj.getReturnVehicle(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    func deliveryByListAPI() {
        let obj = DeliveredCollectedByViewModel()
        obj.delegate = self
        obj.deliveredCollectedByAPI(currentController: self, parameters: [:], endPoint: EndPoints.DELIVERED_COLLECTEDBY)
    }
    
    func apiPostMultipartRequest(parameters: Parameters,endPoint: String,image: [UIImage],isImg: Bool,isMultipleImg: Bool,imgParameter: String,imgExtension: String){
        CommonObject.sharedInstance.showProgress()
        let obj = ReturnVehicleViewModel()
        obj.delegate = self
        obj.postMultipartReturnVehicle(currentController: self, parameters: parameters, endPoint: endPoint, img: image, isImage: isImg, isMultipleImg: isMultipleImg, imgParameter: imgParameter, imgExtension: imgExtension)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        NotificationCenter.default.removeObserver(self)//Removes all notifications being observed
//    }
    
    
    @IBAction func regoRaTxtFld(_ sender: UITapGestureRecognizer) {
        print(applicationID)
        if applicationID.isEmpty {//This check disables dropdown when previous screen was Collections
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
    //            showPickerViewPopUp(list: temp, listNameForSelection: AppDropDownLists.RETURN_VEHICLE_REGO,notificationName: .returnVehicleDetails)
            } else {
                showToast(strMessage: noRecordAvailable)
            }
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dateInCalenderBtnTapped(_ sender: UIButton) {
        showDatePickerPopUp(textField: dateInTxtFld, notificationName: .dateReturnVehicle)
    }
    @objc func DateNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
           if let selectedDate = userInfo["selectedDate"] as? String {
            let selectedTextField = userInfo["dateTextField"] as! UITextField
            switch selectedTextField {
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
            default:
                print("Unkown Time Textfield")
            }
            }
        }
    }
    
    
    @objc func SearchListNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
           if let selectedItem = userInfo["selectedItem"] as? String {
            
            selectedDropdownItemIndex = userInfo["selectedIndex"] as! Int
            print(selectedDropdownItemIndex)
            
            switch userInfo["itemSelectedFromList"] as? String {
                case AppDropDownLists.RETURN_VEHICLE_REGO:
                    regoRaLbl.textColor = UIColor(named: AppColors.BLACK)
                    regoRaLbl.text = selectedItem
                    
                    mileageOutTxtFld.text = arrHiredVehicle[selectedDropdownItemIndex].Mileage_out
                    dateOutTxtFld.text = arrHiredVehicle[selectedDropdownItemIndex].date_out
                let parameters : Parameters = ["application_id" :arrHiredVehicle[selectedDropdownItemIndex].refno ]
                apiPostRequest(parameters: parameters, endPoint: EndPoints.RETURNUPLOADED_DOCS)
                print(arrHiredVehicle[selectedDropdownItemIndex])
//                    timeOutTxtFld.text = arrHiredVehicle[selectedDropdownItemIndex].time_out
                let timeOut = arrHiredVehicle[selectedDropdownItemIndex].time_out
                timeOutSegmentedControl.setUpAmPM(time: timeOut)
                timeOutTxtFld.text = timeOut.DatePresentable?.getDateAccoringTo(format: .Time12Hr) ?? ""
            
                default:
                print("Unkown List")
                }
            }
        }
    }
    @objc func DeliveredCollectedBy(_ notification : NSNotification) {
        if let userInfo = notification.userInfo {
            let selectedItem = userInfo["selectedItem"] as! String
            let selectedItemIndex = userInfo["selectedIndex"] as! Int
           switch userInfo["itemSelectedFromList"] as? String {
            case AppDropDownLists.COLLECTED_BY:
                print(arrcollectedBy)
                collectionByLbl.textColor = UIColor(named: AppColors.BLACK)
                collectionByLbl.text = selectedItem
               print(selectedItem)
                //Lbl
               selecteddeliveredById = arrcollectedBy[selectedItemIndex].id
               print(selecteddeliveredById)
            default:
                print("Unknow List")
            }
        }
    }
    @objc func deliveryByViewTapped(_ sender: UITapGestureRecognizer) {
        deliveryByListAPI()
    }
    
    @objc func showImageinLargeSize(sender: UITapGestureRecognizer) {
        if picturesForUpload.count > 0 {
            displayImageOnFullScreen(img: picturesForUpload[sender.view!.tag])
        }
    }
    @objc func showDocumentinLargeSize(sender: UITapGestureRecognizer) {
        let index = sender.view!.tag
        let imageUrl = arrReturnUploadedDocs[index].documentImg
        displayImageOnFullScreen(imgUrl: imageUrl)
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
                        self.picturesCollectionView.reloadData()
                    }
                })
            }
        }
        self.present(multipleImgPickerController, animated: true) //{}
    }
    
    @objc func editImages(sender: UIButton) {
        if picturesForUpload.count > 0 {
            picturesForUpload.remove(at: sender.tag)
            if picturesForUpload.count == 0 {
                isAddMorePicturesCell = false
            } else {
                isAddMorePicturesCell = true
            }
            picturesCollectionView.reloadData()
        } else {
            showImgPicker()
        }
        setUpPicturesCV()
    }
//    @objc func selectImages(sender: UIButton) {
////        if isLastImageDeleted {
////            isLastImageDeleted = false
////            return
////        }
//
//        showImgPicker()
//    }
//
//    @objc func deleteImages(sender: UIButton) {
//        picturesForUpload.remove(at: sender.tag)
//        if picturesForUpload.count == 0 {
//            isAddMorePicturesCell = false
//            isLastImageDeleted = true
//        }
//        picturesCollectionView.reloadData()
//    }

}

extension ReturnVehicleVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if picturesForUpload.count < 5 {
//            return picturesForUpload.count+1
//        } else {
//            return  picturesForUpload.count
//        }
        if collectionView == picturesCollectionView {
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
            return arrReturnUploadedDocs.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == picturesCollectionView {
            let picturesCell = collectionView.dequeueReusableCell(withReuseIdentifier: AppCvCells.RETURN_VEHICLE_PICTURES, for: indexPath) as! ReturnVehiclePicturesCvCell
            
    //        let firstImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: AppCvCells.RETURN_VEHICLE_PICTURES, for: indexPath) as! ReturnVehiclePicturesCvCell
            
            let addMorePicturesCell = collectionView.dequeueReusableCell(withReuseIdentifier: AppCvCells.RETURN_VEHICLE_ADD_MORE_PICTURES, for: indexPath) as! ReturnVehicleAddMorePicturesCvCell
            print(picturesForUpload.count)
            print(isAddMorePicturesCell)
            print(indexPath.row)
            
    //        //if we are in last cell
    //        if picturesForUpload.count == 0 && indexPath.row == 0 {
    //
    //                //Will only execute when there is no image in picturesForUpload array
    //                firstImageCell.imgView.image = .none
    //                firstImageCell.editBtn.setImage(UIImage(named: AppImageNames.ADD), for: .normal)
    //                firstImageCell.editBtn.addTarget(self, action: #selector(selectImages(sender:)), for: .touchUpInside)
    //                firstImageCell.editBtn.tag = indexPath.row
    //                return firstImageCell
    //        }
    //        else if indexPath.row == picturesForUpload.count && picturesForUpload.count < 5{
    //                return addMorePicturesCell
    //            }
    //        else {
    //            picturesCell.imgView.image = picturesForUpload[indexPath.row]
    //            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showImageinLargeSize(sender:)))
    //            picturesCell.imgView.addGestureRecognizer(tapGesture)
    //            tapGesture.view?.tag = indexPath.row
    //            picturesCell.editBtn.setImage(UIImage(named: AppImageNames.DELETE), for: .normal)
    //            picturesCell.editBtn.addTarget(self, action: #selector(deleteImages(sender:)), for: .touchUpInside)
    //            picturesCell.editBtn.tag = indexPath.row
    //            return picturesCell
    //        }
    //
            if isAddMorePicturesCell {
                if indexPath.row == picturesForUpload.count  {
                    return addMorePicturesCell
                } else {
                    picturesCell.imgView.image = picturesForUpload[indexPath.row]
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showImageinLargeSize(sender:)))
                    picturesCell.imgView.addGestureRecognizer(tapGesture)
                    tapGesture.view?.tag = indexPath.row
                    picturesCell.editBtn.setImage(UIImage(named: AppImageNames.DELETE), for: .normal)
                    picturesCell.editBtn.addTarget(self, action: #selector(editImages(sender:)), for: .touchUpInside)
                    picturesCell.editBtn.tag = indexPath.row
                    return picturesCell
                }
            } else {
                //Will only execute when there is no image in picturesForUpload array or maximum images(Current limit = 5) in picturesForUpload
                if picturesForUpload.count > 0 {
                    picturesCell.imgView.image = picturesForUpload[indexPath.row]
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showImageinLargeSize(sender:)))
                    picturesCell.imgView.addGestureRecognizer(tapGesture)
                    tapGesture.view?.tag = indexPath.row
                    picturesCell.editBtn.setImage(UIImage(named: AppImageNames.DELETE), for: .normal)
                    picturesCell.editBtn.addTarget(self, action: #selector(editImages(sender:)), for: .touchUpInside)
                    picturesCell.editBtn.tag = indexPath.row
                } else {
                    picturesCell.imgView.image = .none
                    picturesCell.editBtn.setImage(UIImage(named: AppImageNames.ADD), for: .normal)
                    picturesCell.editBtn.addTarget(self, action: #selector(editImages(sender:)), for: .touchUpInside)
                    picturesCell.editBtn.tag = indexPath.row
                }
                return picturesCell
            }
            
            //
            print(picturesForUpload.count)
            print(isAddMorePicturesCell)
            print(indexPath.row)
    //        switch isAddMorePicturesCell {
    //        case true:
    //            if indexPath.row == picturesForUpload.count {
    ////                addMorePicturesCell..tag = indexPath.row
    ////                addMorePicturesCell.addImgBtn.addTarget(self, action: #selector(addAccidentImg(sender:)), for: .touchUpInside)
    //                return addMorePicturesCell
    //            } else {
    //
    //                if picturesForUpload.count > 0 {
    ////                    let imgUrl = URL(string: arrAccidentImages[indexPath.row].imgUrl)
    ////                    accidentPicsCell.imgView.kf.setImage(with: imgUrl, placeholder: nil, options: nil, completionHandler: nil)
    //                    picturesCell.imgView.image = picturesForUpload[indexPath.row]
    //                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showImageinLargeSize(sender:)))
    //                    picturesCell.imgView.addGestureRecognizer(tapGesture)
    //                    tapGesture.view?.tag = indexPath.row
    //                } else {
    //                    picturesCell.imgView.image = .none
    //                }
    //                picturesCell.editBtn.tag = indexPath.row
    //                if picturesForUpload.count == 1 {
    //                    picturesCell.editBtn.setImage(UIImage(named: AppImageNames.ADD), for: .normal)
    //                    picturesCell.editBtn.addTarget(self, action: #selector(selectImages(sender:)), for: .touchUpInside)
    //                } else {
    //                    picturesCell.editBtn.setImage(UIImage(named: AppImageNames.DELETE), for: .normal)
    //                    picturesCell.editBtn.addTarget(self, action: #selector(deleteImages(sender:)), for: .touchUpInside)
    //                }
    //
    //
    //                return picturesCell
    //            }
    //        case false:
    //            print(indexPath.row)
    //            if picturesForUpload.count > 0 {
    //                print(picturesForUpload)
    ////                let imgUrl = URL(string: arrAccidentImages[indexPath.row].imgUrl)
    ////                accidentPicsCell.imgView.kf.setImage(with: imgUrl, placeholder: nil, options: nil, completionHandler: nil)
    //                picturesCell.imgView.image = picturesForUpload[indexPath.row]
    //                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showImageinLargeSize(sender:)))
    //                picturesCell.imgView.addGestureRecognizer(tapGesture)
    //                tapGesture.view?.tag = indexPath.row
    //            } else {
    //                picturesCell.imgView.image = .none
    //            }
    //            picturesCell.editBtn.tag = indexPath.row
    //            if picturesForUpload.count == 1 {
    //                picturesCell.editBtn.setImage(UIImage(named: AppImageNames.ADD), for: .normal)
    //                picturesCell.editBtn.addTarget(self, action: #selector(selectImages(sender:)), for: .touchUpInside)
    //            } else {
    //                picturesCell.editBtn.setImage(UIImage(named: AppImageNames.DELETE), for: .normal)
    //                picturesCell.editBtn.addTarget(self, action: #selector(deleteImages(sender:)), for: .touchUpInside)
    //            }
    //            return picturesCell
    //        }
        } else {
            let returnuploadedDocsCell = collectionView.dequeueReusableCell(withReuseIdentifier: AppCvCells.RETURN_UPLOADED_DOCS_CELL, for: indexPath as IndexPath) as! ReturnUploadedDocsCollectionViewCell
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDocumentinLargeSize(sender:)))
            returnuploadedDocsCell.returnuploadedDocsImageView.addGestureRecognizer(tapGesture)
            tapGesture.view?.tag = indexPath.row
            let imgUrl = URL(string: arrReturnUploadedDocs[indexPath.row].documentImg)
            returnuploadedDocsCell.returnuploadedDocsImageView.kf.setImage(with: imgUrl, placeholder: nil, options: nil, completionHandler: nil)
        return returnuploadedDocsCell
        }
       //return picturesCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isAddMorePicturesCell && indexPath.row == picturesForUpload.count {
            showImgPicker()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var length = CGFloat()
        if UIDevice.current.userInterfaceIdiom == .pad {
            length = (collectionView.frame.width-(4*20))/5
        } else {
            length = (collectionView.frame.width-(3*4))/4
            //Maximum limit is five pictures
//            if indexPath.row > 3 {
//                picturesCVHeightConstraint.constant = (picturesCVInitialHeight * 2) + 4//Vertical space
//            } else {
//                picturesCVHeightConstraint.constant = picturesCVInitialHeight
//            }
            //To adjust collectionView Height
           
//
//            setUpPicturesCV()
        }
//        collectionView.superview?.layoutSubviews()
//        view.layoutSubviews()
//        collectionView.layoutSubviews()
//        let width = (collectionView.frame.width-(4*20))/5
        return CGSize(width: length, height: length)
    }
}
extension ReturnVehicleVC : UITextFieldDelegate {
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        var isKeyboard = true
//        switch textField {
//        case dateInTxtFld:
//            isKeyboard = false
//            showDatePickerPopUp(textField: textField, notificationName: .dateReturnVehicle)
//        case timeInTxtFld:
//            isKeyboard = false
//            showTimePickerPopUp(textField: textField, notificationName: .timeReturnVehicle)
//        default:
//            print("Other TextField")
//        }
//        return isKeyboard
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
//        case mileageOutTxtFld://TextField is disabled
//            textField.resignFirstResponder()
        case milageInTxtFld:
            textField.resignFirstResponder()
            collectionByTxtFld.becomeFirstResponder()
        case collectionByTxtFld:
            textField.resignFirstResponder()
        default:
            print("Textfield without keyboard as input")
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var isAllowed = true
        switch textField {
        case milageInTxtFld,mileageOutTxtFld:
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            isAllowed = allowedCharacters.isSuperset(of: characterSet)
        case dateInTxtFld:
            isAllowed = textField.validateDateTyped(shouldChangeCharactersInRange: range, replacementString: string)
        case timeInTxtFld:
            isAllowed = textField.validateTimeTyped(shouldChangeCharactersInRange: range, replacementString: string)
        default:
            print("TextField without restriction")
        }
        return isAllowed
    }
    
    
}

extension ReturnVehicleVC : ReturnVehicleVMDelegate {
    func returnVehicleAPISuccess(objData: ReturnUploadedDocsModel, strMessage: String) {
        arrReturnUploadedDocs = objData.documentDetails
        returnUploadedDocsCollectionView.reloadData()
        
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
extension ReturnVehicleVC : DeliveredCollectedByVMDelegate {
    func deliveredCollectedByAPISuccess(strMessage: String, serviceKey: String) {
        
    }
    
    func deliveredCollectedByAPISuccess(objData: DeliveredCollectedByModel, strMessage: String, serviceKey: String) {
        print("\(objData.arrResult)")
        if objData.arrResult.count > 0 {
            var temp = [String] ()
            for i in 0...objData.arrResult.count-1 {
                temp.append(objData.arrResult[i].user_name)
            }
            arrcollectedBy = objData.arrResult
            showSearchListPopUp(listForSearch: temp, listNameForSearch: AppDropDownLists.COLLECTED_BY, notificationName: .deliveredCollectedBy)
        }
        
    }
    
    func deliveredCollectedByAPIFailure(strMessage: String, serviceKey: String) {
    }
}
//extension ReturnVehicleVC : AddMoreDetailsDelegate {
//    func addMoreDetails(repairerName: String, dateOfSettlement: String, other: String) {
//        self.returnedRepairerName = repairerName
//        self.dateofsattlement = dateOfSettlement
//        self.return_remarks = other
//    }
//}
extension ReturnVehicleVC {
    func textFieldDidEndEditing(_ textField: UITextField) {
        //showDatePickerPopUp(textField: dateInTxtFld, notificationName: .dateReturnVehicle)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateInTxtFld {
            showDatePickerPopUp(textField: dateInTxtFld, notificationName: .dateReturnVehicle)
        }
        //showDatePickerPopUp(textField: dateInTxtFld, notificationName: .dateReturnVehicle)
    }
}
