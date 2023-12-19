//
//  UploadDocumentsVC.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 20/08/21.


import UIKit
import Alamofire
import Kingfisher
import DKImagePickerController

protocol NewBookingBackDelegate {
    func dismissVC()
}
class UploadDocumentsVC: UIViewController, NewBookingBackDelegate, GalleryCellDelegate {
    

    @IBOutlet weak var cImageCollectionView: UICollectionView!
    //    var isDataRefreshNeeded = true//Call get documents data service only if this parameter is true
    var imagePicker: ImagePicker!
    var multipleImgPicker: MultipleImgPicker!
    var currentImgPickedFor = -1
    var selectedImageFinal = UIImage()//To store image returned from image picker class
    var sourceType = String()
    var isImage = false
    var imgExtension = String()
    var dictUploadedDocumentsData = UploadDocumentsModelData()
    //Accident Pics Collection View
    var dictPreview = PreviewModelData()
    var accidentImgChangedAtRow = Int()
    var numOfAccidentImageCells = 1
    var totalAccidentImgCells = 1
    var isAddMoreAccidentPicCell = false
    struct accidentImagesData {
        var indexNumber = Int()
        var imgUrl = String()
    }
//    @IBOutlet weak var scrollContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var accidentPicsCVHeightConstraint: NSLayoutConstraint!
    var arrAccidentImages = [accidentImagesData]()
    var accidentImagesMissingAtIndex = [Int]()
    var accidentImageDisplayIndex = Int()
//    @IBOutlet weak var documentsTblView: UITableView!
    @IBOutlet weak var signatureImgView: UIImageView!
    @IBOutlet weak var signatureImgView2: UIImageView!
    @IBOutlet weak var accidentPicsCollectionView: UICollectionView!
    @IBOutlet weak var documentLbl: UILabel!
//    @IBOutlet weak var documentTblViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var documentImgView: UIImageView!
    @IBOutlet weak var addDocumentImgView: UIImageView!
    @IBOutlet weak var deleteSignBtn: UIButton!
    @IBOutlet weak var SignBtn1: UIButton!
    @IBOutlet weak var SignBtn2: UIButton!
    
    let documentLblUnselectedText = "Select Document Type"
    var documentTblViewRowHeight = CGFloat() //= 80
    var initialViewHeight = CGFloat()
    var documentTblViewInitialHeight = CGFloat()
    var listNameForSelection = String()
    var arrDocumentList = [DocumentListModelData]()
    var selectedDocumentId = String()
    var allDocumentImgs = [UIImage]()
    var accidentPicsCVInitialHeight = CGFloat()
    var accidentPicCVSide = CGFloat()
    var deletDocumentId = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register the cell
        

        CommonObject.sharedInstance.isNewEntry = false
        if UIDevice.current.userInterfaceIdiom == .pad  {
            documentTblViewRowHeight = 80
        } else {
            documentTblViewRowHeight = 40
        }
        print(CommonObject.sharedInstance.currentReferenceId)
        hideKeyboardWhenTappedAround()
//        documentTblViewHeightConstraint.constant = 0
        
        scrollViewHeightConstraint.constant = signatureImgView.frame.origin.y + signatureImgView.frame.height + 50
        
        scrollViewHeightConstraint.constant = signatureImgView2.frame.origin.y + signatureImgView2.frame.height + 50
        
