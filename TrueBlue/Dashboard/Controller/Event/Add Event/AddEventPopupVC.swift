//
//  AddEventPopupVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 25/12/23.
//

import UIKit

class AddEventPopupVC: UIViewController {
    
    @IBOutlet weak var txtAddEvent: UITextField!
    @IBOutlet weak var txtAssignTo: UITextField!
    @IBOutlet weak var txtEventDate: UITextField!
    @IBOutlet weak var txtEventTime: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    
    var arrUserList = [UserList]()
    var arrType = [["title":"Collection Notes", "type":"collection_notes"],
                   ["title":"Delivery Notes", "type":"delivery_notes"],
                   ["title":"Todo Notes", "type":"todo_task"]]
    
    var selectedType = ""
    var selectedUserId = ""
    
    var eventType = UIPickerView()
    var assign = UIPickerView()
    var eventDate = UIDatePicker()
    var eventTime = UIDatePicker()
    
    var dateFormater = DateFormatter()
    var timeFormater = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.getUserList()
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
        
        NotificationCenter.default.addObserver(forName: .searchUser, object: nil, queue: nil, using: { [weak self] data in
            guard let self else { return }
            let noti = (data.userInfo as? NSDictionary)?.value(forKey: "selectedItem") as? String ?? ""
            
            if let data = self.arrUserList.first(where: { $0.name == noti }) {
                self.txtAssignTo.text = data.name
                self.selectedUserId = data.id ?? ""
            }
        })
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
        self.addEventType()
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
        } else {
            self.txtAssignTo.text = self.arrUserList.first?.name
            self.selectedUserId = self.arrUserList.first?.id ?? ""
            return self.arrUserList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.eventType {
            return self.arrType[row]["title"]
        } else {
            return self.arrUserList[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.eventType {
            self.txtAddEvent.text = self.arrType[row]["title"]
            self.selectedType = self.arrType[row]["type"] ?? ""
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
    
    func addEventType() {
        
        let api_dateFormater = DateFormatter()
        api_dateFormater.dateFormat =  "dd-MM-yyyy"
        let api_date = api_dateFormater.date(from: self.txtEventDate.text ?? "") ?? Date()
        api_dateFormater.dateFormat =  "yyyy-MM-dd"
        let api_new_date = api_dateFormater.string(from: api_date)
        
        let request = WebServiceModel()
        request.url = URL(string: API_URL.save_event)!
        request.parameters = ["userId": UserDefaults.standard.userId(),
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
}
