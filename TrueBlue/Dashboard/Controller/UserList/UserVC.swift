//
//  UserVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira iMac on 04/01/24.
//

import UIKit

class UserVC: UIViewController {

//    MARK: - Outlet
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
//    MARK: - Variable
    var allUserData = AllUserModel()
    var filterData = [AllUserListData]()
    var search = ""
    
//    MARK: - Override Function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
//    MARK: - Button Action
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

//MARK: - Tableview Delegate and Datasource
extension UserVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.allUserData.data?.response?.count, count != 0 {
            tableView.removeBackgroundView()
            return count
        }
        tableView.setBackgroundView(msg: .user_list_empty)
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserListTVC", for: indexPath) as? UserListTVC else { return UITableViewCell() }
        if let data = self.allUserData.data?.response?[indexPath.row] {
            cell.setData(data: data)
            
            cell.isLogoutClicked = { [weak self] in
                guard let self else { return }
                let msg = (data.LOGOUT_ID ?? "").lowercased() == "0" ? "Are you sure you want to logout this user?" : "Are you sure you want to login this user?"
                showAlert(message: msg, yesTitle: "No", noTitle: "Yes", yesAction: {
                    
                }, noAction: {
                    self.logoutUser(data: data)
                })
            }
        }
        return cell
    }
    
    func logoutUser(data: AllUserListData) {
        CommonObject().showProgress()
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.force_logout_user)!
        webService.method = .post
        var param = [String: String]()
        param["userId"] = data.id ?? ""
        param["requestFrom"] = request_from
        param["createdBy"] = UserDefaults.standard.userId()
        param["isForceLogout"] = (data.LOGOUT_ID ?? "").lowercased() == "0" ? "1" : "0"
        webService.parameters = param
        
        /* API CALLS */
        WebService.shared.performMultipartWebService(model: webService, imageData: []) { [weak self] responseData, error in
            guard let self else { return }
            
            CommonObject().stopProgress()

            if let error {
                /* API ERROR */
                showAlert(title: "Error!", messsage: "\(error)")
                return
            }
            
            /* CONVERT JSON DATA TO MODEL */
            if let data = responseData?.convertData(AllUserModel.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? AllUserModel {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    showAlertWithAction(title: alert_title, messsage: data.msg ?? "") {
                        self.getUserData()
                    }
                }
            }
        }
    }
    
}

//MARK: - Custom Function
extension UserVC {
    func setupUI() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(for: "UserListTVC")
        self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        self.searchTextField.delegate = self
        
        self.getUserData()
    }
}

extension UserVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        search = string.isEmpty ? String(search.dropLast()) : textField.text!+string
        
        self.allUserData.data?.response = self.filterData
        
        self.allUserData.data?.response = self.allUserData.data?.response?.filter{$0.username?.lowercased().contains(search.lowercased()) ?? false}
        
        if search == "" {
            self.allUserData.data?.response = self.filterData
        }
        self.tableView.reloadData()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.allUserData.data?.response = self.filterData
        self.tableView.reloadData()
        return true
    }
}

extension UserVC {
    
    func getUserData() {
        CommonObject().showProgress()
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.get_all_user)!

        
        /* API CALLS */
        WebService.shared.performMultipartWebService(model: webService, imageData: []) { [weak self] responseData, error in
            guard let self else { return }
            
            CommonObject().stopProgress()

            if let error {
                /* API ERROR */
                showAlert(title: "Error!", messsage: "\(error)")
                return
            }
            
            /* CONVERT JSON DATA TO MODEL */
            if let data = responseData?.convertData(AllUserModel.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? AllUserModel {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    
                    self.allUserData = data
                    self.filterData = data.data?.response ?? []
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
}
