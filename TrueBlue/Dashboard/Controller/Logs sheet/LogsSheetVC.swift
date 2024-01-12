//
//  LogsSheetVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 12/01/24.
//

import UIKit
import Applio

class LogsSheetVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var allNotesArray: [NotesResponseObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(for: "LogSheetTVC")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getLogSheet()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension LogsSheetVC {
    
    func getLogSheet() {
        CommonObject().showProgress()
        
        /* Create API Request */
        let webService = WebServiceModel()
        webService.url = URL(string: API_URL.logSheet)!
        webService.method = .post
        
        let application_id = CommonObject.sharedInstance.currentReferenceId.replacingOccurrences(of: "IV000", with: "")
        
        var param = [String: Any]()
        param["notesForId"] = application_id
        param["notesFor"] = "all"
        
        webService.parameters = param
        
        /* API CALLS */
        WebService.shared.performMultipartWebService(model: webService, imageData: []) { [weak self] responseData, error in
            guard let self else { return }
            
            CommonObject().stopProgress()
            self.tableView.isHidden = false
            
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
                    
                    self.allNotesArray = data.data?.response ?? [NotesResponseObject]()
                    
                    self.tableView.reloadData()
                    
                }
            }
        }
    }
    
}

extension LogsSheetVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.allNotesArray.count != 0 {
            tableView.removeBackgroundView()
            return self.allNotesArray.count
        }
        tableView.setBackgroundView(msg: .log_list_empty)
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LogSheetTVC") as? LogSheetTVC else { return UITableViewCell() }
        cell.setupDetails(data: self.allNotesArray[indexPath.row])
        return cell
    }
    
    
}
