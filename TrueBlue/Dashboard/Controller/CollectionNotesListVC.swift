//
//  CollectionNotesListVC.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 13/04/23.
//

import UIKit
import Alamofire
import DZNEmptyDataSet

class CollectionNotesListVC: UIViewController {
    
    @IBOutlet weak var tblCollectionNotesList: UITableView!
    @IBOutlet weak var dateToTxtFld: UITextField!
    @IBOutlet weak var dateFromTxtFld: UITextField!
    
    var arrCollectionList = [CollectionNotesModelData]()
    var collectionNoteDetail : CollectionNotesModelData?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.DateNotificationAction(_:)), name: .collectionDate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.RefreshRecordAction(_:)), name: .collectionNoteListRefresh, object: next)
        
        tblCollectionNotesList.emptyDataSetSource = self;
        tblCollectionNotesList.emptyDataSetDelegate = self;
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        //dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFromTxtFld.text = dateFormatter.string(from: currentDate)
        dateToTxtFld.text = dateFromTxtFld.text
        dateFromTxtFld.keyboardType = .numberPad
        dateToTxtFld.keyboardType = .numberPad
        apiCollectionNotesList()
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)//Removes all notifications being observed
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
    @objc func RefreshRecordAction(_ notification: NSNotification)  {
        apiCollectionNotesList()
    }
    func apiCollectionNotesList(){
        let parameters : Parameters = ["date_from" : dateFromTxtFld.text ?? "",
                                       "date_to" : dateToTxtFld.text ?? ""]
        apiPostCollectionNoteDetail(parameters: parameters, endPoint: EndPoints.COLLECTION_NOTES)
    }
    
    func apiPostCollectionNoteDetail(parameters: Parameters,endPoint: String) {
        CommonObject.sharedInstance.showProgress()
        let obj = CollectionNoteListViewModel()
        obj.delegate = self
        obj.postCollectionNoteDetail(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    @objc func editcollectionNoteBtnTapped(sender:UIButton) {
        var storyboardName = String()
        var vcid = String()
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboardName = AppStoryboards.DASHBOARD
            vcid = AppStoryboardId.COLLECTION_NOTE
            
        } else {
            storyboardName  = AppStoryboards.DASHBOARD_PHONE
            vcid = AppStoryboardId.COLLECTION_NOTE_PHONE
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        let collectionNotevc = storyboard.instantiateViewController(identifier: vcid) as! CollectionNoteVC
        collectionNotevc.modalPresentationStyle = .overFullScreen
        collectionNotevc.collectionNoteDetail = arrCollectionList[sender.tag]
        present(collectionNotevc, animated: true, completion: nil)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true)
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
        apiCollectionNotesList()
    }
    @IBAction func addCollectionNoteBtn(_ sender: UIButton) {
        var storyboardName = String()
        var vcid = String()
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboardName = AppStoryboards.DASHBOARD
            vcid = AppStoryboardId.COLLECTION_NOTE
            
        } else {
            storyboardName  = AppStoryboards.DASHBOARD_PHONE
            vcid = AppStoryboardId.COLLECTION_NOTE_PHONE
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        let collectionNotevc = storyboard.instantiateViewController(identifier: vcid) as! CollectionNoteVC
        collectionNotevc.modalPresentationStyle = .overFullScreen
        present(collectionNotevc, animated: true, completion: nil)
    }
    
    @IBAction func dateFromCalenderTapped(_ sender: UIButton) {
        showDatePickerPopUp(textField: dateFromTxtFld, notificationName: .collectionDate)
    }
    
    @IBAction func dateToCalenderTapped(_ sender: UIButton) {
        showDatePickerPopUp(textField: dateToTxtFld, notificationName: .collectionDate)
    }
}
extension CollectionNotesListVC : UITableViewDelegate {
    
}
extension CollectionNotesListVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrCollectionList.count > 0 {
            return arrCollectionList.count + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: AppTblViewCells.COLLECTION_NOTES_LIST_CELL, for: indexPath as IndexPath) as! CollectionNotesListTableViewCell
        if indexPath.row == 0 {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: AppTblViewCells.COLLECTIONS_LIST_HEADER, for: indexPath as IndexPath) as! CollectionsHeaderTblViewCell
            return headerCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: AppTblViewCells.COLLECTION_NOTES_LIST_CELL, for: indexPath as IndexPath) as! CollectionNotesListTableViewCell
            cell.selectionStyle = .none
            cell.contentView.layer.borderColor = UIColor(named: AppColors.INPUT_BORDER)?.cgColor
            cell.contentView.layer.borderWidth =  1
            cell.contentView.backgroundColor = .white
            cell.serialNumberLbl.text = String(indexPath.row)
            cell.clientNameLbl.text = arrCollectionList[indexPath.row-1].clientName
            cell.applicationIdLbl.text = arrCollectionList[indexPath.row-1].regoNo
            print(arrCollectionList[indexPath.row-1].regoName)
            cell.regoNoLbl.text = arrCollectionList[indexPath.row-1].regoName
            cell.editcollectionNoteBtn.tag = indexPath.row-1
            cell.editcollectionNoteBtn.addTarget(self, action: #selector(editcollectionNoteBtnTapped(sender: )), for: .touchUpInside)
            return cell
        }
    }
}

extension CollectionNotesListVC : UITextFieldDelegate {
    
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
            showDatePickerPopUp(textField: dateFromTxtFld, notificationName: .collectionDate)
        }
        if textField == dateToTxtFld {
            showDatePickerPopUp(textField: dateToTxtFld, notificationName: .collectionDate)
        }
    }
}
extension CollectionNotesListVC :DZNEmptyDataSetDelegate , DZNEmptyDataSetSource  {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIImage(named: AppImageNames.NO_RECORD_FOUND)
        }
        return UIImage(named: AppImageNames.NO_RECORD_FOUND_SMALL)
    }
}
extension CollectionNotesListVC : CollectionNoteListVMDelegate {
    func collectionNoteListAPISuccess(objData: CollectionNotesModel, strMessage: String, serviceKey: String) {
        if objData.arrResult.count > 0 {
            arrCollectionList = objData.arrResult
            
        }
        tblCollectionNotesList.reloadData()
    }
    
    func collectionNoteListAPIFailure(strMessage: String, serviceKey: String) {
        arrCollectionList.removeAll()
        tblCollectionNotesList.reloadData()
    }
}
