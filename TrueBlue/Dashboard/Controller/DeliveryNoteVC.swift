//
//  DeliveryNoteVC.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 10/04/23.
//

import UIKit
import Alamofire

class DeliveryNoteVC: UIViewController {
    
    @IBOutlet weak var documentTblHight: NSLayoutConstraint!
    @IBOutlet weak var deliveryTimeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var deliveryTimeTxtFld: UITextField!
    @IBOutlet weak var deliveryDateTxtFld: UITextField!
    @IBOutlet weak var deliveryNoteTxtView: UITextView!
    @IBOutlet weak var clientNameTxtFld: UITextField!
    @IBOutlet weak var phoneNumberTxtFld: UITextField!
    @IBOutlet weak var regoLbl: UILabel!
    @IBOutlet weak var deliveryAddressTxtView: UITextView!
   // @IBOutlet weak var deliveryByLbl: UITextField!
    
    @IBOutlet weak var deliveryByTxtFld: UITextField!
    @IBOutlet weak var anySpecialInstructTxtView: UITextView!
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var referralLbl: UILabel!
    @IBOutlet weak var repairerLbl: UILabel!
    @IBOutlet weak var documentsCollectedLbl: UILabel!
    
    @IBOutlet weak var otherTxtFld: UITextField!
    @IBOutlet weak var docListTblView: UITableView!
    
    var type: ActionType?
    var selectedReferralId: String = ""
    var selectedRepairersData : RepairersListModelData?
    var selectedReferralsData : ReferralsListModelData?
    var selectedRegoData: RegoNumberListModelData?
    var selectedCollectedDocuments : [CollectedDocumentsModelData]?
    
    
    var arrRegoNumberList = [RegoNumberListModelData]()
    var arrRepairerList = [RepairersListModelData]()
    var arrReferralList = [ReferralsListModelData]()
    var arrcollectedDocumentsList = [CollectedDocumentsModelData]()
    var arrSelectedDocuments = [CollectedDocumentsModelData]()
    var documentList = [String]()
    
    var isOtherDocumentSelected = false
    
