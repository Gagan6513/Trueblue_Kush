//
//  CollectionNoteVC.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 10/04/23.
//

import UIKit
import Alamofire

class CollectionNoteVC: UIViewController {
    
    @IBOutlet weak var collectionTimeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionTimeTxtFld: UITextField!
    @IBOutlet weak var collectionDateTxtFld: UITextField!
    @IBOutlet weak var raNumberLbl: UILabel!
    @IBOutlet weak var ragoNoLbl: UILabel!
    @IBOutlet weak var clientNameTxtFld: UITextField!
    @IBOutlet weak var phoneNoTxtFld: UITextField!
    @IBOutlet weak var specialInstructionsTxtView: UITextView!
    @IBOutlet weak var googleReviewTxtView: UITextView!
    @IBOutlet weak var collectedByTxtFld: UITextField!
    @IBOutlet weak var otherTxtFld: UITextField!
    @IBOutlet weak var collectionAddressTxtView: UITextView!
    @IBOutlet weak var otherView: UIView!
    
    @IBOutlet weak var collectedDocTblView: UITableView!
    @IBOutlet weak var collectedDocumentsTblHeight: NSLayoutConstraint!
    var selectedRegoData : RegoNumberListModelData?
    var selectedRANoData : RANumbersListModelData?
    var arrRegoNumberList = [RegoNumberListModelData]()
    var arrRANumberList = [RANumbersListModelData]()
    var arrcollectedDocumentsList = [CollectedDocumentsModelData]()
    var proposedVehicle : String?
    var noteId : String?
    var collectionNoteDetail : CollectionNotesModelData?
    var type : ActionType?
    var isOtherDocumentSelected = false
    var ragoListTapped = "No"
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        hideKeyboardWhenTappedAround()
        apiGetCollectionNoteDetail(parameters: nil, endPoint: EndPoints.COLLECTED_DOCUMENTS)
        print(collectionNoteDetail)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DateNotificationAction(_:)), name: .collectionDate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchListNotificationAction(_:)), name: .searchListRego, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchListNotificationAction(_:)), name: .searchListRA, object: nil)
        if collectionNoteDetail != nil {
            apiGetCollectionNoteDetail(parameters: nil, endPoint: EndPoints.COLLECTED_DOCUMENTS)
            showData()
        }
        //        tblCollections.emptyDataSetSource = self;
        //        tblCollections.emptyDataSetDelegate = self;
        if isOtherDocumentSelected {
            otherView.isHidden = false
        } else {
            otherView.isHidden = true
        }
        
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func collectionDateCalenderBtnTapped(_ sender: UIButton) {
        showDatePickerPopUp(textField: collectionDateTxtFld, notificationName: .collectionDate)
    }
    
    @IBAction func submitBtn(_ sender: UIButton) {
        addAndUpdateCollectionAPI()
    }
    @IBAction func ragoNoTapped(_ sender: UITapGestureRecognizer) {
        ragoListTapped = "Yes"
        apiGetCollectionNoteDetail(parameters: nil, endPoint: EndPoints.REGO_NUMBER)
    }
    @IBAction func RANumberBtnTapped(_ sender: UITapGestureRecognizer) {
        apiGetCollectionNoteDetail(parameters: nil, endPoint: EndPoints.RA_NUMBERS)
    }
    
    func addAndUpdateCollectionAPI(){
        
        var arr = Array<String>()
        
        for obj in  arrcollectedDocumentsList {
            if obj.isSelected {
                arr.append(obj.documentID)
            }
        }
        let strCollectedDocId = arr.joined(separator: ",")
        print(strCollectedDocId)
        let collectionTime = collectionTimeTxtFld.text?.convertTimeToTwentyFourHr(isAM: collectionTimeSegmentedControl.selectedSegmentIndex) ?? ""
        var parameters : Parameters = ["ra_number" : selectedRANoData?.applicationId ?? "",
                                       "client_name" : clientNameTxtFld.text ?? "",
                                       "phone_number" : phoneNoTxtFld.text ?? "",
                                       "collection_address" : collectionAddressTxtView.text ?? "",
                                       "collection_date" : collectionDateTxtFld.text ?? "",
                                       "collection_time" : collectionTime ,
                                       //"rego_no" : proposedVehicle ?? "",//selectedRegoData?.regoNoID ?? "",
                                       "documents_collected" : strCollectedDocId,
                                       "special_instructions" : specialInstructionsTxtView.text ?? "",
                                       "google_review" : googleReviewTxtView.text ?? "",
                                       "collected_by" :  collectedByTxtFld.text ?? "",
                                       "is_deleted" :  ""]
        
        if ragoListTapped == "No" {
            parameters["rego_no"] = proposedVehicle
        } else {
            parameters["rego_no"] = selectedRegoData?.regoNoID
        }
        
        if collectionNoteDetail?.id != nil {
            parameters["action"] = ActionType.UPDATE.Action
            parameters["id"] = collectionNoteDetail?.id
            type = ActionType.UPDATE
        }else {
            parameters["action"] = ActionType.ADD.Action
            type = ActionType.ADD
            
        }
        if( isOtherDocumentSelected){
            parameters["document_collected_other"] = otherTxtFld.text ?? ""
        }
        print(parameters)
        apiPostCollectionNoteDetail(parameters: parameters, endPoint: EndPoints.COLLECTION_NOTE)
    }
    func apiPostCollectionNoteDetail(parameters: Parameters,endPoint: String) {
        CommonObject.sharedInstance.showProgress()
        let obj = CollectionNoteViewModel()
        obj.delegate = self
        obj.postCollectionNoteDetail(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    func apiGetCollectionNoteDetail(parameters: Parameters?,endPoint: String) {
        CommonObject.sharedInstance.showProgress()
        let obj = CollectionNoteViewModel()
        obj.delegate = self
        obj.getCollectionNoteDetail(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    func getAccidentDetailsAPI(appId:String) {
        let parameters : Parameters = ["application_id" : appId]
        apiPostCollectionNoteDetail(parameters: parameters, endPoint: EndPoints.GET_ACCIDENT_DETAILS)
    }
    
    @objc func DateNotificationAction(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let selectedDate = userInfo["selectedDate"] as? String {
                let selectedTextField = userInfo["dateTextField"] as! UITextField
                switch selectedTextField {
                case collectionDateTxtFld:
                    collectionDateTxtFld.text = selectedDate
                default:
                    print("Unkown Date Textfield")
                }
            }
        }
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
            case .searchListRA:
                selectedRANoData = arrRANumberList[selectedItemIndex]
                getAccidentDetailsAPI(appId: selectedRANoData?.applicationId ?? "")
                setRANoData()
            default:
                print("default case")
            }
        }
    }
    func setViews() {
        collectionTimeSegmentedControl.setUpAmPmSegmentedControl()
    }
    func setRegoNoData() {
        ragoNoLbl.text = selectedRegoData?.registrationNo
        ragoNoLbl.textColor = UIColor(named: AppColors.BLACK)
        
    }
    func setRANoData() {
        raNumberLbl.text = selectedRANoData?.applicationId
        raNumberLbl.textColor = UIColor(named: AppColors.BLACK)
    }
    func showData() {
        clientNameTxtFld.text = collectionNoteDetail?.clientName
        phoneNoTxtFld.text = collectionNoteDetail?.phoneNumber
        specialInstructionsTxtView.text = collectionNoteDetail?.specialInstructions
        googleReviewTxtView.text = collectionNoteDetail?.googleReview
        collectedByTxtFld.text = collectionNoteDetail?.collectedBy
        collectionAddressTxtView.text = collectionNoteDetail?.collectionAddress
        collectionDateTxtFld.text = collectionNoteDetail?.collectionDate
        otherTxtFld.text = collectionNoteDetail?.documentCollectedOther
        
        if !(collectionNoteDetail?.regoNo ?? "").isEmpty {
            selectedRegoData = RegoNumberListModelData(regoNoID: collectionNoteDetail?.regoNo ?? "",registrationNo: collectionNoteDetail?.regoName ?? "")
            setRegoNoData()
            //apiGetdeliveredNoteDetail(parameters: nil, endPoint: EndPoints.REGO_NUMBER)
        }
        if !(collectionNoteDetail?.collectionTime ?? "").isEmpty {
            let collectionTime = collectionNoteDetail?.collectionTime
            collectionTimeSegmentedControl.setUpAmPM(time: collectionTime ?? "")
            collectionTimeTxtFld.text = collectionTime?.DatePresentable?.getDateAccoringTo(format: .Time12Hr) ?? ""
        }
        if !(collectionNoteDetail?.raNumber ?? "").isEmpty {
            selectedRANoData = RANumbersListModelData(applicationId: collectionNoteDetail?.raNumber ?? "")
            setRANoData()
            print(selectedRANoData ?? "")
        }
        
    }
}
extension CollectionNoteVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var documentDetailData = arrcollectedDocumentsList[indexPath.row]
        if documentDetailData.isSelected {
            documentDetailData.isSelected = false
        } else {
            documentDetailData.isSelected = true
        }
        self.arrcollectedDocumentsList[indexPath.row] = documentDetailData
        self.collectedDocTblView.reloadRows(at: [indexPath], with: .automatic)
        
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
extension CollectionNoteVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrcollectedDocumentsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppTblViewCells.COLLECTED_DOC_COLLECTION_NOTE_CELL, for: indexPath as IndexPath) as! CollectedDocCollectionNoteTblViewCell
        let documentData = arrcollectedDocumentsList[indexPath.row]
        cell.documentNameLbl.text = documentData.documentName
        if documentData.isSelected {
            cell.checkImg.image = UIImage(named: "checkSelected")
        } else {
            cell.checkImg.image = UIImage(named: "checkUnselected")
        }
        return cell
    }
    
    
}
extension CollectionNoteVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == collectionDateTxtFld {
            showDatePickerPopUp(textField: collectionDateTxtFld, notificationName: .collectionDate)        }
        //showDatePickerPopUp(textField: dateInTxtFld, notificationName: .dateReturnVehicle)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var isAllowed = true
        switch textField {
        case collectionTimeTxtFld:
            isAllowed = textField.validateTimeTyped(shouldChangeCharactersInRange: range, replacementString: string)
        default:
            print("TextField without restriction")
        }
        return isAllowed
    }
}

