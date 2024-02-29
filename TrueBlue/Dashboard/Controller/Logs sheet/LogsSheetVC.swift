//
//  LogsSheetVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 12/01/24.
//

import UIKit
import Applio

class LogsSheetVC: UIViewController {

    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnFilter: UIButton!
    
    var allNotesArray: [NotesResponseObject] = []
    var filterAllNotesArray: [NotesResponseObject] = []
    var search = ""
    var startDate = ""
    var noteType = ""
    var endDate = ""
    var selectedEmployee: UserList?
    
    var isFromFilter = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchView.isHidden = true
        self.txtSearch.delegate = self
        self.tableView.registerNib(for: "LogSheetTVC")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.btnFilter.layoutIfNeeded()
        self.btnFilter.layoutSubviews()
        self.btnFilter.layer.cornerRadius = self.btnFilter.layer.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getLogSheet()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnFilter(_ sender: Any) {
        let ctrl = self.storyboard?.instantiateViewController(withIdentifier: "LogSheetFilterVC") as! LogSheetFilterVC
        ctrl.modalPresentationStyle = .overFullScreen
        ctrl.view.isOpaque = false
        
        ctrl.startDate = self.startDate
        ctrl.endDate = self.endDate
        ctrl.selectedUserId = self.selectedEmployee
        ctrl.noteType = self.noteType
        
        ctrl.dateClosure = { [weak self] fromdate, todate, emplyee, noteType in
            guard let self else { return }
            self.isFromFilter = true
            self.startDate = fromdate
            self.endDate = todate
            self.noteType = noteType
            self.selectedEmployee = emplyee
            self.getLogSheet()
        }
        self.present(ctrl, animated: false)
    }
    
    @IBAction func btnOpenSearchPopup(_ sender: Any) {
        self.txtSearch.becomeFirstResponder()
        self.searchView.isHidden = false
    }
    
    @IBAction func btnSearch(_ sender: Any) {
        self.txtSearch.resignFirstResponder()
        self.searchView.isHidden = true
        self.filterData()
    }
}

extension LogsSheetVC: UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        search = string.isEmpty ? String(search.dropLast()) : (textField.text! + string)
        self.filterAllNotesArray = self.allNotesArray.filter({ $0.u_name?.lowercased().contains(search.lowercased()) ?? false})
        if search == "" {
            self.filterAllNotesArray = self.allNotesArray
        }
        self.tableView.reloadData()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        if textField == txtSearch && ((txtSearch.text?.isEmpty) != nil){
            self.searchView.isHidden = true
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.filterAllNotesArray = self.allNotesArray
        self.tableView.reloadData()
        return true
    }
    
    func filterData() {
        if (self.txtSearch.text ?? "") == "" {
            self.filterAllNotesArray = self.allNotesArray
        } else {
            self.filterAllNotesArray = self.allNotesArray.filter({ $0.u_name?.lowercased() == self.txtSearch.text?.lowercased()})
        }
        self.tableView.reloadData()
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
        
//        if self.isFromFilter {
            param["fromDate"] = self.startDate
            param["toDate"] = self.endDate
            param["emplyee"] = self.selectedEmployee?.id ?? "0"
        
        if self.noteType != "" {
            param["notes_type"] = self.noteType
        }
//        }
        
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
                    self.filterAllNotesArray = self.allNotesArray
                    self.tableView.reloadData()
                    
                }
            }
        }
    }
    
}

extension LogsSheetVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.filterAllNotesArray.count != 0 {
            tableView.removeBackgroundView()
            return self.filterAllNotesArray.count
        }
        tableView.setBackgroundView(msg: .log_list_empty)
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LogSheetTVC") as? LogSheetTVC else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.setupDetails(data: self.filterAllNotesArray[indexPath.row])
        return cell
    }
    
    
}