    var deliveryNoteDetail : DeliveryNotesListModelData?
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        apiGetdeliveredNoteDetail(parameters: nil, endPoint: EndPoints.COLLECTED_DOCUMENTS)
        print(deliveryNoteDetail)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.DateNotificationAction(_:)), name: .deliveryDate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchListNotificationAction(_:)), name: .searchListRego, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchListNotificationAction(_:)), name: .searchListRepairer, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchListNotificationAction(_:)), name: .searchListReferral, object: nil)
        
        if deliveryNoteDetail != nil {
            apiGetdeliveredNoteDetail(parameters: nil, endPoint: EndPoints.COLLECTED_DOCUMENTS)
            showData()
        }
        //        if noteId != nil {
        //            fatchDeliveryNoteDetail()
        //        } else {
        //            fetchDropdownValues()
        //        }
        if isOtherDocumentSelected {
            otherView.isHidden = false
        } else {
            otherView.isHidden = true
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    @IBAction func deliveryDateCalenderBtnTapped(_ sender: UIButton) {
        showDatePickerPopUp(textField: deliveryDateTxtFld, notificationName: .deliveryDate)
        
    }
    func addAndUpdateDeliveryNoteAPi(){
        
        var arr = Array<String>()
    
        for obj in  arrcollectedDocumentsList {
            if obj.isSelected {
                arr.append(obj.documentID)
            }
        }
        let strCollectedDocId = arr.joined(separator: ",")
                            print(strCollectedDocId)
        let deliveryTime = deliveryTimeTxtFld.text?.convertTimeToTwentyFourHr(isAM: deliveryTimeSegmentedControl.selectedSegmentIndex) ?? ""
        var parameters : Parameters = ["delivery_note" : deliveryNoteTxtView.text ?? "",
                                       "client_name" : clientNameTxtFld.text ?? "",
                                       "phone_number" : phoneNumberTxtFld.text ?? "",
                                       "delivery_address" : deliveryAddressTxtView.text ?? "",
                                       "delivery_date" : deliveryDateTxtFld.text ?? "",
                                       "delivery_time" : deliveryTime,
                                       "rego_no" : selectedRegoData?.regoNoID ?? "",
                                       "repairer_id" : selectedRepairersData?.repairersID ?? "",
                                       "referral_id" : selectedReferralsData?.referralsID ?? "",
                                       "documents_collected" : strCollectedDocId,
                                       "special_instructions" : anySpecialInstructTxtView.text ?? "",
                                       "delivery_by" : deliveryByTxtFld.text ?? ""]
        
        if deliveryNoteDetail?.id != nil {
            parameters["action"] = ActionType.UPDATE.Action
            parameters["id"] = deliveryNoteDetail?.id
            type = ActionType.UPDATE
        }else {
            parameters["action"] = ActionType.ADD.Action
            type = ActionType.ADD
            
        }
        
        if( isOtherDocumentSelected){
            parameters["document_collected_other"] = otherTxtFld.text ?? ""
        }
        print("Vijay \(parameters)")
        apiPostdeliveredNoteDetail(parameters: parameters, endPoint: EndPoints.DELIVERY_NOTE)
    }
    func showData() {
        deliveryNoteTxtView.text = deliveryNoteDetail?.deliveryNote
        clientNameTxtFld.text = deliveryNoteDetail?.clientName
        phoneNumberTxtFld.text = deliveryNoteDetail?.phoneNumber
        deliveryAddressTxtView.text = deliveryNoteDetail?.deliveryAddress
        deliveryDateTxtFld.text = deliveryNoteDetail?.deliveryDate
        deliveryTimeTxtFld.text = deliveryNoteDetail?.deliveryTime
        anySpecialInstructTxtView.text = deliveryNoteDetail?.specialInstructions
        deliveryByTxtFld.text = deliveryNoteDetail?.deliveryBy
        otherTxtFld.text = deliveryNoteDetail?.documentCollectedOther
        
        
        if !(deliveryNoteDetail?.regoNo ?? "").isEmpty {
            selectedRegoData = RegoNumberListModelData(regoNoID: deliveryNoteDetail?.regoNo ?? "",registrationNo: deliveryNoteDetail?.regoName ?? "")
            setRegoNoData()
            //apiGetdeliveredNoteDetail(parameters: nil, endPoint: EndPoints.REGO_NUMBER)
        }
        
        if !(deliveryNoteDetail?.repairerId ?? "").isEmpty {
            selectedRepairersData = RepairersListModelData(repairersID: deliveryNoteDetail?.repairerId ?? "", repairersName: deliveryNoteDetail?.repairerName ?? "")
            setRepairersData()
            
        }
        if !(deliveryNoteDetail?.referralId ?? "").isEmpty {
            selectedReferralsData = ReferralsListModelData(referralsID:deliveryNoteDetail?.referralId ?? "",referralsName: deliveryNoteDetail?.referralName ?? "")
            setRreferralData()
        }
        if !(deliveryNoteDetail?.deliveryTime ?? "").isEmpty {
            let deliveryTime = deliveryNoteDetail?.deliveryTime
            deliveryTimeSegmentedControl.setUpAmPM(time: deliveryTime ?? "")
            deliveryTimeTxtFld.text = deliveryTime?.DatePresentable?.getDateAccoringTo(format: .Time12Hr) ?? ""
        }
    }
    
    func setRegoNoData(){
        regoLbl.text = selectedRegoData?.registrationNo
        regoLbl.textColor = UIColor(named: AppColors.BLACK)
    }
    
    func setRepairersData() {
        repairerLbl.text = selectedRepairersData?.repairersName
        repairerLbl.textColor = UIColor(named: AppColors.BLACK)
    }
    
    func setRreferralData() {
        referralLbl.text = selectedReferralsData?.referralsName
        referralLbl.textColor = UIColor(named: AppColors.BLACK)
    }
    func setDocumentsData() {
        // documentsCollectedLbl.text = selectedCollectedDocuments
        documentsCollectedLbl.textColor = UIColor(named: AppColors.BLACK)
    }
    @objc func SearchListNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let selectedItem = userInfo["selectedItem"] as! String
            let selectedItemIndex = userInfo["selectedIndex"] as! Int
            //CommonObject.sharedInstance.isDataChangedInCurrentTab = true
            switch notification.name{
            case .searchListRego:
                selectedRegoData = arrRegoNumberList[selectedItemIndex]
                setRegoNoData()
            case .searchListRepairer:
                selectedRepairersData = arrRepairerList[selectedItemIndex]
                setRepairersData()
            case .searchListReferral:
                selectedReferralsData = arrReferralList[selectedItemIndex]
                setRreferralData()
                
            default:
                print("default case")
            }
        }
    }
    
    @IBAction func ragoNoTapped(_ sender: UITapGestureRecognizer) {
        apiGetdeliveredNoteDetail(parameters: nil, endPoint: EndPoints.REGO_NUMBER)
    }
    
    @IBAction func repairerLblTapped(_ sender: UITapGestureRecognizer) {
        apiGetdeliveredNoteDetail(parameters: nil, endPoint: EndPoints.REPAIRERS)
    }
    
    @IBAction func referralLblTapped(_ sender: UITapGestureRecognizer) {
        apiGetdeliveredNoteDetail(parameters: nil, endPoint: EndPoints.REFERRALS)
    }
    @IBAction func submitBtn(_ sender: UIButton) {
        addAndUpdateDeliveryNoteAPi()
    }
    
    @objc func DateNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let selectedDate = userInfo["selectedDate"] as? String {
                let selectedTextField = userInfo["dateTextField"] as! UITextField
                switch selectedTextField {
                case deliveryDateTxtFld:
                    deliveryDateTxtFld.text = selectedDate
                default:
                    print("Unkown Date Textfield")
                }
            }
        }
    }
    func setViews() {
        deliveryTimeSegmentedControl.setUpAmPmSegmentedControl()
        //apiGetRequest(parameters: nil, endPoint: EndPoints.DELIVERY_NOTES)
        
    }
    func fatchDeliveryNoteDetail() {
        type = ActionType.DETAIL
        let parameters : Parameters = ["action" : ActionType.DETAIL.Action,
                                       "id" : deliveryNoteDetail?.id ?? ""]
        apiPostdeliveredNoteDetail(parameters: parameters, endPoint: EndPoints.DELIVERY_NOTE)
    }
    func apiPostdeliveredNoteDetail(parameters: Parameters,endPoint: String) {
        CommonObject.sharedInstance.showProgress()
        let obj = DeliveryNoteViewModel()
        obj.delegate = self
        obj.postdeliveredNoteDetail(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    func apiGetdeliveredNoteDetail(parameters: Parameters?,endPoint: String) {
        CommonObject.sharedInstance.showProgress()
        let obj = DeliveryNoteViewModel()
        obj.delegate = self
        obj.getDeliveredNoteDetail(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    
}
extension DeliveryNoteVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var documentDetailData = arrcollectedDocumentsList[indexPath.row]
        if documentDetailData.isSelected {
            documentDetailData.isSelected = false
        } else {
            documentDetailData.isSelected = true
        }
        self.arrcollectedDocumentsList[indexPath.row] = documentDetailData
        self.docListTblView.reloadRows(at: [indexPath], with: .automatic)
        
        handleOtherCase(value: documentDetailData)
        
    }
    func handleOtherCase(value: CollectedDocumentsModelData){
        if (value.documentName == "Other"){
            
            if value.isSelected {
                otherView.isHidden = false
                isOtherDocumentSelected = true
            } else {
                otherView.isHidden = true
                isOtherDocumentSelected = false
            }
        }
       
        
    }
}
extension DeliveryNoteVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrcollectedDocumentsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppTblViewCells.COLLECTED_DOCUMENTS_LIST_CELL, for: indexPath as IndexPath) as! CollectedDocumentsListTblCell
        var documentData = arrcollectedDocumentsList[indexPath.row]
        cell.documentLbl.text = documentData.documentName
        if documentData.isSelected {
            cell.checkImgeView.image = UIImage(named: "checkSelected")
        } else {
            cell.checkImgeView.image = UIImage(named: "checkUnselected")
        }
        
