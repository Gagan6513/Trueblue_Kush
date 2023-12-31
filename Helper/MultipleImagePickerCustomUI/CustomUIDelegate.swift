//
//  CustomMultipleImageDelegate.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 17/12/21.
//

import Foundation
import UIKit
import DKImagePickerController

open class CustomUIDelegate: DKImagePickerControllerBaseUIDelegate {
    
    lazy var footer: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolbar.isTranslucent = false
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(customView: self.createDoneButtonIfNeeded()),
        ]
        self.updateDoneButtonTitle(self.createDoneButtonIfNeeded())
        
        return toolbar
    }()
  
    lazy var header: UIToolbar = {
      let header = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
      header.barTintColor = UIColor.yellow
      self.updateDoneButtonTitle(self.createDoneButtonIfNeeded())
      return header
    }()
    
    override open func createDoneButtonIfNeeded() -> UIButton {
        if self.doneButton == nil {
            let button = UIButton(type: .custom)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//            button.setTitleColor(UIColor(red: 85 / 255.0, green: 184 / 255.0, blue: 44 / 255.0, alpha: 1.0), for: .normal)
//            button.setTitleColor(UIColor(red: 85 / 255.0, green: 184 / 255.0, blue: 44 / 255.0, alpha: 0.4), for: .disabled)
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(.darkGray, for: .disabled)
//            button.backgroundColor = UIColor(named: AppColors.BLUE)
//            button.layer.cornerRadius = button.frame.height/2
            button.addTarget(self.imagePickerController, action: #selector(DKImagePickerController.done), for: .touchUpInside)
            self.doneButton = button
        }
        
        return self.doneButton!
    }
    
    override open func prepareLayout(_ imagePickerController: DKImagePickerController, vc: UIViewController) {
        self.imagePickerController = imagePickerController
    }
    
    override open func imagePickerController(_ imagePickerController: DKImagePickerController,
                                               showsCancelButtonForVC vc: UIViewController) {
//        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
//                                                               target: imagePickerController,
//                                                               action: #selector(imagePickerController.dismiss as () -> Void))
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                               target: imagePickerController,
                                                               action: #selector(imagePickerController.dismiss as () -> Void))
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                               target: imagePickerController,
                                                               action: #selector(imagePickerController.done as () -> Void))
        vc.navigationItem.leftBarButtonItem?.tintColor = .white
        vc.navigationItem.rightBarButtonItem?.tintColor = .white
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]//it is necessary to set the title text attribute to "white" as the title text defaulted to black if this attribute was not specified
            appearance.backgroundColor = UIColor(named: AppColors.BLUE)
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    override open func imagePickerController(_ imagePickerController: DKImagePickerController,
                                               hidesCancelButtonForVC vc: UIViewController) {
        vc.navigationItem.rightBarButtonItem = nil
    }
    
    override open func imagePickerControllerHeaderView(_ imagePickerController: DKImagePickerController) -> UIView? {
        return self.header
    }
  
    override open func imagePickerControllerFooterView(_ imagePickerController: DKImagePickerController) -> UIView? {
      return self.footer
    }
    
    override open func updateDoneButtonTitle(_ button: UIButton) {
        if self.imagePickerController.selectedAssets.count > 0 {
            button.setTitle(String(format: "Send(%d)", self.imagePickerController.selectedAssets.count), for: .normal)
            button.isEnabled = true
        } else {
            button.setTitle("Send", for: .normal)
            button.isEnabled = false
        }
        
        button.sizeToFit()
    }
    
    open override func imagePickerControllerCollectionImageCell() -> DKAssetGroupDetailBaseCell.Type {
        return CustomGroupDetailImageCell.self
    }
    
    open override func imagePickerControllerCollectionCameraCell() -> DKAssetGroupDetailBaseCell.Type {
        return CustomGroupDetailCameraCell.self
    }

}