        print(scrollViewHeightConstraint.constant)
        initialViewHeight = scrollViewHeightConstraint.constant
//        documentTblViewInitialHeight = documentTblViewHeightConstraint.constant
        setAccidentPicCVHeight()
        //getPreview()
        getUploadedDocumentDetails()
        getAllDocumentsId()//Getting document id of All Documents
        imagePicker = ImagePicker(presentationController: self, delegate: self)//For choosing single image
        multipleImgPicker = MultipleImgPicker(presentationController: self,delegate: self)
        signatureImgView.layer.borderColor = UIColor(named: AppColors.INPUT_BORDER)?.cgColor
        signatureImgView2.layer.borderColor = UIColor(named: AppColors.INPUT_BORDER)?.cgColor
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            signatureImgView.layer.borderWidth = 3
            signatureImgView2.layer.borderWidth = 3
        } else {
            signatureImgView.layer.borderWidth = 1
            signatureImgView2.layer.borderWidth = 1
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.ReloadScreenNotificationAction(_:)), name: .reloadUploadDocuments, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.NotificationAct(_:)), name: .listDocuments, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.SignNotificationAction(_:)), name: .digitalSignature, object: nil)
//
        // Do any additional setup after loading the view.
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        NotificationCenter.default.removeObserver(self)//Removes all notifications being observed
//    }
    
    
    func apiPostRequest(parameters: Parameters,endPoint: String){
        CommonObject.sharedInstance.showProgress()
        let obj = UploadDocumentsViewModel()
        obj.delegate = self
        obj.postUploadDocuments(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    
    
    func apiGetRequest(parameters: Parameters?,endPoint: String) {
        CommonObject.sharedInstance.showProgress()
        let obj = UploadDocumentsViewModel()
        obj.delegate = self
        obj.getUploadDocuments(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    
    func apiPostMultipartRequest(parameters: Parameters,endPoint: String,image: [UIImage],isImg: Bool,isMultipleImg: Bool,imgParameter: String,imgExtension: String){
        CommonObject.sharedInstance.showProgress()
        let obj = UploadDocumentsViewModel()
        obj.delegate = self
        obj.postMultipartUploadDocuments(currentController: self, parameters: parameters, endPoint: endPoint, img: image, isImage: isImg, isMultipleImg: isMultipleImg, imgParameter: imgParameter, imgExtension: imgExtension)
    }
    
//    override func viewWillLayoutSubviews() {
////        super.viewWillLayoutSubviews()
//        setAccidentPicCVHeight()
//    }
//
    func setAccidentPicCVHeight() {
        var height = CGFloat()
        if UIDevice.current.userInterfaceIdiom == .pad {
            height = (accidentPicsCollectionView.frame.width-(60))/5
        } else {
            height = (accidentPicsCollectionView.frame.width-(2*4))/3
        }
        print(height)
        
        accidentPicsCVInitialHeight = height
        if UIDevice.current.userInterfaceIdiom == .pad {
            scrollViewHeightConstraint.constant -= accidentPicsCVHeightConstraint.constant
            accidentPicsCVHeightConstraint.constant = accidentPicsCVInitialHeight
            scrollViewHeightConstraint.constant += (accidentPicsCVHeightConstraint.constant)
        } else {
            scrollViewHeightConstraint.constant -= accidentPicsCVHeightConstraint.constant
            accidentPicsCVHeightConstraint.constant = (accidentPicsCVInitialHeight*2)+4
            scrollViewHeightConstraint.constant += (accidentPicsCVHeightConstraint.constant)
        }
    }
    func setUpViewHeight() {
        
//        scrollViewHeightConstraint.constant -= documentTblViewHeightConstraint.constant
//        documentTblViewHeightConstraint.constant = 0
//        
//        if dictUploadedDocumentsData.documentsUploaded.count == 1 {
//            //Diksha Rattan:Api returns 1 value in document array even if there is no document uploaded
//            if !dictUploadedDocumentsData.documentsUploaded[0].documentId.isEmpty {
//                documentTblViewHeightConstraint.constant = documentTblViewRowHeight * 2
//                scrollViewHeightConstraint.constant += documentTblViewHeightConstraint.constant
//            }
//        } else if dictUploadedDocumentsData.documentsUploaded.count > 1 {
//            scrollViewHeightConstraint.constant += (documentTblViewRowHeight * CGFloat(dictUploadedDocumentsData.documentsUploaded.count+1)) //- documentTblViewInitialHeight
//            documentTblViewHeightConstraint.constant = (documentTblViewRowHeight * CGFloat(dictUploadedDocumentsData.documentsUploaded.count+1))
//        }
    }
    func getUploadedDocumentDetails() {
        let parameters : Parameters = ["application_id" : CommonObject.sharedInstance.currentReferenceId]
        apiPostRequest(parameters: parameters, endPoint: EndPoints.GET_UPLOADED_DOCUMENTS_TAB_DETAILS)
    }
    
    func getAllDocumentsId() {
        documentLbl.text = "All Documents"
        apiPostRequest(parameters: [:], endPoint: EndPoints.DOCUMENT_LIST)
    }
    func resetDocumentLblAndTable() {
        documentImgView.image = .none
        //Uncomment when documents are uploaded differently
        //documentLbl.text = documentLblUnselectedText
        //documentLbl.textColor = UIColor(named: AppColors.GREY)
    }
    
    func getPreview() {
        let parameters : Parameters = ["application_id" : CommonObject.sharedInstance.currentReferenceId, "vehicle_id" : CommonObject.sharedInstance.vehicleId  ]
        apiPostRequest(parameters: parameters, endPoint: EndPoints.RA_PREVIEW)
    }
    
    func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
//    func displayImageOnFullScreen(imgUrl: String) {
//        let storyboard = UIStoryboard(name: AppStoryboards.DASHBOARD, bundle: .main)
//        let alertVc = storyboard.instantiateViewController(identifier: AppStoryboardId.DISPLAY_FULL_IMAGE) as! DisplayFullImageVC
//        alertVc.imageUrlForDisplay =  imgUrl
//        alertVc.modalPresentationStyle = .overFullScreen
////        view.endEditing(true)//To remove any keyboard that were open on other texfield
//        present(alertVc, animated: true, completion: nil)
//    }
    @IBAction func documentImgViewTapped(_ sender: UITapGestureRecognizer) {
//        allDocumentImgs.removeAll()
//        multipleImgPicker.present(maxSelectableCount: 15)
//        let maximumSelectableCount = 15 - dictUploadedDocumentsData.documentsUploaded.count
        print(allDocumentImgs.count)
        allDocumentImgs.removeAll()
        let multipleImgPickerController = DKImagePickerController()
        multipleImgPickerController.maxSelectableCount = 15
        multipleImgPickerController.modalPresentationStyle = .fullScreen
        multipleImgPickerController.assetType = .allPhotos
        multipleImgPickerController.showsCancelButton = true
        multipleImgPickerController.UIDelegate = CustomUIDelegate()
        multipleImgPickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets)
            print(self.allDocumentImgs.count)

            for asset in assets {
                asset.fetchOriginalImage(completeBlock: {image,info in
                    //Gettimg images selected
                    self.allDocumentImgs.append(image!)
                    print(self.allDocumentImgs)
                    if self.allDocumentImgs.count == assets.count {

                        let parameters : Parameters = ["application_id" : CommonObject.sharedInstance.currentReferenceId,
                                                       "document_id": self.selectedDocumentId]
                        self.apiPostMultipartRequest(parameters: parameters, endPoint: EndPoints.UPLOAD_MULTIPLE_DOCS, image: self.allDocumentImgs, isImg: true, isMultipleImg: true, imgParameter: "image", imgExtension: "jpg")
                    }
                })
            }
        }
        self.present(multipleImgPickerController, animated: true) {}
        
        
        
        //Following code was used when documents were uploaded individually
//        if selectedDocumentId.isEmpty {
//            showToast(strMessage: "Please select document")
//            return
//        }
//        currentImgPickedFor = 1
//        imagePicker.present(from: documentImgView)
    }
    
    @IBAction func signatureImgViewTapped(_ sender: UITapGestureRecognizer) {
       // performSegue(withIdentifier: AppSegue.DIGITAL_SIGNATURE, sender: nil)
        if signatureImgView.image != .none {
            displayImageOnFullScreen(imgUrl: dictUploadedDocumentsData.signImg)
//            let storyboard = UIStoryboard(name: AppStoryboards.DASHBOARD, bundle: .main)
//            let alertVc = storyboard.instantiateViewController(identifier: AppStoryboardId.DISPLAY_FULL_IMAGE) as! DisplayFullImageVC
//            alertVc.imageUrlForDisplay =  dictUploadedDocumentsData.signImg
//            alertVc.modalPresentationStyle = .overFullScreen
//    //        view.endEditing(true)//To remove any keyboard that were open on other texfield
//            present(alertVc, animated: true, completion: nil)
        }
    }
    
    @IBAction func signatureImgViewTapped2(_ sender: UITapGestureRecognizer) {
       // performSegue(withIdentifier: AppSegue.DIGITAL_SIGNATURE, sender: nil)
        if signatureImgView2.image != .none {
            displayImageOnFullScreen(imgUrl: dictUploadedDocumentsData.signImage2)
//            let storyboard = UIStoryboard(name: AppStoryboards.DASHBOARD, bundle: .main)
//            let alertVc = storyboard.instantiateViewController(identifier: AppStoryboardId.DISPLAY_FULL_IMAGE) as! DisplayFullImageVC
//            alertVc.imageUrlForDisplay =  dictUploadedDocumentsData.signImg
//            alertVc.modalPresentationStyle = .overFullScreen
//    //        view.endEditing(true)//To remove any keyboard that were open on other texfield
//            present(alertVc, animated: true, completion: nil)
        }
    }
    @IBAction func previewBtn(_ sender: UIButton) {
        var parameters = [String : Any]()
        parameters["application_id"] = CommonObject.sharedInstance.currentReferenceId
        parameters["vehicle_id"] = CommonObject.sharedInstance.vehicleId
        let endPoint = EndPoints.RA_PREVIEW

        let obj = PreviewViewModel()
        obj.delegate = self
        obj.previewAPI(currentController: self, parameters: parameters, endPoint: endPoint)
        
        
//        getPreview()
        
    }
    @IBAction func mailInvoiceBtn(_ sender: UIButton) {

        var storyboardName = String()
        var vcid = String()
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboardName = AppStoryboards.DASHBOARD
            vcid = AppStoryboardId.SENDTOEMAIL
            
        } else {
            storyboardName  = AppStoryboards.DASHBOARD_PHONE
            vcid = AppStoryboardId.SENDTOEMAIL_PHONE
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        let sendToEmailVc = storyboard.instantiateViewController(identifier: vcid) as! SendToEmailVC
//            alertVc.dictCardDetails = dictUploadedDocumentsData.cardDetails//Sending Card Details to Card Details Screen
        
        sendToEmailVc.modalPresentationStyle = .overFullScreen
        present(sendToEmailVc, animated: true, completion: nil)
    }
    @IBAction func finalSubmitBtn(_ sender: UIButton) {
        var parameters = [String : Any]()
        parameters["application_id"] = CommonObject.sharedInstance.currentReferenceId
        parameters["vehicle_id"] = CommonObject.sharedInstance.vehicleId
        let endPoint = EndPoints.FINAL_SUBMIT
         
        let obj = FinalSubmitViewModel()
        obj.delegate = self
        obj.finalSubmitAPI(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    @IBAction func cardDetailsBtn(_ sender: UIButton) {
        var storyboard = UIStoryboard()
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboard = UIStoryboard(name: AppStoryboards.DASHBOARD, bundle: .main)
        } else {
            storyboard = UIStoryboard(name: AppStoryboards.DASHBOARD_PHONE, bundle: .main)
        }
        let alertVc = storyboard.instantiateViewController(identifier: AppStoryboardId.CARD_DETAILS) as! CardDetailsVC
        alertVc.dictCardDetails = dictUploadedDocumentsData.cardDetails//Sending Card Details to Card Details Screen
        alertVc.modalPresentationStyle = .overFullScreen
        present(alertVc, animated: true, completion: nil)
    }
    @IBAction func uploadSignBtn(_ sender: UIButton) {
        SignBtn1.isSelected = true
        SignBtn2.isSelected = false
        performSegue(withIdentifier: AppSegue.DIGITAL_SIGNATURE, sender: nil)
    }
    @IBAction func uploadSignBtn2(_ sender: UIButton) {
        SignBtn1.isSelected = false
        SignBtn2.isSelected = true
        performSegue(withIdentifier: AppSegue.DIGITAL_SIGNATURE, sender: nil)
    }
    @IBAction func deleteSignBtn(_ sender: UIButton) {
        let deleteSignAlert = UIAlertController(title: APP_NAME, message: confirmDeleteSignatureImage, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            //Delete Signature
            let parameters : Parameters = ["sign_id" : self.dictUploadedDocumentsData.signId,
                                           "user_id" : UserDefaults.standard.userId()]
            self.apiPostRequest(parameters: parameters, endPoint: EndPoints.DELETE_SIGN)
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        deleteSignAlert.addAction(yesAction)
        deleteSignAlert.addAction(noAction)
        present(deleteSignAlert, animated: true, completion: nil)
    }
    @IBAction func documentListTapped(_ sender: UITapGestureRecognizer) {
        //Uncomment this when we need to upload multiple documents
        //apiGetRequest(parameters: nil, endPoint: EndPoints.DOCUMENT_LIST)
    }
    
    
    @objc func ReloadScreenNotificationAction(_ notification: NSNotification) {
        getUploadedDocumentDetails()
    }

    @objc func NotificationAct(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
           if let selectedItem = userInfo["selectedItem"] as? String {
            let selectedItemIndex = userInfo["selectedIndex"] as! Int
            switch userInfo["itemSelectedFromList"] as? String {
            case AppDropDownLists.DOCUMENTS:
                documentLbl.textColor = UIColor(named: AppColors.BLACK)
                documentLbl.text = selectedItem
                selectedDocumentId = arrDocumentList[selectedItemIndex].documentId
            default:
                print("Unkown List")
            }
            }
        }
    }
    
    @objc func SignNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let selectedImg = userInfo["selectedImg"] as? UIImage {
                signatureImgView.image = selectedImg
                print(selectedImg)
                let parameters : Parameters = ["application_id": CommonObject.sharedInstance.currentReferenceId,
                                               "user_id" : UserDefaults.standard.userId()]
                
                if(SignBtn1.isSelected) {
                   print("Hierer-1")
                    apiPostMultipartRequest(parameters: parameters, endPoint: EndPoints.UPLOAD_SIGN, image: [signatureImgView.image!], isImg: true, isMultipleImg: false, imgParameter: "image", imgExtension: ".jpg")
                }
                else if(SignBtn2.isSelected)
                    
                {
                    print("Hierer-2")
                    apiPostMultipartRequest(parameters: parameters, endPoint: EndPoints.UPLOAD_SIGN, image: [signatureImgView.image!], isImg: true, isMultipleImg: false, imgParameter: "image1", imgExtension: ".jpg")
                    
                }
                else
                {
                    
                }
                
            }
        }
    }
    
    @objc func deleteDocument(sender: UIButton){
        print("del dc ",sender.tag)
        let deleteDocumentAlert = UIAlertController(title: APP_NAME, message: confirmDeleteDocumentImage, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { _ in
            let parameters : Parameters = ["doc_id": self.dictUploadedDocumentsData.documentsUploaded[sender.tag].documentId,
                                           "user_id" : UserDefaults.standard.userId()]
            self.apiPostRequest(parameters: parameters, endPoint: EndPoints.DELETE_UPLOADED_DOCUMENT)
        })
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        deleteDocumentAlert.addAction(yesAction)
        deleteDocumentAlert.addAction(noAction)
        present(deleteDocumentAlert, animated: true, completion: nil)
    }
    @objc func addAccidentImg(sender: UIButton){
        currentImgPickedFor = 0
        self.imagePicker.present(from: accidentPicsCollectionView)
        accidentImgChangedAtRow = sender.tag
    }
    @objc func editAccidentImg(sender: UIButton){
        if totalAccidentImgCells == 1 {
            currentImgPickedFor = 0
            self.imagePicker.present(from: accidentPicsCollectionView)
            accidentImgChangedAtRow = sender.tag
        } else {
            let deleteAccidentImageAlert = UIAlertController(title: APP_NAME, message: confirmDeleteAccidentImage, preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                //Delete Accident Image
                let parameters : Parameters = ["application_id" : CommonObject.sharedInstance.currentReferenceId,
                                               "image_no" : self.arrAccidentImages[sender.tag].indexNumber]
                print(parameters)
                self.apiPostRequest(parameters: parameters, endPoint: EndPoints.DELETE_ACCIDENT_PIC)
            }
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            deleteAccidentImageAlert.addAction(yesAction)
            deleteAccidentImageAlert.addAction(noAction)
            present(deleteAccidentImageAlert, animated: true, completion: nil)
        }
     
    }
    
    @objc func showAccidentImage(sender: UITapGestureRecognizer) {
        if arrAccidentImages.count > 0 {
            displayImageOnFullScreen(imgUrl: arrAccidentImages[sender.view!.tag].imgUrl)
        }
    }
    @objc func showDocumentImage(sender: UITapGestureRecognizer) {
        if dictUploadedDocumentsData.documentsUploaded.count > 0 {
            displayImageOnFullScreen(imgUrl: dictUploadedDocumentsData.documentsUploaded[sender.view!.tag-1].documentImg)
        }
    }
    func didTapDeleteButton(index: Int) {
        print("Delete button tapped in cell at index: \(index)")
        
        let deleteDocumentAlert = UIAlertController(title: APP_NAME, message: confirmDeleteDocumentImage, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { _ in
            let parameters : Parameters = ["doc_id": self.dictUploadedDocumentsData.documentsUploaded[index].documentId,
                                           "user_id" : UserDefaults.standard.userId()]
            self.apiPostRequest(parameters: parameters, endPoint: EndPoints.DELETE_UPLOADED_DOCUMENT)
        })
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        deleteDocumentAlert.addAction(yesAction)
        deleteDocumentAlert.addAction(noAction)
        present(deleteDocumentAlert, animated: true, completion: nil)
    }
   
}
extension UploadDocumentsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == cImageCollectionView) {
            return dictUploadedDocumentsData.documentsUploaded.count
        } else {
            return self.arrAccidentImages.count//totalAccidentImgCells
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == cImageCollectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath as IndexPath) as! ImageCollectionViewCell
            cell.delegate = self
            cell.indexPath = indexPath
            cell.cImageView.kf.setImage(with: URL(string: dictUploadedDocumentsData.documentsUploaded[indexPath.row].documentImg))
            cell.docLabel.text = dictUploadedDocumentsData.documentsUploaded[indexPath.row].document
            return cell
        } else {
            let accidentPicsCell = collectionView.dequeueReusableCell(withReuseIdentifier: AppCvCells.ACCIDENT_PICS, for: indexPath as IndexPath) as! AccidentPicsCvCell
            let addMorePicsCell = collectionView.dequeueReusableCell(withReuseIdentifier: AppCvCells.ADD_MORE_ACCIDENT_PICS, for: indexPath as IndexPath) as! AddMoreAccidentPicsCvCell
            
            let imgUrl = URL(string: arrAccidentImages[indexPath.row].imgUrl)
            accidentPicsCell.imgView.kf.setImage(with: imgUrl, placeholder: nil, options: nil, completionHandler: nil)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showAccidentImage(sender:)))
            accidentPicsCell.imgView.addGestureRecognizer(tapGesture)
            tapGesture.view?.tag = indexPath.row
            
            accidentPicsCell.editImgBtn.tag = indexPath.row
            accidentPicsCell.editImgBtn.addTarget(self, action: #selector(editAccidentImg(sender:)), for: .touchUpInside)
            return accidentPicsCell
            
//            switch isAddMoreAccidentPicCell {
//            case true:
//                if indexPath.row == totalAccidentImgCells - 1 {
//                    addMorePicsCell.addImgBtn.tag = indexPath.row
//                    addMorePicsCell.addImgBtn.addTarget(self, action: #selector(addAccidentImg(sender:)), for: .touchUpInside)
//                    return addMorePicsCell
//                } else {
//                    
//                    if arrAccidentImages.count > 0 {
//                        let imgUrl = URL(string: arrAccidentImages[indexPath.row].imgUrl)
//                        accidentPicsCell.imgView.kf.setImage(with: imgUrl, placeholder: nil, options: nil, completionHandler: nil)
//                        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showAccidentImage(sender:)))
//                        accidentPicsCell.imgView.addGestureRecognizer(tapGesture)
//                        tapGesture.view?.tag = indexPath.row
//                    } else {
//                        accidentPicsCell.imgView.image = .none
//                    }
//                    if totalAccidentImgCells == 1 {
//                        accidentPicsCell.editImgBtn.setImage(UIImage(named: AppImageNames.ADD), for: .normal)
//                    } else {
//                        accidentPicsCell.editImgBtn.setImage(UIImage(named: AppImageNames.DELETE), for: .normal)
//                    }
//                    
//                    accidentPicsCell.editImgBtn.tag = indexPath.row
//                    accidentPicsCell.editImgBtn.addTarget(self, action: #selector(editAccidentImg(sender:)), for: .touchUpInside)
//                    return accidentPicsCell
//                }
//            case false:
//                print(indexPath.row)
//                if arrAccidentImages.count > 0 {
//                    print(arrAccidentImages)
//                    let imgUrl = URL(string: arrAccidentImages[indexPath.row].imgUrl)
//                    accidentPicsCell.imgView.kf.setImage(with: imgUrl, placeholder: nil, options: nil, completionHandler: nil)
//                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showAccidentImage(sender:)))
//                    accidentPicsCell.imgView.addGestureRecognizer(tapGesture)
//                    tapGesture.view?.tag = indexPath.row
//                } else {
//                    accidentPicsCell.imgView.image = .none
//                }
//                if totalAccidentImgCells == 1 {
//                    accidentPicsCell.editImgBtn.setImage(UIImage(named: AppImageNames.ADD), for: .normal)
//                } else {
//                    accidentPicsCell.editImgBtn.setImage(UIImage(named: AppImageNames.DELETE), for: .normal)
//                }
//                accidentPicsCell.editImgBtn.tag = indexPath.row
//                accidentPicsCell.editImgBtn.addTarget(self, action: #selector(editAccidentImg(sender:)), for: .touchUpInside)
//                return accidentPicsCell
//            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == cImageCollectionView) {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return CGSize(width: 310, height: 340)
            } else {
                return CGSize(width: 154, height: 202)
            }
            
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: (collectionView.frame.size.width - 60)/5, height: (collectionView.frame.size.width - 60)/5)
        } else {
            return CGSize(width: (collectionView.frame.size.width-(2*4))/3, height: (collectionView.frame.size.width-(2*4))/3)
        }
    }
     
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        view.layoutSubviews()
//    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isAddMoreAccidentPicCell {
            accidentImageDisplayIndex = indexPath.row
        }
        
        
