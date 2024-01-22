//
//  AddEventPopupVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 25/12/23.
//

import UIKit

class AddEventPopupVC: UIViewController {
    
    @IBOutlet weak var addEvent: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var assignToView: UIView!
    @IBOutlet weak var txtAddEvent: UITextField!
    @IBOutlet weak var txtAssignTo: UITextField!
    @IBOutlet weak var txtEventDate: UITextField!
    @IBOutlet weak var txtEventTime: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtReferenceNo: UITextField!
    
    @IBOutlet weak var txtRemark: UITextView!
    @IBOutlet weak var descTitle: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var txtStatus: UITextField!
    
    @IBOutlet weak var viewRemark: UIView!
    
    var selectedEvent: Events?
    var arrUserList = [UserList]()
    var arrReferenceModel = [ReferenceResponseModel]()
    var selectedReference: ReferenceResponseModel?
    var arrType = [["title":"Collection Notes", "type":"collection_notes"],
                   ["title":"Delivery Notes", "type":"delivery_notes"],
                   ["title":"Todo Notes", "type":"todo_task"]]
    
    var arrStatus = [["title":"Pending", "type":"pending"],
                   ["title":"Collected", "type":"collected"],
                     ["title":"Overdue", "type":"overdue"],
                     ["title":"Delivered", "type":"delivered"]]
    var selectedStatus = ""
    
    var selectedType = ""
    var selectedUserId = ""
    
    var eventType = UIPickerView()
    var referencePicker = UIPickerView()
    var assign = UIPickerView()
    var status = UIPickerView()
    var eventDate = UIDatePicker()
    var eventTime = UIDatePicker()
    
    var dateFormater = DateFormatter()
    var timeFormater = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.getUserList()
        self.getRefrenceList()
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func btnTime(_ sender: Any) {
        var storyboardName = String()
        var vcId = String()
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboardName = AppStoryboards.DASHBOARD
            vcId = AppStoryboardId.SELECT_TIME
        } else {
            storyboardName = AppStoryboards.DASHBOARD_PHONE
            vcId = AppStoryboardId.SELECT_TIME_PHONE
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        let ctrl = storyboard.instantiateViewController(identifier: vcId) as! SelectTimeVC
        ctrl.modalPresentationStyle = .overFullScreen
        ctrl.selectedDate = { [weak self] date in
            guard let self else { return }
            self.txtEventTime.text = date
        }
        self.present(ctrl, animated: false)
    }
    
    @IBAction func btnDate(_ sender: Any) {
        var storyboardName = String()
        var vcId = String()
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboardName = AppStoryboards.DASHBOARD
            vcId = AppStoryboardId.SELECT_DATE
        } else {
            storyboardName = AppStoryboards.DASHBOARD_PHONE
            vcId = AppStoryboardId.SELECT_DATE_PHONE
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        let ctrl = storyboard.instantiateViewController(identifier: vcId) as! SelectDateVC
        ctrl.modalPresentationStyle = .overFullScreen
        ctrl.selectedDate = { [weak self] date in
            guard let self else { return }
            self.txtEventDate.text = date
        }
        self.present(ctrl, animated: false)
    }
    
    @IBAction func btnSave(_ sender: Any) {
        self.validateTextField()
    }
    
