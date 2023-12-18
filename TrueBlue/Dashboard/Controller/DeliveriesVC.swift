//
//  DeliveriesVC.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 18/08/21.
//

import UIKit
import Alamofire
import DZNEmptyDataSet

class DeliveriesVC: UIViewController {
    
    @IBOutlet weak var tblDeliveries: UITableView!
    @IBOutlet weak var dateFromTxtFld: UITextField!
    @IBOutlet weak var dateToTxtFld: UITextField!
    var arrDeliveries = [DeliveriesModelData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(self.DateNotificationAction(_:)), name: .dateDeliveries, object: nil)
        // Do any additional setup after loading the view.
        
        //tblDeliveries.isHidden = true
        tblDeliveries.emptyDataSetSource = self;
        tblDeliveries.emptyDataSetDelegate = self;
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
//        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFromTxtFld.text = dateFormatter.string(from: currentDate)
        dateToTxtFld.text = dateFromTxtFld.text
        dateFromTxtFld.keyboardType = .numberPad
        dateToTxtFld.keyboardType = .numberPad
        apiDeliveries()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)//Removes all notifications being observed
    }

    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func dateFromCalenderBtnTapped(_ sender: UIButton) {
        showDatePickerPopUp(textField: dateFromTxtFld, notificationName: .dateDeliveries)
    }
    
    @IBAction func dateToCalenderBtnTapped(_ sender: UIButton) {
        showDatePickerPopUp(textField: dateToTxtFld, notificationName: .dateDeliveries)
    }
    @IBAction func submitBtn(_ sender: Any) {
        if dateFromTxtFld.text == "" {
            showToast(strMessage: dateFromRequired)
            return
        }
        if dateToTxtFld.text == "" {
            showToast(strMessage: dateToRequired)
            return
        }
        apiDeliveries()
    }
    
    func apiDeliveries() {
        
        let parameters : Parameters = ["date_from" : dateFromTxtFld.text!,
                                       "date_to" : dateToTxtFld.text!]
        apiPostDeliveryList(parameters: parameters, endPoint: EndPoints.DELIVERYLIST)
    }
    
    func apiPostDeliveryList(parameters: Parameters,endPoint: String) {
        CommonObject.sharedInstance.showProgress()
        let obj = DeliveriesViewModel()
        obj.delegate = self
        obj.postDeliveries(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    
    @objc func DateNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
           if let selectedDate = userInfo["selectedDate"] as? String {
            let selectedTextField = userInfo["dateTextField"] as! UITextField
            switch selectedTextField {
            case dateFromTxtFld:
                dateFromTxtFld.text = selectedDate
            case dateToTxtFld:
                dateToTxtFld.text = selectedDate
            default:
                print("Unkown Date Textfield")
            }
            }
        }
    }
    
    @objc func applicationIDLblTapped(_ sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag, tag > 0 else {
            return
        }
        CommonObject.sharedInstance.isNewEntry = false
        CommonObject.sharedInstance.currentReferenceId = arrDeliveries[tag-1].applicationId
        var storyboard = UIStoryboard()
        var vc = UIViewController()
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboard = UIStoryboard(name: AppStoryboards.DASHBOARD, bundle: .main)
            vc = storyboard.instantiateViewController(identifier: AppStoryboardId.NEW_BOOKING_ENTRY)
        } else {
            storyboard = UIStoryboard(name: AppStoryboards.DASHBOARD_PHONE, bundle: .main)
            vc = storyboard.instantiateViewController(identifier: AppStoryboardId.NEW_BOOKIN_ENTRY_PHONE)
        }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }

}
extension DeliveriesVC : UITextFieldDelegate {
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        var isKeyboard = true
//        switch textField {
//        case dateFromTxtFld,dateToTxtFld:
//            isKeyboard = false
//            showDatePickerPopUp(textField: textField, notificationName: .dateDeliveries)
//        default:
//            print("Other TextField")
//        }
//        return isKeyboard
//    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case dateFromTxtFld,dateToTxtFld:
            return textField.validateDateTyped(shouldChangeCharactersInRange: range, replacementString: string)
        default:
            return true
        }
    }
}

extension DeliveriesVC: DeliveriesVMDelegate {
    
    func deliveriesAPISuccess(objData: DeliveriesModel, strMessage: String) {
        if objData.arrResult.count > 0 {
            arrDeliveries = objData.arrResult
            
            //tblDeliveries.isHidden = false
            //showToast(strMessage: strMessage)
        }
        tblDeliveries.reloadData()
    }
    
    func deliveriesAPIFailure(strMessage: String, serviceKey: String) {
        //showToast(strMessage: strMessage)
        arrDeliveries.removeAll()
        tblDeliveries.reloadData()
    }
    
}

extension DeliveriesVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIImage(named: AppImageNames.NO_RECORD_FOUND)
        }
        return UIImage(named: AppImageNames.NO_RECORD_FOUND_SMALL)
    }
}

extension DeliveriesVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrDeliveries.count > 0 {
            return arrDeliveries.count + 1
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppTblViewCells.DELIVERY_LIST_CELL, for: indexPath as IndexPath) as! DeliveryListCell
        cell.selectionStyle = .none
        cell.contentView.layer.borderColor = UIColor(named: AppColors.INPUT_BORDER)?.cgColor
        cell.contentView.layer.borderWidth =  1
        if indexPath.row == 0 {
            cell.contentView.backgroundColor = UIColor(named: AppColors.BLUE)
            cell.borderOneView.backgroundColor = UIColor(named: AppColors.BLUE)
            cell.borderTwoView.backgroundColor = UIColor(named: AppColors.BLUE)
            cell.borderThreeView.backgroundColor = UIColor(named: AppColors.BLUE)
            
            cell.serialNumberLbl.textColor = .white
            cell.applicationIdLbl.textColor = .white
            cell.clientNameLbl.textColor = .white
            cell.REGONoLbl.textColor = .white
            
            cell.serialNumberLbl.text = "#"
            cell.applicationIdLbl.text = "Ref No."
            cell.clientNameLbl.text = "Client Name"
            cell.REGONoLbl.text = "REGO No."
            
        } else {
            cell.contentView.backgroundColor = .white
            cell.borderOneView.backgroundColor = UIColor(named: AppColors.INPUT_BORDER)
            cell.borderTwoView.backgroundColor = UIColor(named: AppColors.INPUT_BORDER)
            cell.borderThreeView.backgroundColor = UIColor(named: AppColors.INPUT_BORDER)
            
            cell.serialNumberLbl.textColor = UIColor(named: AppColors.BLACK)
            cell.applicationIdLbl.textColor = UIColor(named: AppColors.BLACK)
            cell.clientNameLbl.textColor = UIColor(named: AppColors.BLACK)
            cell.REGONoLbl.textColor = UIColor(named: AppColors.BLACK)
            
            cell.serialNumberLbl.text = String(indexPath.row)
            cell.applicationIdLbl.text = arrDeliveries[indexPath.row-1].applicationId
            cell.clientNameLbl.text = arrDeliveries[indexPath.row-1].clientName
            cell.REGONoLbl.text = arrDeliveries[indexPath.row-1].proposed_vehicle
        }
        cell.applicationIdLbl.tag = indexPath.row
        cell.applicationIdLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(applicationIDLblTapped)))
        cell.applicationIdLbl.isUserInteractionEnabled = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
