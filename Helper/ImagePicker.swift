//
//  ImagePicker.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 26/08/21.
//

import Foundation
import UIKit
import Photos

public protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?)
}

open class ImagePicker: NSObject {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?

    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.modalPresentationStyle = .overFullScreen
        self.pickerController.mediaTypes = ["public.image"]
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            if type == .camera {
                checkCameraPermissions()
            } else if type == .photoLibrary {
                checkPhotoLibraryPermissions()
            }

//            self.pickerController.sourceType = type
//            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    func checkPhotoLibraryPermissions() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // Request read-write access to the user's photo library.
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    switch status {
                    case .notDetermined:
                        // The user hasn't determined this app's access.
                        print("Not Determined")
                        self.showAlertToOpenSettings(type: 2)
                    case .restricted:
                        // The system restricted this app's access.
                        print("Resticted")
                        self.showAlertToOpenSettings(type: 2)
                    case .denied:
                        // The user explicitly denied this app's access.
                        print("Denied")
                        self.showAlertToOpenSettings(type: 2)
                    case .authorized:
                        // The user authorized this app to access Photos data.
                        print("authorised")
                        DispatchQueue.main.async {
                            self.pickerController.sourceType = .photoLibrary
                            self.pickerController.allowsEditing = false
                            self.presentationController?.present(self.pickerController, animated: true)
                        }
                    case .limited:
                        print("Limited")
                        DispatchQueue.main.async {
                            self.showLimitedLibraryAlert()
                        }
                    @unknown default:
                        fatalError()
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            DispatchQueue.main.async {
                self.pickerController.sourceType = .camera
                self.presentationController?.present(self.pickerController, animated: true)
            }
        case .denied,.notDetermined,.restricted:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                if response {
                    //access granted
                    DispatchQueue.main.async {
                        self.pickerController.sourceType = .camera
                        self.presentationController?.present(self.pickerController, animated: true)
                    }
                } else {
                    self.showAlertToOpenSettings(type: 2)
                }
            }
        @unknown default:
            self.showAlertToOpenSettings(type: 2)
        }
    }
    func checkPermissions() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // Request read-write access to the user's photo library.
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    switch status {
                    case .notDetermined:
                        // The user hasn't determined this app's access.
                        print("Not Determined")
                        self.showAlertToOpenSettings(type: 2)
                    case .restricted:
                        // The system restricted this app's access.
                        print("Resticted")
                        self.showAlertToOpenSettings(type: 2)
                    case .denied:
                        // The user explicitly denied this app's access.
                        print("Denied")
                        self.showAlertToOpenSettings(type: 2)
                    case .authorized:
                        // The user authorized this app to access Photos data.
                        print("authorised")
                        DispatchQueue.main.async {
                            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                //Camera
                                self.openPhotoOptions()
                                return
                                //                            switch AVCaptureDevice.authorizationStatus(for: .video) {
                                //                            case .authorized:
                                //                                self.openPhotoOptions()
                                //                            case .denied,.notDetermined,.restricted:
                                //                                AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                                //                                    if response {
                                //                                        //access granted
                                //                                        self.openPhotoOptions()
                                //                                    } else {
                                //                                        self.showAlertToOpenSettings(type: 2)
                                //                                    }
                                //                                }
                                //                            @unknown default:
                                //                                self.showAlertToOpenSettings(type: 2)
                                //                            }
                            } else {
                                self.openPhotoOptions()
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

    func openPhotoOptions() {
        let alertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .alert)

        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.presentationController?.present(alertController, animated: true)
    }

    public func present(from sourceView: UIView) {
        openPhotoOptions()

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

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)

        self.delegate?.didSelect(image: image)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
    
}

extension ImagePicker: UINavigationControllerDelegate {

}