    func setupUI() {
        self.dateFormater.dateFormat = "dd-MM-YYYY"
        self.timeFormater.dateFormat = "hh:mm a"
        
        self.eventDate.minimumDate = Date()
        
        self.eventDate.datePickerMode = .date
        self.eventDate.preferredDatePickerStyle = .wheels
        
        self.eventTime.datePickerMode = .time
        self.eventTime.preferredDatePickerStyle = .wheels
        
        //        self.txtEventDate.inputView = self.eventDate
        //        self.txtEventTime.inputView = self.eventTime
        
        self.txtAddEvent.inputView = self.eventType
        //        self.txtAssignTo.inputView = self.assign
        self.txtAssignTo.delegate = self
        
        self.txtEventDate.delegate = self
        self.txtEventTime.delegate = self
        
        self.eventType.delegate = self
        self.eventType.dataSource = self
        
        self.assign.delegate = self
        self.assign.dataSource = self
        
        self.status.delegate = self
        self.status.dataSource = self
        
        self.txtStatus.inputView = self.status
        
        self.txtReferenceNo.delegate = self
        
        NotificationCenter.default.addObserver(forName: .searchUser, object: nil, queue: nil, using: { [weak self] data in
            guard let self else { return }
            let noti = (data.userInfo as? NSDictionary)?.value(forKey: "selectedItem") as? String ?? ""
            
            if let data = self.arrUserList.first(where: { $0.name == noti }) {
                self.txtAssignTo.text = data.name
                self.selectedUserId = data.id ?? ""
            }
        })
        
        NotificationCenter.default.addObserver(forName: .searchReferenceNo, object: nil, queue: nil, using: { [weak self] data in
            guard let self else { return }
            let noti = (data.userInfo as? NSDictionary)?.value(forKey: "selectedItem") as? String ?? ""
            
            if let data = self.arrReferenceModel.first(where: { $0.application_id == noti }) {
                self.txtReferenceNo.text = data.application_id
                self.selectedReference = data
            }
        })
        
        self.txtAssignTo.text = selectedEvent?.ASSIGNED_TO_USER
        self.txtEventDate.text = selectedEvent?.EVENT_DATE
        if (self.selectedEvent?.EVENT_TIME ?? "") == "00:00:00" {
            self.txtEventTime.text = ""
        } else {
            self.txtEventTime.text = selectedEvent?.EVENT_TIME
        }
        
        
        self.txtDescription.text = selectedEvent?.EVENT_DESC
        self.txtRemark.text = selectedEvent?.REMARKS
        
        self.viewRemark.isHidden = selectedEvent == nil
        
        self.txtAddEvent.text = self.arrType.first(where: { $0["type"] == selectedEvent?.EVENT_TYPE ?? "" })?["title"] ?? ""
        self.selectedType = selectedEvent?.EVENT_TYPE ?? ""
        self.selectedUserId = selectedEvent?.ASSIGNED_TO ?? ""
        self.txtReferenceNo.text = selectedEvent?.APP_ID ?? ""
        
        if let event = selectedEvent {
            var reference = ReferenceResponseModel()
            reference.id = event.APPLICATION_ID
            reference.application_id = event.APP_ID
            self.selectedReference = reference
        }
        
        self.titleLabel.text = self.selectedEvent == nil ? "Add Event" : "Edit Event"
        
        self.selectedStatus = self.selectedEvent?.STAGE ?? ""
        self.txtStatus.text = self.arrStatus.first(where: { $0["type"] == selectedEvent?.STAGE ?? "" })?["title"] ?? ""
        self.viewStatus.isHidden = self.selectedEvent == nil
        self.addEvent.isHidden = self.selectedEvent != nil
        self.assignToView.isHidden = self.selectedEvent != nil

    }
        
    func validateTextField() {
        if self.txtAddEvent.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please selecte events.")
            return
        }
        if self.txtAssignTo.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please selecte assign to.")
            return
        }
        
        if (self.selectedReference?.application_id?.isEmpty ?? true) {
            showAlert(title: "Error!", messsage: "Please selecte reference no.")
            return
        }
        
        if self.txtEventDate.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please selecte event date.")
            return
        }
//        if self.txtEventTime.text?.isEmpty ?? true {
//            showAlert(title: "Error!", messsage: "Please selecte event time.")
//            return
//        }
        if self.txtDescription.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please enter event description.")
            return
        }
        
        if selectedEvent != nil {
            if self.txtRemark.text?.isEmpty ?? true {
                showAlert(title: "Error!", messsage: "Please enter event remark.")
                return
            }
        }
        
        if self.selectedEvent == nil {
            self.addEventType()
        } else {
            self.updateEventType()
        }
    }
}