extension CollectionNoteVC : CollectionNoteVMDelegate {
    func collectionNoteAPISuccess(objData: GetAccidentDetailsModel, strMessage: String, serviceKey: String) {
        clientNameTxtFld.text = objData.accidentDetails?.ownerFirstname
        phoneNoTxtFld.text = objData.accidentDetails?.ownerPhone
        ragoNoLbl.text = objData.accidentDetails?.registrationNo
        proposedVehicle = objData.accidentDetails?.proposedVehicle ?? ""
        print("\(objData.accidentDetails?.proposedVehicle ?? "")")
        ragoNoLbl.textColor = UIColor(named: AppColors.BLACK)
        
    }
    
    func collectionNoteAPISuccess(objData: RANumbersListModel, strMessage: String, serviceKey: String) {
        if objData.arrResult.count > 0 {
            var temp = [String]()
            for i in 0...objData.arrResult.count - 1 {
                let data = objData.arrResult[i]
                temp.append(data.applicationId)
                if (collectionNoteDetail?.raNumber == data.raNumbersID){
                    selectedRANoData = data
                    setRANoData()
                }
            }
            arrRANumberList = objData.arrResult
            showSearchListPopUp(listForSearch: temp, listNameForSearch:AppDropDownLists.RANUNBER_NUMBER, notificationName: .searchListRA)
        }
    }
    
