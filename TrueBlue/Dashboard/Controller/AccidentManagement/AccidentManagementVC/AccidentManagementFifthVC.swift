//
//  AccidentManagementFifthVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 17/01/24.
//

import UIKit
import Applio

class AccidentManagementFifthVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var allNotesArray: [NotesResponseObject] = []
    var accidentData: AccidentMaintenance?
    
    var applicationId: String? {
        didSet {
            if let _ = self.applicationId {
                self.getAllNotes()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(for: "LogSheetTVC")
        self.setupNotification()
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(forName: .AccidentDetails, object: nil, queue: nil, using: { [weak self] noti in
            guard let self else { return }
            
            if let applicationId = (noti.userInfo as? NSDictionary)?.value(forKey: "ApplicationId") as? String {
                self.applicationId = applicationId
            }
        })
    }
    
    @IBAction func showNotesView(_ sender: Any) {
        let storyboard = UIStoryboard(name: AppStoryboards.DASHBOARD_PHONE, bundle: .main)
        let ctrl = storyboard.instantiateViewController(identifier: "AddNotesPopupVC") as! AddNotesPopupVC
        ctrl.modalPresentationStyle = .overFullScreen
        
        ctrl.notesDescStr = { [weak self] notes in
            guard let self else { return }
            self.saveNotes(noteStr: notes)
        }
        
        self.present(ctrl, animated: false)
    }
    
}

extension AccidentManagementFifthVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.allNotesArray.count != 0 {
            tableView.removeBackgroundView()
            return self.allNotesArray.count
        }
        tableView.setBackgroundView(msg: .note_list_empty)
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LogSheetTVC") as? LogSheetTVC else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.setupDetails(data: self.allNotesArray[indexPath.row])
        return cell
    }
    
}

extension AccidentManagementFifthVC {
    
    func getAllNotes() {
        CommonObject().showProgress()
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.getAllNotes)!
        webService.method = .post
        
        var param = [String: Any]()
        param["notesFor"] = "reference"
        param["notesForId"] = self.applicationId
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
            if let data = responseData?.convertData(NotesResponse.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? NotesResponse {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    
                    self.allNotesArray = data.data?.response ?? []
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func saveNotes(noteStr: String) {
        CommonObject().showProgress()
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.saveNotes)!
        webService.method = .post
        
        var param = [String: Any]()
        param["application_id"] = self.applicationId
        param["user_id"] = UserDefaults.standard.userId()
        param["user_name"] = UserDefaults.standard.username()
        param["notes"] = noteStr
        param["request_from"] = "App"
        
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
            if let data = responseData?.convertData(NotesResponse.self) {
                if let error = data as? String {
                    /* JSON ERROR */
                    showAlert(title: "Error!", messsage: "\(error)")
                    return
                }
                if let data = data as? NotesResponse {
                    if (data.status ?? 0) == 0 {
                        showAlert(title: "Error!", messsage: data.msg ?? "")
                        return
                    }
                    
                    let dict: [String: Any] = ["currentIndex" : 5 ]
                    NotificationCenter.default.post(name: .AccidentDetails, object: nil, userInfo: dict)
                    self.getAllNotes()
                }
            }
        }
    }
}
