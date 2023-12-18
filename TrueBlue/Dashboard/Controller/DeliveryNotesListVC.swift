//
//  DeliveryNotesListVC.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 12/04/23.
//

import UIKit
import Alamofire
import DZNEmptyDataSet

class DeliveryNotesListVC: UIViewController {
    
    @IBOutlet weak var dateToTxtFld: UITextField!
    @IBOutlet weak var dateFromTxtFld: UITextField!
    @IBOutlet weak var tblDeliveryNoteList: UITableView!
    
    var arrDeliveryList = [DeliveryNotesListModelData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(self.DateNotificationAction(_:)), name: .deliveryDate, object: nil)
        
        //Call this notification on note update
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshRecordAction(_:)), name: .deliveryNoteListRefresh, object: nil)
        
        tblDeliveryNoteList.emptyDataSetSource = self;
        tblDeliveryNoteList.emptyDataSetDelegate = self;
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        //dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFromTxtFld.text = dateFormatter.string(from: currentDate)
        dateToTxtFld.text = dateFromTxtFld.text
        dateFromTxtFld.keyboardType = .numberPad
        dateToTxtFld.keyboardType = .numberPad
        apiDeliveryNotesList()
    }
    
    
    @objc func refreshRecordAction(_ notification: NSNotification) {
        apiDeliveryNotesList()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)//Removes all notifications being observed
    }
    func apiPostdeliveredNoteDetail(parameters: Parameters,endPoint: String) {
        CommonObject.sharedInstance.showProgress()
        let obj = DeliveryNotesListViewModel()
        obj.delegate = self
        obj.postDeliveredNoteDetail(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    func apiDeliveryNotesList() {
        
        let parameters : Parameters = ["date_from" : dateFromTxtFld.text ?? "",
                                       "date_to" : dateToTxtFld.text ?? ""]
        apiPostdeliveredNoteDetail(parameters: parameters, endPoint: EndPoints.DELIVERY_NOTES)
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
    @objc func editDeliveryNote(sender:UIButton) {
        var storyboardName = String()
        var vcid = String()
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboardName = AppStoryboards.DASHBOARD
            vcid = AppStoryboardId.DELIVERY_NOTE
            
        } else {
            storyboardName  = AppStoryboards.DASHBOARD_PHONE
            vcid = AppStoryboardId.DELIVERY_NOTE_PHONE
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        let deliveryNotevc = storyboard.instantiateViewController(identifier: vcid) as! DeliveryNoteVC
        deliveryNotevc.modalPresentationStyle = .overFullScreen
        deliveryNotevc.deliveryNoteDetail = arrDeliveryList[sender.tag]
        
        present(deliveryNotevc, animated: true, completion: nil)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func addDeliveryNoteBtntapped(_ sender: UIButton) {
        var storyboardName = String()
        var vcid = String()
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboardName = AppStoryboards.DASHBOARD
            vcid = AppStoryboardId.DELIVERY_NOTE
            
        } else {
            storyboardName  = AppStoryboards.DASHBOARD_PHONE
            vcid = AppStoryboardId.DELIVERY_NOTE_PHONE
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        let deliveryNotevc = storyboard.instantiateViewController(identifier: vcid) as! DeliveryNoteVC
        deliveryNotevc.modalPresentationStyle = .overFullScreen
        present(deliveryNotevc, animated: true, completion: nil)
    }
    
    @IBAction func dateFromCalenderBtnTapped(_ sender: UIButton) {
        showDatePickerPopUp(textField: dateFromTxtFld, notificationName: .deliveryDate)
    }
    @IBAction func dateToCalenderBtnTapped(_ sender: UIButton) {
        showDatePickerPopUp(textField: dateToTxtFld, notificationName: .deliveryDate )
    }
    @IBAction func submitBtn(_ sender: UIButton) {
        if dateFromTxtFld.text == "" {
            showToast(strMessage: dateFromRequired)
            return
        }
        if dateToTxtFld.text == "" {
            showToast(strMessage: dateToRequired)
            return
        }
        apiDeliveryNotesList()
    }
    
    
}
extension DeliveryNotesListVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case dateFromTxtFld,dateToTxtFld:
            return textField.validateDateTyped(shouldChangeCharactersInRange: range, replacementString: string)
        default:
            return true
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateFromTxtFld {
            showDatePickerPopUp(textField: dateFromTxtFld, notificationName: .deliveryDate)
        }
        if textField == dateToTxtFld {
            showDatePickerPopUp(textField: dateToTxtFld, notificationName: .deliveryDate)
        }
    }
}

extension DeliveryNotesListVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIImage(named: AppImageNames.NO_RECORD_FOUND)
        }
        return UIImage(named: AppImageNames.NO_RECORD_FOUND_SMALL)
    }
}
extension DeliveryNotesListVC : UITableViewDelegate {
    
    
}
extension DeliveryNotesListVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if arrDeliveryList.count > 0 {
            return arrDeliveryList.count + 1
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: AppTblViewCells.COLLECTIONS_LIST_HEADER, for: indexPath as IndexPath) as! CollectionsHeaderTblViewCell
            return headerCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: AppTblViewCells.DELIVERY_NOTES_LIST_CELL, for: indexPath as IndexPath) as! DeliveryNotesListTableViewCell
            cell.selectionStyle = .none
            cell.contentView.layer.borderColor = UIColor(named: AppColors.INPUT_BORDER)?.cgColor
            cell.contentView.layer.borderWidth =  1
            cell.contentView.backgroundColor = .white
            //cell.textLabel?.text = arrDeliveryList[indexPath.row-1].clientName
            cell.clientNameLbl.text = arrDeliveryList[indexPath.row-1].clientName
            cell.REGONoLbl.text = arrDeliveryList[indexPath.row-1].regoName
            cell.applicationIdLbl.text = arrDeliveryList[indexPath.row-1].regoNo
            cell.serialNumberLbl.text = String(indexPath.row)
            cell.editDeliveryNoteBtn.tag = indexPath.row-1
            cell.editDeliveryNoteBtn.addTarget(self, action: #selector(editDeliveryNote(sender: )), for: .touchUpInside)
            
            return cell
        }
        
    }
    
    
}
extension DeliveryNotesListVC : DeliveredNoteListVMDelegate {
    
    func deliveredNoteListAPISuccess(objData: DeliveryNotesListModel, strMessage: String, serviceKey: String) {
        if objData.arrResult.count > 0 {
            arrDeliveryList = objData.arrResult
            print(arrDeliveryList)
            //showToast(strMessage: strMessage)
        }
        tblDeliveryNoteList.reloadData()
    }
    
    func deliveredNoteListAPIFailure(strMessage: String, serviceKey: String) {
        arrDeliveryList.removeAll()
        tblDeliveryNoteList.reloadData()
    }
}
