//
//  LogSheetFilterVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 27/02/24.
//

import UIKit

class LogSheetFilterVC: UIViewController {
    
    @IBOutlet weak var firstStack: UIStackView!
    
    @IBOutlet weak var txtFrom: UITextField!
    @IBOutlet weak var txtTo: UITextField!
    @IBOutlet weak var txtEmployeeName: UITextField!
    
    var fromDatePicker = UIDatePicker()
    var toDatePicker = UIDatePicker()
    
    var dateFormater = DateFormatter()
    var dateClosure: ((_ fromDate: String, _ toDate: String, _ employee: UserList?) -> Void)?
    
    var startDate = ""
    var endDate = ""
    
    var arrUserList = [UserList]()
    var selectedUserId: UserList?

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func btnSave(_ sender: Any) {
//        if validateTextField() {
            self.dateClosure?(self.txtFrom.text ?? "", self.txtTo.text ?? "", self.selectedUserId)
            self.dismiss(animated: false)
//        }
    }
    
    @IBAction func btnFromDate(_ sender: Any) {
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
            self.txtFrom.text = date
        }
        self.present(ctrl, animated: false)
    }
    
    @IBAction func btnToDate(_ sender: Any) {
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
            self.txtTo.text = date
        }
        self.present(ctrl, animated: false)
    }
    
    func setupUI() {
        
        self.txtFrom.text = self.startDate
        self.txtTo.text = self.endDate
        self.txtEmployeeName.text = self.selectedUserId?.name
        
        self.getUserList()
        self.dateFormater.dateFormat = "dd-MM-YYYY"
        
        self.firstStack.axis = UIDevice.current.userInterfaceIdiom == .pad ? .horizontal : .vertical
        
        self.fromDatePicker.datePickerMode = .date
        self.toDatePicker.datePickerMode = .date
        
        self.txtFrom.delegate = self
        self.txtTo.delegate = self
        self.txtEmployeeName.delegate = self
        
        self.fromDatePicker.preferredDatePickerStyle = .wheels
        self.toDatePicker.preferredDatePickerStyle = .wheels
        
        NotificationCenter.default.addObserver(forName: .searchUser, object: nil, queue: nil, using: { [weak self] data in
            guard let self else { return }
            let noti = (data.userInfo as? NSDictionary)?.value(forKey: "selectedItem") as? String ?? ""
            
            if let data = self.arrUserList.first(where: { $0.name == noti }) {
                self.txtEmployeeName.text = data.name
                self.selectedUserId = data
            } else {
                self.txtEmployeeName.text = noti
                let UserList = UserList()
                UserList.name = noti
                self.selectedUserId = UserList
            }
        })
    }
    
    func validateTextField() -> Bool {
        
        if self.txtFrom.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please select from date.")
            return false
        }
        
        if self.txtTo.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please select to date.")
            return false
        }
        
        return true
    }
}

extension LogSheetFilterVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtEmployeeName {
            var array = self.arrUserList.map({ $0.name ?? "" })
            array.insert("All", at: 0)
            self.showSearchListPopUp(listForSearch: array, listNameForSearch: AppDropDownLists.SEARCH_USER_LIST, notificationName: .searchUser)
            DispatchQueue.main.async {
                self.view.endEditing(true)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var isAllowed = true
        switch textField {
        case txtFrom, txtTo:
            isAllowed = textField.validateDateTyped(shouldChangeCharactersInRange: range, replacementString: string)
        default:
            print("TextField without restriction")
        }
        return isAllowed
    }
}

extension LogSheetFilterVC {
    
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
}
