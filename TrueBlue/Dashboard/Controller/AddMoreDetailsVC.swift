//
//  AddMoreDetailsVC.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 06/03/23.
//

import UIKit
import Alamofire



class AddMoreDetailsVC: UIViewController {
//    func dismissVC() {
//        self.dismiss(animated: true,completion: nil)
//    }
    
    var appID = String()
    var vechicleId = String()
    var dateInValue = String()
    var mileageInValue = String()
    var selectedDeliveredBy = String()
    var timeInValue = String()
    var picturesForUpload = [UIImage]()
    
    @IBOutlet weak var liabilityStatusTxtFld: UITextField!
    @IBOutlet weak var otherTxtFld: UITextField!
    @IBOutlet weak var outherTxtFld: UITextField!
    @IBOutlet weak var dateOfSettlementTxtFld: UITextField!
    @IBOutlet weak var repairerNameTxtFld: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.DateNotificationAction(_:)), name: .dateOfSettlement, object: nil)
    }
    
    @IBAction func submitBtn(_ sender: UIButton) {
//        if repairerNameTxtFld.text == "" {
//            showToast(strMessage: repairerNameRequired)
//            return
//        }
//        if dateOfSettlementTxtFld.text == "" {
//            showToast(strMessage: dateOfSettlementRequired)
//            return
//        }
//
//        if outherTxtFld.text == "" {
//            showToast(strMessage: otherRequired)
//        }
        
        callAPI()
    }
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func datePikerBtn(_ sender: UIButton) {
        showDatePickerPopUp(textField: dateOfSettlementTxtFld, notificationName: .dateOfSettlement)
    }
    @objc func DateNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
           if let selectedDate = userInfo["selectedDate"] as? String {
            let selectedTextField = userInfo["dateTextField"] as! UITextField
            switch selectedTextField {
            case dateOfSettlementTxtFld:
                dateOfSettlementTxtFld.text = selectedDate
            default:
                print("Unkown Date Textfield")
            }
            }
        }
    }
    func apiPostMultipartRequest(parameters: Parameters,endPoint: String,image: [UIImage],isImg: Bool,isMultipleImg: Bool,imgParameter: String,imgExtension: String){
        CommonObject.sharedInstance.showProgress()
        let obj = ReturnVehicleViewModel()
        obj.delegate = self
        obj.postMultipartReturnVehicle(currentController: self, parameters: parameters, endPoint: endPoint, img: image, isImage: isImg, isMultipleImg: isMultipleImg, imgParameter: imgParameter, imgExtension: imgExtension)
    }
    
    func apiPostRequest(parameters: Parameters,endPoint: String){
        CommonObject.sharedInstance.showProgress()
        let obj = ReturnVehicleViewModel()
        obj.delegate = self
        obj.postReturnVehicle(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    
}

extension AddMoreDetailsVC {
    func callAPI() {
        
        let parameters : Parameters = ["app_id" : appID,
                                       "vehicle_id" : vechicleId ,
                                       "date_in" : dateInValue,
                                       "Mileage_in" : mileageInValue,
                                       "time_in" : timeInValue,//timeInTxtFld.text!,
                                       "collection_by": selectedDeliveredBy ,
                                       "user_id" : UserDefaults.standard.userId(),
                                       "returned_repairer_name": repairerNameTxtFld.text ?? "",
                                       "dateofsattlement": dateOfSettlementTxtFld.text ?? "",
                                       "return_remarks" : outherTxtFld.text ?? "",
                                       "liability_status" : liabilityStatusTxtFld.text ?? ""]
        
        var isImg = false
        if picturesForUpload.count > 0 {
            isImg = true
        }
        
        print(parameters)
        apiPostMultipartRequest(parameters: parameters, endPoint: EndPoints.RETURN_VEHICLE, image: picturesForUpload, isImg: isImg, isMultipleImg: true, imgParameter: "file_upload", imgExtension: "jpg")
        apiPostRequest(parameters: parameters, endPoint: EndPoints.RETURN_VEHICLE)
    
    }
}

extension AddMoreDetailsVC : ReturnVehicleVMDelegate {
    func returnVehicleAPISuccess(objData: ReturnUploadedDocsModel, strMessage: String) {
        
    }
    
    
    func returnVehicleAPISuccess(objData: ReturnVehicleModel, strMessage: String) {
        print(objData)
        showToast(strMessage: strMessage)
        let presentingViewController: UIViewController! = self.presentingViewController
        self.dismiss(animated: true) {
            // go back to MainMenuView as the eyes of the user
            presentingViewController.dismiss(animated: false, completion: {
                
            })
        }
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
//            let presentingViewController: UIViewController! = self.presentingViewController
//            self.dismiss(animated: true) {
//                // go back to MainMenuView as the eyes of the user
//                presentingViewController.dismiss(animated: false, completion: {
//
//                })
//            }
//        })
    }
    
    
    func returnVehicleAPISuccess(objData: HiredVehicleDropdownListModel, strMessage: String) {
        //
    }
    
    func returnVehicleAPIFailure(strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
    }
}
extension AddMoreDetailsVC : UITextViewDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var isAllowed = true
        switch textField {
        case dateOfSettlementTxtFld:
            isAllowed = textField.validateDateTyped(shouldChangeCharactersInRange: range, replacementString: string)
        default:
            print("TextField without restriction")
        }
        return isAllowed
    }
}
extension AddMoreDetailsVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateOfSettlementTxtFld {
            showDatePickerPopUp(textField: dateOfSettlementTxtFld, notificationName: .dateOfSettlement)
        }
        //showDatePickerPopUp(textField: dateInTxtFld, notificationName: .dateReturnVehicle)
    }
}
