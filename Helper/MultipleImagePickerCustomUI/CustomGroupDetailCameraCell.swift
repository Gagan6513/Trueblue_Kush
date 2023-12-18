//
//  CustomGroupDetailCameraCell.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 17/12/21.
//

import Foundation
import UIKit
import DKImagePickerController

class CustomGroupDetailCameraCell: DKAssetGroupDetailBaseCell {
    
    class override func cellReuseIdentifier() -> String {
        return "CustomGroupDetailCameraCell"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let cameraLabel = UILabel(frame: frame)
        cameraLabel.text = "Camera"
        cameraLabel.textAlignment = .center
        cameraLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.addSubview(cameraLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