//        displayImageOnFullScreen(imgUrl: dictUploadedDocumentsData.documentsUploaded[indexPath.row].documentImg)
        var tempArray = [String]()
        for item in dictUploadedDocumentsData.documentsUploaded {
            tempArray.append(item.documentImg)
        }
        
        setAllImages(currentImg: dictUploadedDocumentsData.documentsUploaded[indexPath.row].documentImg, allImages: tempArray, currentIndex: indexPath.row)
    }
}


//extension UploadDocumentsVC : UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if dictUploadedDocumentsData.documentsUploaded.count > 0 {
//            return dictUploadedDocumentsData.documentsUploaded.count + 1
//        } else {
//            return 0
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: AppTblViewCells.DOCUMENTS_HEADER, for: indexPath as IndexPath) as! DocumentsHeaderTblViewCell
//            cell.selectionStyle = .none
//            cell.contentView.layer.borderColor = UIColor(named: AppColors.BLACK)?.cgColor
//            if UIDevice.current.userInterfaceIdiom == .pad {
//                cell.contentView.layer.borderWidth =  1
//            } else {
//                cell.contentView.layer.borderWidth =  0.5
//            }
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: AppTblViewCells.DOCUMENTS, for: indexPath as IndexPath) as! DocumentsTblViewCell
//            cell.selectionStyle = .none
//            cell.contentView.layer.borderColor = UIColor(named: AppColors.BLACK)?.cgColor
//            if UIDevice.current.userInterfaceIdiom == .pad {
//                cell.contentView.layer.borderWidth =  1
//            } else {
//                cell.contentView.layer.borderWidth =  0.5
//            }
//            cell.serialNumberLbl.text = String(indexPath.row)
//            cell.documentTypeLbl.text = dictUploadedDocumentsData.documentsUploaded[indexPath.row-1].document
//            print(dictUploadedDocumentsData.documentsUploaded[indexPath.row-1].documentImg)
//            cell.documentImgView.kf.setImage(with: URL(string: dictUploadedDocumentsData.documentsUploaded[indexPath.row-1].documentImg))
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDocumentImage(sender:)))
//            cell.documentImgView.addGestureRecognizer(tapGesture)
//            tapGesture.view?.tag = indexPath.row
//            cell.deleteBtn.tag = indexPath.row
////            cell.deleteBtn.addTarget(self, action: #selector(deleteDocument(sender:)), for: .touchUpInside)
//            return cell
//        }
//        
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return documentTblViewRowHeight
//    }
//    
//}
extension UploadDocumentsVC: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        if let img = image {
            selectedImageFinal = img
            switch currentImgPickedFor {
            case 0:
                //When accident image is selected
                var imgParameter = String()
                print(arrAccidentImages.count)
                print(accidentImgChangedAtRow)
                print(accidentImagesMissingAtIndex)
                var imageNumber = Int()
                if accidentImagesMissingAtIndex.count > 0 {
                    imageNumber = accidentImagesMissingAtIndex[0]-1
                } else {
                    if arrAccidentImages.count > 0 {
                        imageNumber = arrAccidentImages[accidentImgChangedAtRow-1].indexNumber
                    } else {
                        imageNumber = 0
                    }
                }
                switch imageNumber {
                case 0:
                    imgParameter = "image"
                case 1:
                    imgParameter = "image1"
                case 2:
                    imgParameter = "image2"
                case 3:
                    imgParameter = "image3"
                case 4:
                    imgParameter = "image4"
                default:
                    print("Other Cell")
                }
                print(imgParameter)
                let parameters : Parameters = ["application_id" : CommonObject.sharedInstance.currentReferenceId]
                apiPostMultipartRequest(parameters: parameters, endPoint: EndPoints.UPLOAD_ACCIDENT_PICS, image: [selectedImageFinal], isImg: true, isMultipleImg: false, imgParameter: imgParameter, imgExtension: "jpg")
                
            case 1:
                //When document image is selected
                documentImgView.image = selectedImageFinal
                let parameters : Parameters = ["application_id" : CommonObject.sharedInstance.currentReferenceId,
                                               "document_id": selectedDocumentId,
                                               "user_id" : UserDefaults.standard.userId()]
               
                apiPostMultipartRequest(parameters: parameters, endPoint: EndPoints.UPLOAD_DOCUMENT, image: [selectedImageFinal], isImg: true, isMultipleImg: false, imgParameter: "image", imgExtension: "jpg")
            default:
                print("Unkown Image Picker request")
            }
        }
    }
}

