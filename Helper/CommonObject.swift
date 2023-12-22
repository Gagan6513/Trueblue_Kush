//
//  CommonObject.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 18/08/21.
//

import Foundation
import SVProgressHUD
class CommonObject: NSObject {
    
    static let sharedInstance = CommonObject()
    var currentReferenceId = "0"
    var vehicleId = String()
    var deliveryBy = String()
    var clientEmail = String()
    var isNewEntry = Bool()
    var isDataChangedInCurrentTab = false // To store if there is any chamge in input values
    
    func showProgress() {
        SVProgressHUD.setDefaultMaskType(.black) // Disabling user interaction
        SVProgressHUD.resetOffsetFromCenter()
        SVProgressHUD.show(withStatus: "Loading...")
    }

    func stopProgress() {
        SVProgressHUD.dismiss()
    }
    
}
