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
    
    @IBAction func btnSave(_ sender: Any) {
        self.validateTextField()
    }
    
    func setupUI() {
        self.dateFormater.dateFormat = "dd-MM-YYYY"
        self.timeFormater.dateFormat = "hh:mm a"
        self.eventDate.datePickerMode = .date
        self.eventDate.preferredDatePickerStyle = .wheels
        
        self.eventTime.datePickerMode = .time
        self.eventTime.preferredDatePickerStyle = .wheels
        
        self.txtEventDate.inputView = self.eventDate
        self.txtEventTime.inputView = self.eventTime
        
        self.txtAddEvent.inputView = self.eventType
        self.txtAssignTo.inputView = self.assign
        
        self.txtEventDate.delegate = self
        self.txtEventTime.delegate = self
        
        self.eventType.delegate = self
        self.eventType.dataSource = self
        
        self.assign.delegate = self
        self.assign.dataSource = self
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
        if self.txtEventTime.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please selecte event time.")
            return
        }
        if self.txtDescription.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please enter event description.")
            return
        }
        self.addEventType()
    }
}

extension AddEventPopupVC: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtEventDate {
            self.txtEventDate.text = dateFormater.string(from: self.eventDate.date)
        } else {
            self.txtEventTime.text = timeFormater.string(from: self.eventTime.date)
        }
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
        api_dateFormater.dateFormat =  "YYYY-MM-dd"
        let api_date = api_dateFormater.string(from: self.eventDate.date)
        
        let api_timeFormater = DateFormatter()
        api_timeFormater.dateFormat =  "HH:mm"
        let api_time = api_timeFormater.string(from: self.eventTime.date)
        
        let request = WebServiceModel()
        request.url = URL(string: API_URL.save_event)!
        request.parameters = ["userId": UserDefaults.standard.userId(),
                              "assignTo": self.selectedUserId,
                              "eventDate": api_date, // 2023-12-25
                              "eventTime": api_time, // 10:00
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
                    showGlobelAlert(title: APP_NAME, msg: data.msg ?? "", doneAction: { [weak self] _ in
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