extension UploadDocumentsVC: MultipleImagePickerDelegate {
    func didSelect(images: [UIImage], imgExtension: String) {
        print(images.count)
    }
      
}

extension UploadDocumentsVC : UploadDocumentsVMDelegate {
    func uploadDocumentsAPISuccess(objData: UploadDocumentsModel, strMessage: String, serviceKey: String) {
        print(objData.dictResult)
        dictUploadedDocumentsData = objData.dictResult
        arrAccidentImages.removeAll()//Removing previous Accident Pics Data
        accidentImagesMissingAtIndex.removeAll()
        if !objData.dictResult.accidentPicsImgOne.isEmpty {
            var dict = accidentImagesData()
            dict.indexNumber = 1
            dict.imgUrl = objData.dictResult.accidentPicsImgOne
            arrAccidentImages.append(dict)
        } else {
            accidentImagesMissingAtIndex.append(1)
        }
        if !objData.dictResult.accidentPicsImgTwo.isEmpty {
            var dict = accidentImagesData()
            dict.indexNumber = 2
            dict.imgUrl = objData.dictResult.accidentPicsImgTwo
            arrAccidentImages.append(dict)
        } else {
            accidentImagesMissingAtIndex.append(2)
        }
        if !objData.dictResult.accidentPicsImgThree.isEmpty {
            var dict = accidentImagesData()
            dict.indexNumber = 3
            dict.imgUrl = objData.dictResult.accidentPicsImgThree
            arrAccidentImages.append(dict)
        } else {
            accidentImagesMissingAtIndex.append(3)
        }
        if !objData.dictResult.accidentPicsImgFour.isEmpty {
            var dict = accidentImagesData()
            dict.indexNumber = 4
            dict.imgUrl = objData.dictResult.accidentPicsImgFour
            arrAccidentImages.append(dict)
        } else {
            accidentImagesMissingAtIndex.append(4)
        }
        if !objData.dictResult.accidentPicsImgFive.isEmpty {
            var dict = accidentImagesData()
            dict.indexNumber = 5
            dict.imgUrl = objData.dictResult.accidentPicsImgFive
            arrAccidentImages.append(dict)
        } else {
            accidentImagesMissingAtIndex.append(5)
        }
        if !objData.dictResult.accidentPicsImgSix.isEmpty {
            var dict = accidentImagesData()
            dict.indexNumber = 6
            dict.imgUrl = objData.dictResult.accidentPicsImgSix
            arrAccidentImages.append(dict)
        } else {
            accidentImagesMissingAtIndex.append(6)
        }
        
        switch arrAccidentImages.count {
        case 0,1,2,3,4:
            totalAccidentImgCells = arrAccidentImages.count + 1
        case 5:
            totalAccidentImgCells = 5
        case 6:
            totalAccidentImgCells = 6
        default:
            print("Error")
        }
        switch totalAccidentImgCells {
        case 1:
            numOfAccidentImageCells = 1
        case 2,3,4:
            numOfAccidentImageCells = totalAccidentImgCells - 1
        case 5:
            if arrAccidentImages.count == 5 {
                numOfAccidentImageCells = 5
            } else {
                numOfAccidentImageCells = totalAccidentImgCells - 1
            }
        default:
            print("Error")
        }
        if totalAccidentImgCells > 1 && numOfAccidentImageCells < 5 {
            isAddMoreAccidentPicCell = true
        } else {
            isAddMoreAccidentPicCell = false
        }
        print(arrAccidentImages.count)
        print(totalAccidentImgCells)
        print(numOfAccidentImageCells)
        print(isAddMoreAccidentPicCell)
        accidentPicsCollectionView.reloadData()
        
        setUpViewHeight()
//        documentsTblView.reloadData()
        cImageCollectionView.reloadData()
        
        if !dictUploadedDocumentsData.signImg.isEmpty {
            let signImgUrl = URL(string: dictUploadedDocumentsData.signImg)
            signatureImgView.kf.setImage(with: signImgUrl)
            deleteSignBtn.isHidden = true
        } else {
            signatureImgView.image = .none
            deleteSignBtn.isHidden = true
        }
        print(objData.dictResult)
        
        if !dictUploadedDocumentsData.signImage2.isEmpty {
            let signImgUrl = URL(string: dictUploadedDocumentsData.signImage2)
            signatureImgView2.kf.setImage(with: signImgUrl)
            deleteSignBtn.isHidden = true
        } else {
            signatureImgView2.image = .none
            deleteSignBtn.isHidden = true
        }
        print(objData.dictResult)
    }
    
