//
//  CollectionsVC.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 18/08/21.
//

import UIKit
import Alamofire
import DZNEmptyDataSet
class CollectionsVC: UIViewController {
    @IBOutlet weak var tblCollections: UITableView!
    @IBOutlet weak var dateFromTxtFld: UITextField!
    @IBOutlet weak var dateToTxtFld: UITextField!
    
    
    var arrCollections = [CollectionsModelData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(self.DateNotificationAction(_:)), name: .dateCollections, object: nil)
        //COLLECTION_LIST
        
        
        //tblCollections.isHidden = true
        tblCollections.emptyDataSetSource = self;
        tblCollections.emptyDataSetDelegate = self;
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
//        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFromTxtFld.text = dateFormatter.string(from: currentDate)
        dateToTxtFld.text = dateFromTxtFld.text
        dateFromTxtFld.keyboardType = .numberPad
        dateToTxtFld.keyboardType = .numberPad
        apiCollections()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)//Removes all notifications being observed
    }
    
    func apiPostCollectionList(parameters: Parameters,endPoint: String) {
        CommonObject.sharedInstance.showProgress()
        let obj = CollectionsViewModel()
        obj.delegate = self
        obj.postCollections(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    
    func apiCollections() {
        
        let parameters : Parameters = ["date_from" : dateFromTxtFld.text ?? "",
                                       "date_to" : dateToTxtFld.text ?? ""]
        apiPostCollectionList(parameters: parameters, endPoint: EndPoints.COLLECTION_LIST)
    }

    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
        apiCollections()
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
    @IBAction func dateFromCalenderBtnTapped(_ sender: UIButton) {
        showDatePickerPopUp(textField: dateFromTxtFld, notificationName: .dateCollections)
    }
    
    @IBAction func dateToCalenderBtnTapped(_ sender: UIButton) {
        showDatePickerPopUp(textField: dateToTxtFld, notificationName: .dateCollections)
    }
    
    
    @objc func returnVehicle(sender: UIButton) {
        var storyboard = UIStoryboard()
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboard = UIStoryboard(name: AppStoryboards.DASHBOARD, bundle: .main)
        } else {
            storyboard = UIStoryboard(name: AppStoryboards.DASHBOARD_PHONE, bundle: .main)
        }
        let vc = storyboard.instantiateViewController(identifier: AppStoryboardId.RETURN_VEHICLE) as! ReturnVehicleVC
        vc.applicationID = arrCollections[sender.tag].applicationId
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func applicationIDLblTapped(_ sender: UITapGestureRecognizer) {
        CommonObject.sharedInstance.isNewEntry = false
        CommonObject.sharedInstance.currentReferenceId = arrCollections[sender.view!.tag].applicationId
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
extension CollectionsVC : UITextFieldDelegate {
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        var isKeyboard = true
//        switch textField {
//        case dateFromTxtFld,dateToTxtFld:
//            isKeyboard = false
//            showDatePickerPopUp(textField: textField, notificationName: .dateCollections)
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

extension CollectionsVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if arrCollections.count > 0 {
            return arrCollections.count + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: AppTblViewCells.COLLECTIONS_LIST_HEADER, for: indexPath as IndexPath) as! CollectionsHeaderTblViewCell
            return headerCell
//            cell.contentView.backgroundColor = UIColor(named: AppColors.BLUE)
//            cell.borderOneView.backgroundColor = UIColor(named: AppColors.BLUE)
//            cell.borderTwoView.backgroundColor = UIColor(named: AppColors.BLUE)
//            cell.borderThreeView.backgroundColor = UIColor(named: AppColors.BLUE)
//            cell.borderFourView.backgroundColor = UIColor(named: AppColors.BLUE)
//
//            cell.serialNumberLbl.textColor = .white
//            cell.applicationIdLbl.textColor = .white
//            cell.clientNameLbl.textColor = .white
//            cell.REGONoLbl.textColor = .white
//            cell.collectionsLbl.textColor = .white
//
//            cell.serialNumberLbl.text = "#"
//            cell.applicationIdLbl.text = "Ref No."
//            cell.REGONoLbl.text = "REGO No."
//            cell.clientNameLbl.text = "Name"
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: AppTblViewCells.COLLECTIONS_CELL, for: indexPath as IndexPath) as! CollectionListCell
            cell.selectionStyle = .none
            cell.contentView.layer.borderColor = UIColor(named: AppColors.INPUT_BORDER)?.cgColor
            cell.contentView.layer.borderWidth =  1
            cell.contentView.backgroundColor = .white
//            cell.borderOneView.backgroundColor = UIColor(named: AppColors.INPUT_BORDER)
//            cell.borderTwoView.backgroundColor = UIColor(named: AppColors.INPUT_BORDER)
//            cell.borderThreeView.backgroundColor = UIColor(named: AppColors.INPUT_BORDER)
//            cell.borderFourView.backgroundColor = UIColor(named: AppColors.INPUT_BORDER)
//
//            cell.serialNumberLbl.textColor = UIColor(named: AppColors.BLACK)
//            cell.applicationIdLbl.textColor = UIColor(named: AppColors.BLACK)
//            cell.clientNameLbl.textColor = UIColor(named: AppColors.BLACK)
//            cell.REGONoLbl.textColor = UIColor(named: AppColors.BLACK)
            
            cell.serialNumberLbl.text = String(indexPath.row)
            cell.applicationIdLbl.text = arrCollections[indexPath.row-1].applicationId
            cell.clientNameLbl.text = arrCollections[indexPath.row-1].clientName
            cell.REGONoLbl.text = arrCollections[indexPath.row-1].vehicle
            cell.collectionsBtn.tag = indexPath.row-1//First row is header
            cell.collectionsBtn.addTarget(self, action: #selector(returnVehicle(sender:)), for: .touchUpInside)
            cell.applicationIdLbl.tag = indexPath.row-1
            cell.applicationIdLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(applicationIDLblTapped)))
            cell.applicationIdLbl.isUserInteractionEnabled = true
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension CollectionsVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIImage(named: AppImageNames.NO_RECORD_FOUND)
        }
        return UIImage(named: AppImageNames.NO_RECORD_FOUND_SMALL)
    }
}
extension CollectionsVC: CollectionsVMDelegate {
    func collectionsAPISuccess(objData: CollectionsModel, strMessage: String) {
        if objData.arrResult.count > 0 {
            arrCollections = objData.arrResult
            //showToast(strMessage: strMessage)
        }
        
        tblCollections.reloadData()
    }
    
    func collectionsAPIFailure(strMessage: String, serviceKey: String) {
        //showToast(strMessage: strMessage)
        arrCollections.removeAll()
        tblCollections.reloadData()
    }
}
