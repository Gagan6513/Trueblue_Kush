//
//  MultiSelectionImgPicker.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 24/09/21.
//

import Foundation
import UIKit
import Photos
import DKImagePickerController
public protocol MultipleImagePickerDelegate: AnyObject {
    func didSelect(images: [UIImage],imgExtension: String)
}

open class MultipleImgPicker: NSObject {
    private weak var presentationController: UIViewController?
    private weak var delegate: MultipleImagePickerDelegate?
    var maxSelectableCount = Int()
    public init(presentationController: UIViewController,delegate: MultipleImagePickerDelegate) {

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate//presentationController.self as? MultipleImagePickerDelegate
//        self.pickerController.mediaTypes = []//["public.movie"]//["public.image"]
    }

//    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
//        guard UIImagePickerController.isSourceTypeAvailable(type) else {
//            return nil
//        }
//
//        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
//            self.pickerController.sourceType = type
//            self.presentationController?.present(self.pickerController, animated: true)
//        }
//    }
    
    func checkPermissions() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // Request read-write access to the user's photo library.
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    switch status {
                    case .notDetermined:
                        // The user hasn't determined this app's access.
                        print("Not Determined")
                        self.showAlertToOpenSettings(type: 1)
                    case .restricted:
                        // The system restricted this app's access.
                        print("Resticted")
                        self.showAlertToOpenSettings(type: 1)
                    case .denied:
                        // The user explicitly denied this app's access.
                        print("Denied")
                        self.showAlertToOpenSettings(type: 1)
                    case .authorized:
                        // The user authorized this app to access Photos data.
                        print("authorised")
                        DispatchQueue.main.async {
                            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                self.openPhotoPicker()
                                return
                                //                            //Camera
                                //                            switch AVCaptureDevice.authorizationStatus(for: .video) {
                                //                            case .authorized:
                                //                                self.openPhotoPicker()
                                //                            case .denied,.notDetermined,.restricted:
                                //                                AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                                //                                    if response {
                                //                                        //access granted
                                //                                        self.openPhotoPicker()
                                //                                    } else {
                                //                                        self.showAlertToOpenSettings(type: 2)
                                //                                    }
                                //                                }
                                //                            @unknown default:
                                //                                self.showAlertToOpenSettings(type: 2)
                                //                            }
                            } else {
                                self.openPhotoPicker()
                            }
                        }
                    case .limited:
                        // The user authorized this app for limited Photos access.
                        print("Limited")
                        DispatchQueue.main.async {
                            self.showLimitedLibraryAlert()
                        }
                        //                self.openLimitedLibrary()
                    @unknown default:
                        fatalError()
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    
    func showAlertToOpenSettings(type: Int) {
        DispatchQueue.main.async {
            var title = String()
            if type == 1 {
                title = noCameraAccess
            } else if type == 2 {
                title = noGalleryAccess
            }
            // Create Alert
            let alert = UIAlertController(title: title, message: openSettingsForPermission, preferredStyle: .alert)
            
            // Add "OK" Button to alert, pressing it will bring you to the settings app
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            // Show the alert with animation
            self.presentationController!.present(alert, animated: true)
        }
    }
    
    func openPhotoPicker() {
        var selectedImages = [UIImage]()
        let multipleImgPickerController = DKImagePickerController()
        multipleImgPickerController.maxSelectableCount = self.maxSelectableCount
        multipleImgPickerController.modalPresentationStyle = .currentContext
        multipleImgPickerController.showsCancelButton = true
        multipleImgPickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets)
            for asset in assets {
                asset.fetchOriginalImage(completeBlock: {image,info in
                    //Gettimg images selected
                    selectedImages.append(image!)
                    print(image?.imageData)
                    if selectedImages.count == assets.count {
                        self.delegate?.didSelect(images: selectedImages, imgExtension: "jpg")
                        
                    }
                })
            }
        }
        presentationController?.present(multipleImgPickerController, animated: true) {}
    }
    
    func showLimitedLibraryAlert() {
        // Create Alert
        let alert = UIAlertController(title: limitedAccess, message: openSettingsForPermission, preferredStyle: .alert)
        
        // Add "OK" Button to alert, pressing it will bring you to the settings app
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        // Show the alert with animation
        self.presentationController!.present(alert, animated: true)
    }

    func present(maxSelectableCount: Int) {
        self.maxSelectableCount = maxSelectableCount
        checkPermissions()
    }
    
}


////d
//import AVFoundation
//import UIKit
//import Photos
//import DKImagePickerController
//public protocol MultipleImagePickerDelegate: AnyObject {
//    func didSelect(images: [UIImage]?)
//}
//class MultipleImgPicker : NSObject {
//    private let pickerController: DKImagePickerController
//    private weak var presentationController: UIViewController?
//    private weak var delegate: MultipleImagePickerDelegate?
//    private var maxSelectableCount = Int()
//    private var imagesSelected = [UIImage]()
//    public init(presentationController: UIViewController, delegate: MultipleImagePickerDelegate,maxSelection: Int) {
//        self.pickerController = DKImagePickerController()
//
//        super.init()
//        self.maxSelectableCount = maxSelection
//        self.presentationController = presentationController
//        self.delegate = delegate
//
////        self.pickerController.delegate = self
////        self.pickerController.allowsEditing = true
////        self.pickerController.modalPresentationStyle = .overFullScreen
////        self.pickerController.mediaTypes = ["public.image"]
//    }
//    func askForAccess() {
//        //Camera
//            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
//                if response {
//                    //access granted
//                    DispatchQueue.main.async {
//                      //perform Operation
//                        self.showImgPicker()
//                    }
//                } else {
//                    self.showAlertForPermissions()
//                }
//            }
//
//            //Photos
//            let photos = PHPhotoLibrary.authorizationStatus()
//            if photos == .notDetermined {
//                PHPhotoLibrary.requestAuthorization({status in
//                    if status == .authorized{
//                        self.showImgPicker()
//                    } else {
//                        self.showAlertForPermissions()
//                    }
//                })
//            }
//      }
//
//    func showAlertForPermissions() {
//        // Create Alert
//        let alert = UIAlertController(title: APP_NAME, message: "Camera access is absolutely necessary to use this app", preferredStyle: .alert)
//
//        // Add "OK" Button to alert, pressing it will bring you to the settings app
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
//            return
//        }))
//        // Show the alert with animation
//        presentationController?.present(alert, animated: true)
//    }
//
//    func showImgPicker() {
//        let multipleImgPickerController = DKImagePickerController()
//        multipleImgPickerController.maxSelectableCount = maxSelectableCount
//        multipleImgPickerController.modalPresentationStyle = .currentContext
//        multipleImgPickerController.showsCancelButton = true
//        multipleImgPickerController.assetType = .allPhotos
//        multipleImgPickerController.didCancel = {
//            return
//        }
//        multipleImgPickerController.didSelectAssets = { (assets: [DKAsset]) in
//            print("didSelectAssets")
//            print(assets)
////            self.picturesForUpload.removeAll()//Removing Previous values
//            for asset in assets {
//                asset.fetchOriginalImage(completeBlock: {image,info in
//                    //Gettimg images selected
//                    self.imagesSelected.append(image!)
//                    if asset == assets[assets.count-1] {
//                        self.delegate?.didSelect(images: self.imagesSelected)
//                    }
//                })
//            }
//        }
//        presentationController?.present(multipleImgPickerController, animated: true) //{}
//    }
//}