extension AddEventPopupVC: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == self.txtEventDate {
//            self.txtEventDate.text = dateFormater.string(from: self.eventDate.date)
//        } else if textField == self.txtEventTime {
//            self.txtEventTime.text = timeFormater.string(from: self.eventTime.date)
//        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtAssignTo {
            let array = self.arrUserList.map({ $0.name ?? "" })
            self.showSearchListPopUp(listForSearch: array, listNameForSearch: AppDropDownLists.SEARCH_USER_LIST, notificationName: .searchUser)
            DispatchQueue.main.async {
                self.view.endEditing(true)
            }
        } else if textField == self.txtReferenceNo {
            let array = self.arrReferenceModel.map({ $0.application_id ?? "" })
            self.showSearchListPopUp(listForSearch: array, listNameForSearch: AppDropDownLists.Reference_No, notificationName: .searchReferenceNo)
            DispatchQueue.main.async {
                self.view.endEditing(true)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var isAllowed = true
        switch textField {
        case txtEventDate:
            isAllowed = textField.validateDateTyped(shouldChangeCharactersInRange: range, replacementString: string)
        case txtEventTime :
            isAllowed = textField.validateTimeTyped(shouldChangeCharactersInRange: range, replacementString: string)
        default:
            print("TextField without restriction")
        }
        return isAllowed
    }
    
}

