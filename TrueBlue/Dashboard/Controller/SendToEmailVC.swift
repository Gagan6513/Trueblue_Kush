//
//  SendToEmailVC.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 03/03/23.
//

import UIKit

class SendToEmailVC: UIViewController {
    
    @IBOutlet weak var customerEmailBtn: UIButton!
    @IBOutlet weak var trueBlueEmailBtn: UIButton!
    @IBOutlet weak var customerEmailTxtFld: UITextField!
    @IBOutlet weak var trueBlueEmailTxtFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        trueBlueEmailTxtFld.text = "admin@mytbam.com.au"
        customerEmailTxtFld.text = "\(CommonObject.sharedInstance.clientEmail)"
    }
    
    @IBAction func dismissBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    @IBAction func submitBtn(_ sender: UIButton) {
        if !(customerEmailTxtFld.text ??  "").trimmingCharacters(in: .whitespaces).isEmpty {
            if !(customerEmailTxtFld.text ??  "").isValidEmailAddress() {
                showToast(strMessage: validEmailRequired)
                return
            }
            
        }
        if !(trueBlueEmailTxtFld.text ??  "").trimmingCharacters(in: .whitespaces).isEmpty {
            if !(trueBlueEmailTxtFld.text ??  "").isValidEmailAddress() {
                showToast(strMessage: validEmailRequired)
                return
            }
        }
        if !trueBlueEmailBtn.isSelected && !customerEmailBtn.isSelected {
            showToast(strMessage: selectTheEmail)
            return
        }
        
        var parameters = [String : Any]()
        if trueBlueEmailBtn.isSelected == true {
            parameters["admin_email"] = trueBlueEmailTxtFld.text
        } else {
            parameters["admin_email"] = ""
        }
        if customerEmailBtn.isSelected {
            parameters["client_email"] = customerEmailTxtFld.text
        } else {
            parameters["client_email"] = ""
        }
        parameters["application_id"] = CommonObject.sharedInstance.currentReferenceId
        parameters["vehicle_id"] = CommonObject.sharedInstance.vehicleId
        
        let endPoint = EndPoints.MAIL_INVOICE
        
        let obj = SendToEmailViewModel()
        obj.delegate = self
        obj.sendToEmailAPI(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    
    @IBAction func customarEmailBtn(_ sender: UIButton) {
        if customerEmailBtn.isSelected {
            customerEmailBtn.isSelected = false
            customerEmailBtn.setImage(.checkUnselected, for: .normal)
        } else {
            customerEmailBtn.isSelected = true
            customerEmailBtn.setImage(.checkSelected, for: .normal)
        }
    }
    @IBAction func trueBlueEmailTxtFld(_ sender: UIButton) {
        if trueBlueEmailBtn.isSelected {
            trueBlueEmailBtn.isSelected = false
            trueBlueEmailBtn.setImage(.checkUnselected, for: .normal)
        } else {
            trueBlueEmailBtn.isSelected = true
            trueBlueEmailBtn.setImage(.checkSelected, for: .normal)
        }
    }
}
extension SendToEmailVC : SendToEmailViewVMDelegate {
    func sendToEmailAPISuccess(strMessage: String, serviceKey: String) {
        switch serviceKey {
        case EndPoints.MAIL_INVOICE:
            showToast(strMessage: strMessage)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.dismiss(animated: true)
            }
        default:
            print("Other Service Key")
        }
    }
    
    func sendToEmailAPISuccess(objData: SendToEmailModelData, strMessage: String, serviceKey: String) {
        switch serviceKey {
        case EndPoints.MAIL_INVOICE:
           showToast(strMessage: strMessage)
        default:
            print("Other Service Key")
        }
    }
    
    func sendToEmailAPIFailure(strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
    }
}