//        cell.checkImgeView.image = UIImage.init(named: "checkSelected")
//                   let result = arrSelectedDocuments.filter ({$0.documentID == arrcollectedDocumentsList[indexPath.row].documentID})
//                   if result.isEmpty {
//                       cell.checkImgeView.image = UIImage.init(named: "checkUnselected")
//                   }
        return cell
    }
    
    
}
extension DeliveryNoteVC : DeliveredNoteVMDelegate {
    func deliveredNoteAPISuccess(objData: CollectedDocumentsModel, strMessage: String, serviceKey: String) {
        if objData.arrResult.count > 0 {
            arrcollectedDocumentsList = objData.arrResult
            let collectedDocArr = deliveryNoteDetail?.documentsCollected.components(separatedBy: ",")
            for id in collectedDocArr ?? []{
                
                for index in 0...arrcollectedDocumentsList.count - 1{
                    
                    if id == arrcollectedDocumentsList[index].documentID{
                        arrcollectedDocumentsList[index].isSelected = true
                    }
                    
                    if arrcollectedDocumentsList[index].documentName == "Other" && arrcollectedDocumentsList[index].isSelected{
                        otherView.isHidden = false
                    } else {
                        otherView.isHidden = true
                    }
                }
            }
            print(collectedDocArr)
            print(arrcollectedDocumentsList)
            if UIDevice.current.userInterfaceIdiom == .pad {
                documentTblHight.constant = 200//(CGFloat(arrcollectedDocumentsList.count) * 70) + 300
            } else {
                print(arrcollectedDocumentsList.count)
                documentTblHight.constant = 200
            }
            //documentTblHight.constant = (CGFloat(arrcollectedDocumentsList.count) * 70) + 80
            //showToast(strMessage: strMessage)
        }
       docListTblView.reloadData()
    }
    
