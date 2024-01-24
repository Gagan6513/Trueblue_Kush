//
//  NotesListVC.swift
//  TrueBlue
//
//  Created by Sharad Patil on 15/12/23.
//

import UIKit
import Alamofire

class NotesResponse: Codable {
    
    var data: NotesDataResponse?
    var status: Int?
    var msg:String?
    var statusCode: Int?
    
}

class NotesDataResponse: Codable {
    
    var response: [NotesResponseObject]?
}

class NotesResponseObject: Codable {
    
    var Created_date: String?
    var application_id: String?
    var from: String?
    var id: String?
    var ref_no: String?
    var registration_no: String?
    var remarks: String?
    var u_name: String?
    var url: String?
    var user_id: String?
    var vehicle_id: String?
    
}

struct ResponseObject {
    let createdDate: String
    let applicationId: Any?
    let from: String
    let id: Int
    let refNo: String
    let registrationNo: Any?
    let remarks: String
    let uName: String
    let url: Any?
    let userId: Int
    let vehicleId: Any?
    
    init(dictionary: [String: Any]) {
        createdDate = dictionary["Created_date"] as? String ?? ""
        applicationId = dictionary["application_id"]
        from = dictionary["from"] as? String ?? ""
        id = dictionary["id"] as? Int ?? 0
        refNo = dictionary["ref_no"] as? String ?? ""
        registrationNo = dictionary["registration_no"]
        remarks = dictionary["remarks"] as? String ?? ""
        uName = dictionary["u_name"] as? String ?? ""
        url = dictionary["url"]
        userId = dictionary["user_id"] as? Int ?? 0
        vehicleId = dictionary["vehicle_id"]
    }
}

class NotesListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var centerNotesView: UIView!
    @IBOutlet weak var notesTableVIew: UITableView!
    
    var notesArray = [String:String]()
    var allNotesArray: [ResponseObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.notesTableVIew.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        self.centerNotesView.backgroundColor = .clear //UIColor.black.withAlphaComponent(0.3)
        self.centerNotesView.isHidden = true
        getNotes()
        notesTableVIew.separatorStyle = .singleLine
//        notesTextView.layer.borderColor = UIColor(named: AppColors.BLUE)?.cgColor
//        notesTextView.layer.borderWidth =  0
        
    }
    
    func getNotes() {
        CommonObject.sharedInstance.showProgress()
        let newAPIPATH = API_PATH.replacingOccurrences(of: "newapp", with: "app")
        
        let application_id = CommonObject.sharedInstance.currentReferenceId.replacingOccurrences(of: "IV000", with: "")
        print(application_id)
        let requestURL = newAPIPATH + "getAllNotes"
        let parameters : Parameters = ["notesForId" : application_id,
                                       "notesFor"   : "reference"]
        let header: [String: String] = ["userId" : UserDefaults.standard.userId()]
        var newHeader = HTTPHeaders(header)
        //        apiPostRequest(parameters: parameters, endPoint: EndPoints.GET_AT_FAULT_DRIVER_DETAILS)
        
        if NetworkReachabilityManager()!.isReachable {
            AF.request(requestURL , method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: newHeader) { $0.timeoutInterval = 60 }.responseJSON { (response) in
                debugPrint(response)
                
                CommonObject.sharedInstance.stopProgress()
                if let mainDict = response.value as? [String : AnyObject] {
                    
                    print(mainDict)
                    let statusCode = mainDict["statusCode"] as? Int ?? 0
                    let message = mainDict["msg"] as? String ?? ""
                    
                    if statusCode == 5001 {
                        self.showAlertWithAction(title: alert_title, messsage: message) {
                            self.logout()
                        }
                        return
                    }
                    
                    if let responseData = mainDict["data"] as? [String: Any],
                       let responseArray = responseData["response"] as? [[String: Any]] {
                        
                        // Create an array of ResponseObject
                        let responseObjectArray = responseArray.map { ResponseObject(dictionary: $0) }
                        self.allNotesArray = responseObjectArray
                        self.notesTableVIew.reloadData()
                    } else {
                        print("Error parsing response")
                    }
                    let status = mainDict["status"] as? Int ?? 0
                    if status == 1{
                        CommonObject.sharedInstance.stopProgress()
                        
                        let dict = mainDict["data"] as? Dictionary<String, Any> ?? [:]
                        print(dict)
                        
                        
                        let strMsg = mainDict["msg"] as? String ?? ""
                        //                        self.delegateDataSync?.requestSuccess(dictObj: dict, serviceKey: endPoint, strMessage: strMsg)
                    } else {
                        CommonObject.sharedInstance.stopProgress()
                        let errorMsg = mainDict["msg"] as? String ?? ""
                        print(errorMsg)
                        
                    }
                } else{
                    //Diksha Rattan:Api Failure Response
                    CommonObject.sharedInstance.stopProgress()
                    
                }
            }
        }
    }
    
    func logout(){
        var vcId = String()
        if UIDevice.current.userInterfaceIdiom == .pad {
            vcId = AppStoryboardId.LOGIN
        } else {
            vcId = AppStoryboardId.LOGIN_PHONE
        }
        self.clearUserDefaults()
        let vc = UIStoryboard(name: AppStoryboards.MAIN, bundle: Bundle.main).instantiateViewController(withIdentifier: vcId)
        vc.modalPresentationStyle = .fullScreen
        if let topController = UIApplication.topViewController() {
            topController.present(vc, animated: true, completion: nil)
        }
    }
    
    func clearUserDefaults() {
        UserDefaults.standard.setUsername(value: "")
        UserDefaults.standard.setIsLoggedIn(value: false)
        UserDefaults.standard.setUserId(value: "")
    }
    
    func saveNotes() {
        CommonObject.sharedInstance.showProgress()
        let newAPIPATH = API_PATH.replacingOccurrences(of: "newapp", with: "app")
        
        let application_id = CommonObject.sharedInstance.currentReferenceId.replacingOccurrences(of: "IV000", with: "")
        print(application_id)
        
        let requestURL = newAPIPATH + "saveNotes"
        let parameters : Parameters = ["application_id" : application_id,
                                       "user_id" : UserDefaults.standard.userId(),
                                       "user_name" : UserDefaults.standard.username(),
                                       "notes" : notesTextView.text!,
                                       "request_from": "App"]
        let header: [String: String] = ["userId" : UserDefaults.standard.userId()]
        var newHeader = HTTPHeaders(header)
        //        apiPostRequest(parameters: parameters, endPoint: EndPoints.GET_AT_FAULT_DRIVER_DETAILS)
        
        if NetworkReachabilityManager()!.isReachable {
            AF.request(requestURL , method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: newHeader) { $0.timeoutInterval = 60 }.responseJSON { (response) in
                debugPrint(response)
                print(requestURL)
                let header: [String: String] = ["userId" : UserDefaults.standard.userId()]
                var newHeader = HTTPHeaders(header)
                
                CommonObject.sharedInstance.stopProgress()
                if let mainDict = response.value as? [String : AnyObject] {
                    print(mainDict)
                    
                    let statusCode = mainDict["statusCode"] as? Int ?? 0
                    let message = mainDict["msg"] as? String ?? ""
                    
                    if statusCode == 5001 {
                        self.showAlertWithAction(title: alert_title, messsage: message) {
                            self.logout()
                        }
                        return
                    }
                    
                    let status = mainDict["status"] as? Int ?? 0
                    if status == 1{
                        CommonObject.sharedInstance.stopProgress()
                        self.getNotes()
                        let dict = mainDict["data"] as? Dictionary<String, Any> ?? [:]
                        print(dict)
                        
                        
                        let strMsg = mainDict["msg"] as? String ?? ""
                        //                        self.delegateDataSync?.requestSuccess(dictObj: dict, serviceKey: endPoint, strMessage: strMsg)
                    } else {
                        CommonObject.sharedInstance.stopProgress()
                        let errorMsg = mainDict["msg"] as? String ?? ""
                        print(errorMsg)
                        
                    }
                } else{
                    //Diksha Rattan:Api Failure Response
                    CommonObject.sharedInstance.stopProgress()
                    
                }
            }
        }
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNotesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notesTableVIew.dequeueReusableCell(withIdentifier: AppTblViewCells.NOTES_LIST_TABLEVIEW_CELL, for: indexPath as IndexPath) as! NotesListTableViewCell
        cell.selectionStyle = .none
        cell.titleLabel.text = allNotesArray[indexPath.row].uName
        cell.descriptionLabel.text = allNotesArray[indexPath.row].remarks
        if(allNotesArray[indexPath.row].from == "App"){
            cell.notesImageView.image = UIImage(named: "App")
        } else {
            cell.notesImageView.image = UIImage(named: "website")
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: allNotesArray[indexPath.row].createdDate) {
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            
            cell.dateLabel.text = dateFormatter.string(from: date)
        }
        
        
        //        cell.imgView.image = UIImage(named: imageNames[indexPath.row])
        //        cell.titleLbl.text = screenNames[indexPath.row]
        return cell
    }
    
  
    
    @IBAction func closeNotesView(_ sender: Any) {
        notesTextView.text = ""
        centerNotesView.isHidden = true
    }
    @IBAction func saveNotes(_ sender: Any) {
        if(!notesTextView.text.isEmpty){
            self.saveNotes()
            self.notesTextView.text = ""
            self.centerNotesView.isHidden = true
        } else {
            showToast(strMessage: "Please enter notes description")
        }
    }
    
    
    @IBAction func showNotesView(_ sender: Any) {
//        self.notesTextView.text = ""
//        self.centerNotesView.isHidden = false
//        self.view.bringSubviewToFront(centerNotesView)
        
        let storyboard = UIStoryboard(name: AppStoryboards.DASHBOARD_PHONE, bundle: .main)
        let ctrl = storyboard.instantiateViewController(identifier: "AddNotesPopupVC") as! AddNotesPopupVC
        ctrl.modalPresentationStyle = .overFullScreen
        
        ctrl.notesDescStr = { [weak self] notes in
            guard let self else { return }
            self.notesTextView.text = notes
            self.saveNotes()
        }
        
        self.present(ctrl, animated: false)
    }
    
}
