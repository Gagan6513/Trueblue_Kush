//
//  UserVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira iMac on 04/01/24.
//

import UIKit

class UserVC: UIViewController {

//    MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
//    MARK: - Variable
    var allUserData = AllUserModel()
    
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
                self.logoutUser(data: data)
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
        param["userId"] = data.username ?? ""
        param["requestFrom"] = request_from
        param["createdBy"] = "1"
        param["isForceLogout"] = "1"
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
                    self.getUserData()
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
        
        self.getUserData()
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
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
}