    func uploadDocumentsAPISuccess(strMessage: String, serviceKey: String) {
        switch serviceKey {
            
        case EndPoints.UPLOAD_ACCIDENT_PICS:
            getUploadedDocumentDetails()
        case EndPoints.DELETE_ACCIDENT_PIC:
            print("aa")
            getUploadedDocumentDetails()
        case EndPoints.UPLOAD_DOCUMENT,EndPoints.UPLOAD_MULTIPLE_DOCS:
            getUploadedDocumentDetails()
            resetDocumentLblAndTable()
//            documentImgView.image = .none
//            documentLbl.text = documentLblUnselectedText
//            documentLbl.textColor = UIColor(named: AppColors.GREY)
        case EndPoints.DELETE_UPLOADED_DOCUMENT:
            getUploadedDocumentDetails()
        case EndPoints.UPLOAD_SIGN:
            getUploadedDocumentDetails()
//            deleteSignBtn.isHidden = false//Move this to get Uploaded documents api success if needed
        case EndPoints.DELETE_SIGN:
            getUploadedDocumentDetails()
//            deleteSignBtn.isHidden = true//Move this to get Uploaded documents api success if needed
        default:
            print("Other Service Key")
        }
        showToast(strMessage: strMessage)
    }
    
    func uploadDocumentsAPISuccess(objData: DocumentListModel, strMessage: String, serviceKey: String) {
        if objData.arrResult.count > 0 {
            selectedDocumentId = objData.arrResult[0].documentId//Getting All Documents doc_id
            documentLbl.text = objData.arrResult[0].documentName
            
            //Uncomment when documents are uploaded one by one. Currently we are sending all documents at once
    //        var temp = [String] ()
    //        for i in 0...objData.arrResult.count-1 {
    //            temp.append(objData.arrResult[i].documentName)
    //        }
    //        arrDocumentList = objData.arrResult
    //        listNameForSelection = AppDropDownLists.DOCUMENTS
            //showPickerViewPopUp(list: temp, listNameForSelection: listNameForSelection, notificationName: .listDocuments)
        }
    }
    