extension AddEventPopupVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.eventType {
            self.txtAddEvent.text = self.arrType.first?["title"]
            self.selectedType = self.arrType.first?["type"] ?? ""
            return self.arrType.count
        } else if pickerView == self.status {
            self.txtStatus.text = self.arrStatus.first?["title"]
            self.selectedStatus = self.arrStatus.first?["type"] ?? ""
            return self.arrStatus.count
        } else if pickerView == self.referencePicker {
            self.txtReferenceNo.text = self.arrReferenceModel.first?.application_id
            self.selectedReference = self.arrReferenceModel.first
            return self.arrReferenceModel.count
        } else {
            self.txtAssignTo.text = self.arrUserList.first?.name
            self.selectedUserId = self.arrUserList.first?.id ?? ""
            return self.arrUserList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.eventType {
            return self.arrType[row]["title"]
        } else if pickerView == self.status {
            return self.arrStatus[row]["title"]
        } else if pickerView == self.referencePicker {
            return self.arrReferenceModel[row].application_id
        } else {
            return self.arrUserList[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.eventType {
            self.txtAddEvent.text = self.arrType[row]["title"]
            self.selectedType = self.arrType[row]["type"] ?? ""
        } else if pickerView == self.status {
            self.txtStatus.text = self.arrStatus[row]["title"]
            self.selectedStatus = self.arrStatus[row]["type"] ?? ""
        } else if pickerView == self.referencePicker {
            self.txtReferenceNo.text = self.arrReferenceModel[row].application_id
            self.selectedReference = self.arrReferenceModel[row]
        } else {
            self.txtAssignTo.text = self.arrUserList[row].name
            self.selectedUserId = self.arrUserList[row].id ?? ""
        }
    }
    
}


extension AddEventPopupVC {
    
    func getUserList() {
        
        let request = WebServiceModel()
        request.url = URL(string: API_URL.getUserList)!
        request.method = .post
        
        WebService.shared.performWebService(model: request, complition: { [weak self] responseData, error in
            guard let self else { return }
            
            CommonObject().stopProgress()

            if let error {
                /* API ERROR */
                showAlert(title: "Error!", messsage: "\(error)")
                return
            }
            
            /* CONVERT JSON DATA TO MODEL */
            if let data = responseData?.convertData(UserModel.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? UserModel {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    self.arrUserList = data.data?.response ?? []
                }
            }
        })
    }
    
    func getRefrenceList() {
        
        let request = WebServiceModel()
        request.url = URL(string: API_URL.getReferenceList)!
        request.method = .post
        
        WebService.shared.performWebService(model: request, complition: { [weak self] responseData, error in
            guard let self else { return }
            
            CommonObject().stopProgress()

            if let error {
                /* API ERROR */
                showAlert(title: "Error!", messsage: "\(error)")
                return
            }
            
            /* CONVERT JSON DATA TO MODEL */
            if let data = responseData?.convertData(ReferenceModel.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? ReferenceModel {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    self.arrReferenceModel = data.data?.response ?? []
                }
            }
        })
    }
    
    func addEventType() {
        
        let api_dateFormater = DateFormatter()
        api_dateFormater.dateFormat =  "dd-MM-yyyy"
        let api_date = api_dateFormater.date(from: self.txtEventDate.text ?? "") ?? Date()
        api_dateFormater.dateFormat =  "yyyy-MM-dd"
        let api_new_date = api_dateFormater.string(from: api_date)
        
        let request = WebServiceModel()
        request.url = URL(string: API_URL.save_event)!
        request.parameters = ["userId": UserDefaults.standard.userId(),
                              "applicationId": self.selectedReference?.id ?? "",
                              "assignTo": self.selectedUserId,
                              "eventDate": "\(api_new_date)", // 2023-12-25
                              "eventTime": (self.txtEventTime.text != "") ? (self.txtEventTime.text ?? "") : "", // 10:00
                              "eventDesc": self.txtDescription.text ?? "",
                              "eventType": self.selectedType]
        request.method = .post
        
        WebService.shared.performMultipartWebService(model: request, imageData: [], complition: { [weak self] responseData, error in
            guard let self else { return }
            
            CommonObject().stopProgress()

            if let error {
                /* API ERROR */
                showAlert(title: "Error!", messsage: "\(error)")
                return
            }
            
            /* CONVERT JSON DATA TO MODEL */
            if let data = responseData?.convertData(UserModel.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? UserModel {
                    NotificationCenter.default.post(name: .eventListRefresh, object: nil)
                    showGlobelAlert(title: alert_title, msg: data.msg ?? "", doneAction: { [weak self] _ in
                        guard let self else { return }
                        if data.status == 1 {
                            self.dismiss(animated: false)
                        }
                    })
                }
            }
        })
    }
    
    func updateEventType() {
        
        let api_dateFormater = DateFormatter()
        api_dateFormater.dateFormat =  "dd-MM-yyyy"
        let api_date = api_dateFormater.date(from: self.txtEventDate.text ?? "") ?? Date()
        api_dateFormater.dateFormat =  "yyyy-MM-dd"
        let api_new_date = self.txtEventDate.text ?? "" // api_dateFormater.string(from: api_date)
        
        let request = WebServiceModel()
        request.url = URL(string: API_URL.update_event)!
        request.parameters = ["userId": UserDefaults.standard.userId(),
                              "applicationId": self.selectedReference?.id ?? "",
                              "userName": UserDefaults.standard.username(),
                              "eventId": self.selectedEvent?.ID ?? "",
                              "eventStage": self.selectedStatus.lowercased(),
                              "eventDate": "\(api_new_date)", // 2023-12-25
                              "eventTime": (self.txtEventTime.text != "") ? (self.txtEventTime.text ?? "") : "", // 10:00
                              "eventRemarks": self.txtRemark.text ?? "",
                              "eventDesc": self.txtDescription.text ?? "",
                              "eventType": self.selectedType]
        request.method = .post
        
        WebService.shared.performMultipartWebService(model: request, imageData: [], complition: { [weak self] responseData, error in
            guard let self else { return }
            
            CommonObject().stopProgress()

            if let error {
                /* API ERROR */
                showAlert(title: "Error!", messsage: "\(error)")
                return
            }
            
            /* CONVERT JSON DATA TO MODEL */
            if let data = responseData?.convertData(UserModel.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? UserModel {
                    NotificationCenter.default.post(name: .eventListRefresh, object: nil)
                    showGlobelAlert(title: alert_title, msg: data.msg ?? "", doneAction: { [weak self] _ in
                        guard let self else { return }
                        if data.status == 1 {
                            self.dismiss(animated: false)
                        }
                    })
                }
            }
        })
    }
}
