//
//  AccidentManagementFourthVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 17/01/24.
//

import UIKit
import Applio
import DKImagePickerController
import Alamofire

class AccidentManagementFourthVC: UIViewController {

    @IBOutlet weak var btnPreview: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var arrImages = [uploadedImagesModel]()
    var accidentData: AccidentMaintenance?
    var isFromView = false
    
    var applicationId: String? {
        didSet {
            if let _ = self.applicationId {
                self.getUploadedDoc()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnPreview.isHidden = true
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerNib(for: "ImagesCVC")
        
        self.setupNotification()
        self.btnSubmit.isHidden = self.isFromView
    }
    
    
    func setupNotification() {
        NotificationCenter.default.addObserver(forName: .AccidentDetails, object: nil, queue: nil, using: { [weak self] noti in
            guard let self else { return }
            
            if let applicationId = (noti.userInfo as? NSDictionary)?.value(forKey: "ApplicationId") as? String {
                self.applicationId = applicationId
            }
        })
    }
    
    @IBAction func btnUpload(_ sender: UIButton) {
        if !isFromView {
            self.openPicker()
        }
    }
    @IBAction func btnPreview(_ sender: UIButton) {
        if self.arrImages.count != 0 {
            var tempArray = [String]()
            for item in arrImages {
                tempArray.append(item.image_url ?? "")
            }
            setAllImages(currentImg: arrImages.first?.image_url ?? "", allImages: tempArray, currentIndex: 0)
        } else {
            showAlert(title: "Error!", messsage: "Please add documnet images.")
        }
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        if !isFromView {
            showAlertWithAction(title: alert_title, messsage: "Your application has been submitted", isOkClicked: {
                let dict: [String: Any] = ["currentIndex" : 4 ]
                NotificationCenter.default.post(name: .AccidentDetails, object: nil, userInfo: dict)
            })
        }
    }
    
    func openPicker() {
        
        var arrNewImages = [UIImage]()
        
        let multipleImgPickerController = DKImagePickerController()
        multipleImgPickerController.maxSelectableCount = 3
        multipleImgPickerController.modalPresentationStyle = .fullScreen
        multipleImgPickerController.assetType = .allPhotos
        multipleImgPickerController.showsCancelButton = true
        multipleImgPickerController.UIDelegate = CustomUIDelegate()
        multipleImgPickerController.didSelectAssets = { (assets: [DKAsset]) in
            for asset in assets {
                asset.fetchOriginalImage(completeBlock: {image,info in
                    //Gettimg images selected
                    guard let img = image else { return }
                    arrNewImages.append(img)
                    if arrNewImages.count == assets.count {
                        self.uploadImages(arrImages: arrNewImages)
                    }
                })
            }
        }
        self.present(multipleImgPickerController, animated: true) {}
    }
    
}

extension AccidentManagementFourthVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCVC", for: indexPath) as? ImagesCVC else { return UICollectionViewCell() }
        cell.setupDetails(data: self.arrImages[indexPath.row])
        cell.deleteButtonClicked = { [weak self] in
            guard let self else { return }
            self.deleteImages(data: self.arrImages[indexPath.row])
        }
        cell.btnDelete.isHidden = self.isFromView
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 30) / 4, height: (collectionView.frame.width - 30) / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var tempArray = [String]()
        for item in arrImages {
            tempArray.append(item.image_url ?? "")
        }
        setAllImages(currentImg: arrImages[indexPath.row].image_url ?? "", allImages: tempArray, currentIndex: indexPath.row)
    }
    
}

extension AccidentManagementFourthVC {
    
    func uploadImages(arrImages: [UIImage]) {
        var parameters: Parameters = [:]
        parameters["application_id"] = "IV000" + (self.applicationId ?? "")
        parameters["document_id"] = 50
        CommonObject().showProgress()
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.UPLOAD_MULTIPLE_DOCS)!
        webService.method = .post
        
        webService.parameters = parameters
        
        var profileImageData: [Dictionary<String, Any>] = []
        var img_data = [Data]()
        arrImages.forEach({ img in
            
            if let data = img.jpeg(.medium) {
                img_data.append(data)
                #if DEBUG
                debugLog("actual size imagess = \(img.getSizeIn(.megabyte)) MB")
                debugLog("after compression size = \(data.getSizeIn(.megabyte)) MB")
                #endif
            }
        })
        
        profileImageData.append(["title": "image", "image": img_data])
        
        /* API CALLS */
        WebService.shared.performMultipartWebService(endPoint: API_URL.UPLOAD_MULTIPLE_DOCS, parameters: parameters, imageData: profileImageData) { [weak self] responseData, error in
            guard let self else { return }
            
            CommonObject().stopProgress()
            
            if let error {
                /* API ERROR */
                showAlert(title: "Error!", messsage: "\(error)")
                return
            }
            
            /* CONVERT JSON DATA TO MODEL */
            if let data = responseData?.convertData(DocModel.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? DocModel {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    self.getUploadedDoc()
                }
            }
            
        }
    }
    
    
    func deleteImages(data: uploadedImagesModel) {
        
        
        var parameters: Parameters = [:]
        parameters["doc_id"] = data.doc_id
        parameters["user_id"] = UserDefaults.standard.userId()
        CommonObject().showProgress()
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.DELETE_UPLOADED_DOCUMENT)!
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
            if let data = responseData?.convertData(DocModel.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? DocModel {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    self.getUploadedDoc()
                }
            }
            
        }
    }
    
    func getUploadedDoc() {
        CommonObject().showProgress()
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.GET_UPLOADED_DOCUMENTS_TAB_DETAILS)!
        webService.method = .post
        webService.parameters = ["application_id": ("IV000" + (self.applicationId ?? ""))]
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
            if let data = responseData?.convertData(DocListModel.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? DocListModel {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    
                    self.arrImages = data.data?.document_details ?? []
                    
                    self.btnPreview.isHidden = self.arrImages.count == 0 
                    
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
}