    func uploadDocumentsAPIFailure(strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
        switch serviceKey {
        case EndPoints.UPLOAD_SIGN:
            signatureImgView.image = .none
        case EndPoints.UPLOAD_DOCUMENT:
            resetDocumentLblAndTable()
//            documentImgView.image = .none
//            documentLbl.text = documentLblUnselectedText
//            documentLbl.textColor = UIColor(named: AppColors.GREY)
        default:
            print("Other Service Key")
        }
    }
}

extension UploadDocumentsVC : PreviewVMDelegate {
    func prviewAPISuccess(objData: PreviewModel, strMessage: String, serviceKey: String) {
        switch serviceKey {
        case EndPoints.RA_PREVIEW:
            print("PreviewModelData")
            //print(dictPreview.data)
            //var storyBoard = UIStoryboard()
            let vc = UIViewController()
            var storyBoardName = String()
            var vcid = String()
            if UIDevice.current.userInterfaceIdiom == .pad {
                storyBoardName = AppStoryboards.DASHBOARD
                vcid = AppStoryboardId.WEBVIEW
                
            } else {
                storyBoardName = AppStoryboards.DASHBOARD_PHONE
                vcid = AppStoryboardId.WEBVIEW_PHONE
            }
            let storyboard = UIStoryboard(name: storyBoardName, bundle: .main)
            let webVc = storyboard.instantiateViewController(identifier: vcid) as! WebViewVC
//            alertVc.dictCardDetails = dictUploadedDocumentsData.cardDetails//Sending Card Details to Card Details Screen
            webVc.url = objData.dictResult.data
//            alertVc.modalPresentationStyle = .overFullScreen
            present(webVc, animated: true, completion: nil)
            
        default:
            print("Other Service Key")
        }
    }
    
