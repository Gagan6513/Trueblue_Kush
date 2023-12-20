//
//  NotesListVC.swift
//  TrueBlue
//
//  Created by Sharad Patil on 15/12/23.
//

import UIKit
import Alamofire


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
        centerNotesView.backgroundColor = .clear //UIColor.black.withAlphaComponent(0.3)
        getNotes()
        notesTableVIew.separatorStyle = .singleLine
        notesTextView.layer.borderColor = UIColor(named: AppColors.BLUE)?.cgColor
        notesTextView.layer.borderWidth =  0
        
    }
    
    func getNotes() {
        CommonObject.sharedInstance.showProgress()
        let newAPIPATH = API_PATH.replacingOccurrences(of: "newapp", with: "app")
        let requestURL = newAPIPATH + "getAllNotes"
        let parameters : Parameters = ["application_id" : CommonObject.sharedInstance.currentReferenceId]
        //        apiPostRequest(parameters: parameters, endPoint: EndPoints.GET_AT_FAULT_DRIVER_DETAILS)
        
        if NetworkReachabilityManager()!.isReachable {
            AF.request(requestURL , method: .post, parameters: parameters, encoding: URLEncoding.httpBody) { $0.timeoutInterval = 60 }.responseJSON { (response) in
                debugPrint(response)
                
                CommonObject.sharedInstance.stopProgress()
                if let mainDict = response.value as? [String : AnyObject] {
                    
                    print(mainDict)
                    
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
    
    func saveNotes() {
        CommonObject.sharedInstance.showProgress()
        let newAPIPATH = API_PATH.replacingOccurrences(of: "newapp", with: "app")
        let requestURL = newAPIPATH + "saveNotes"
        let parameters : Parameters = ["application_id" : CommonObject.sharedInstance.currentReferenceId, "user_id" : UserDefaults.standard.userId(), "user_name" : UserDefaults.standard.username(), "notes" : notesTextView.text!, "request_from": "App"]
        //        apiPostRequest(parameters: parameters, endPoint: EndPoints.GET_AT_FAULT_DRIVER_DETAILS)
        
        if NetworkReachabilityManager()!.isReachable {
            AF.request(requestURL , method: .post, parameters: parameters, encoding: URLEncoding.httpBody) { $0.timeoutInterval = 60 }.responseJSON { (response) in
                debugPrint(response)
                print(requestURL)
                
                CommonObject.sharedInstance.stopProgress()
                if let mainDict = response.value as? [String : AnyObject] {
                    print(mainDict)
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
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
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
            saveNotes()
        }
        
        centerNotesView.isHidden = true
    }
    
    
    @IBAction func showNotesView(_ sender: Any) {
        centerNotesView.isHidden = false
        
        self.view.bringSubviewToFront(centerNotesView)
    }
    
}