    func deliveredNoteAPISuccess(objData: ReferralsListModel, strMessage: String, serviceKey: String) {
        if objData.arrResult.count > 0 {
            var temp = [String]()
            for i in 0...objData.arrResult.count-1 {
                let data = objData.arrResult[i]
                temp.append(data.referralsName)
                if (deliveryNoteDetail?.referralId == data.referralsName) {
                    selectedReferralsData = data
                    setRreferralData()
                }
            }
            arrReferralList = objData.arrResult
            print(arrReferralList)
            showSearchListPopUp(listForSearch: temp, listNameForSearch: AppDropDownLists.REFERRAL, notificationName: .searchListReferral)
        }
    }
    
    func deliveredNoteAPISuccess(objData: RepairersListModel, strMessage: String, serviceKey: String) {
        if objData.arrResult.count > 0 {
            
            var temp = [String] ()
            for i in 0...objData.arrResult.count-1 {
                let data = objData.arrResult[i]
                temp.append(data.repairersName)
                if(deliveryNoteDetail?.repairerId == data.repairersName){
                    selectedRepairersData = data
                    setRepairersData()
                }
            }
            arrRepairerList = objData.arrResult
            print(arrRepairerList)
            showSearchListPopUp(listForSearch: temp, listNameForSearch: AppDropDownLists.REPAIRER,notificationName: .searchListRepairer)
        }
    }
    
    func deliveredNoteAPISuccess(objData: RegoNumberListModel, strMessage: String, serviceKey: String) {
        print(objData)
        if objData.arrResult.count > 0 {
            
            var temp = [String] ()
            for i in 0...objData.arrResult.count-1 {
                let data = objData.arrResult[i]
                temp.append(data.registrationNo)
                if(deliveryNoteDetail?.regoNo == data.regoNoID){
                    selectedRegoData = data
                    setRegoNoData()
                }
            }
            arrRegoNumberList = objData.arrResult
            print(arrRegoNumberList)
            showSearchListPopUp(listForSearch: temp, listNameForSearch: AppDropDownLists.REGO_NUMBER,notificationName: .searchListRego)
        }
    }
    
    func deliveredNoteAPISuccess(strMessage: String, serviceKey: String) {
        
    }
    
    func deliveredNoteAPISuccess(objData: DeliveryNotesListModel, strMessage: String, serviceKey: String) {
        deliveryNoteDetail = objData.detailsModel
        switch type {
        case .UPDATE:
            dismiss(animated: true)
            NotificationCenter.default.post(name: .deliveryNoteListRefresh, object: self, userInfo: nil)
        case .ADD:
            dismiss(animated: true)
        case .DETAIL:
            showData()
        default :
            print("Invalid Type")
            
        }
    }
    
    func deliveredNoteAPIFailure(strMessage: String, serviceKey: String) {
        arrcollectedDocumentsList.removeAll()
        docListTblView.reloadData()
    }
    
    
}

extension DeliveryNoteVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == deliveryDateTxtFld {
            //Open the ShowDatePicker
            showDatePickerPopUp(textField: deliveryDateTxtFld, notificationName: .deliveryDate)        }
    }
    //Disable the Letter and only allow Numbers
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var isAllowed = true
        switch textField {
        case deliveryTimeTxtFld:
            isAllowed = textField.validateTimeTyped(shouldChangeCharactersInRange: range, replacementString: string)
        default:
            print("TextField without restriction")
        }
        return isAllowed
    }
}