    func prviewAPISuccess(strMessage: String, serviceKey: String) {
//        switch serviceKey {
//        case EndPoints.RA_PREVIEW:
//            print("PreviewModelData")
//            //print(dictPreview.data)
//            var storyboard = UIStoryboard()
//            if UIDevice.current.userInterfaceIdiom == .pad {
//                storyboard = UIStoryboard(name: AppStoryboards.DASHBOARD, bundle: .main)
//            } else {
//                storyboard = UIStoryboard(name: AppStoryboards.DASHBOARD_PHONE, bundle: .main)
//            }
//            let webVc = storyboard.instantiateViewController(identifier: AppStoryboardId.WEBVIEW) as! WebViewVC
////            alertVc.dictCardDetails = dictUploadedDocumentsData.cardDetails//Sending Card Details to Card Details Screen
//
////            alertVc.modalPresentationStyle = .overFullScreen
//            present(webVc, animated: true, completion: nil)
//
//        default:
//            print("Other Service Key")
//        }
    }

    func prviewAPIFailure(strMessage: String, serviceKey: String) {
        
    }
}
extension UploadDocumentsVC : FinalSubmitVMDelegate {
    func finalSubmitAPISuccess(strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
        CommonObject.sharedInstance.isNewEntry = true
        var storyboardName = String()
        var vcID = String()
        if UIDevice.current.userInterfaceIdiom == .pad {
            vcID = AppStoryboardId.DASHBOARD
            storyboardName = AppStoryboards.DASHBOARD
        } else {
            vcID = AppStoryboardId.DASHBOARD_PHONE
            storyboardName = AppStoryboards.DASHBOARD_PHONE
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        let newbookingEntryVc = storyboard.instantiateViewController(identifier: vcID) as! DashboardVC
        //newbookingEntryVc.newBookingBackDelegate = self
//            alertVc.dictCardDetails = dictUploadedDocumentsData.cardDetails//Sending Card Details to Card Details Screen
//            alertVc.modalPresentationStyle = .overFullScreen
        present(newbookingEntryVc, animated: true, completion: nil)
    }
    
    func finalSubmitAPISuccess(objData: FinalSubmitModelData, strMessage: String, serviceKey: String) {
        switch serviceKey {
        case EndPoints.FINAL_SUBMIT:
            print("FinalSubmitViewModel")
        default:
            print("Other Service Key")
        }
    }
    
    func finalSubmitAPIFailure(strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
    }
    
}