    func collectionNoteAPISuccess(objData: CollectedDocumentsModel, strMessage: String, serviceKey: String) {
        if objData.arrResult.count > 0 {
            arrcollectedDocumentsList = objData.arrResult
            let collectedDocArr = collectionNoteDetail?.documentsCollected.components(separatedBy: ",")
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
            print(collectedDocArr ?? "")
            print(arrcollectedDocumentsList)
            if UIDevice.current.userInterfaceIdiom == .pad {
                collectedDocumentsTblHeight.constant = 300
            } else {
                print(arrcollectedDocumentsList.count)
                collectedDocumentsTblHeight.constant = 200
            }
            //documentTblHight.constant = (CGFloat(arrcollectedDocumentsList.count) * 70) + 80
            //showToast(strMessage: strMessage)
        }
        collectedDocTblView.reloadData()
    }
    
    func collectionNoteAPISuccess(objData: RegoNumberListModel, strMessage: String, serviceKey: String) {
        if objData.arrResult.count > 0 {
            var temp = [String]()
            for i in 0...objData.arrResult.count - 1 {
                let data = objData.arrResult[i]
                temp.append(data.registrationNo)
                if (collectionNoteDetail?.regoNo == data.regoNoID){
                    selectedRegoData = data
                    setRegoNoData()
                }
            }
            arrRegoNumberList = objData.arrResult
            showSearchListPopUp(listForSearch: temp, listNameForSearch:AppDropDownLists.REGO_NUMBER, notificationName: .searchListRego)
        }
    }
    
    func collectionNoteAPISuccess(strMessage: String, serviceKey: String) {
        
    }
    
    func collectionNoteAPISuccess(objData: CollectionNotesModel, strMessage: String, serviceKey: String) {
        collectionNoteDetail = objData.collectionDetailsModel
        switch type {
        case .UPDATE:
            dismiss(animated: true)
            NotificationCenter.default.post(name: .collectionNoteListRefresh, object: self,userInfo: nil)
        case .ADD:
            dismiss(animated: true)
        case .DETAIL:
            showData()
        default:
            print("Invaild Type")
        }
    }
    
    func collectionNoteAPIFailure(strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
    }
}
