//
//  ReferenceSearchResultVC.swift
//  TrueBlue
//
//  Created by Sharad Patil on 16/12/23.
//

import UIKit
import Alamofire

class ReferenceSearchResultVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var refNoLabel: UILabel!
    
    @IBOutlet weak var repairLabel: UILabel!
    
    @IBOutlet weak var referralLabel: UILabel!
    
    @IBOutlet weak var isSwappedLabel: UILabel!
    
    @IBOutlet weak var clientNameLabel: UILabel!
    
    @IBOutlet weak var makeModeLabel: UILabel!
    
    @IBOutlet weak var vehicleRegoLabel: UILabel!
    
    @IBOutlet weak var totalDaysLabel: UILabel!
    
    @IBOutlet weak var vehicleTableView: UITableView!
    
    var searchValue = ""
//    var allSearchResultArray: [ResponseObject] = []
    var responseDict: Dictionary<String, Any> = [:]
    var vehiclesList: Dictionary<String, Any> = [:]
    var vehicleListArray = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if searchValue != "" {
            self.getSearchResult()
        } else {
            self.setData()
        }
    }
    
    func setData() {
        self.vehiclesList = responseDict["response"] as! Dictionary<String, Any>
        
        if let vehiclesList = self.vehiclesList["vehiclesList"] as? [[String: Any]] {
            
            self.vehicleListArray.append(contentsOf: vehiclesList)

        } else {
            print("Error: Unable to extract vehiclesList from the response.")
        }
        self.setAllValues()
        self.vehicleTableView.reloadData()
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }

    func setAllValues() {
        if let keyCheck = vehiclesList["refno"] {
            refNoLabel.text = keyCheck as? String
        }
        if let keyCheck = vehiclesList["repairerName"] {
            repairLabel.text = keyCheck as? String
        }
        if let keyCheck = vehiclesList["referralName"] {
            referralLabel.text = keyCheck as? String
        } else {
            referralLabel.text = "-"
        }
        if let keyCheck = vehiclesList["isSwapped"] {
            isSwappedLabel.text = keyCheck as? String
        }
        if let keyCheck = vehiclesList["clientName"] {
            clientNameLabel.text = keyCheck as? String
        }
        if let keyCheck = vehiclesList["ClientMakeModel"] {
            makeModeLabel.text = keyCheck as? String
        }
        if let keyCheck = vehiclesList["ClientRego"] {
            vehicleRegoLabel.text = keyCheck as? String
        }
        
        var totalDays = 0
        self.vehicleListArray.forEach({ data in
            totalDays += data["total_days"] as? Int ?? 0
        })
        totalDaysLabel.text = "\(totalDays)"
//        if let keyCheck = vehiclesList["referralName"] {
//            totalDaysLabel.text = keyCheck as? String
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicleListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = vehicleTableView.dequeueReusableCell(withIdentifier: AppTblViewCells.REF_SEARCH_RESULT_TABLEVIEW_CELL, for: indexPath as IndexPath) as! ReferenceSearchResultTableViewCell
        
        cell.selectionStyle = .none
        
        let vehicleObject = vehicleListArray[indexPath.row]
        cell.carNameLbl.text = "\(vehicleObject["make"] as? String ?? "")/\(vehicleObject["model"] as? String ?? "")"
        cell.carNumberLbl.text = vehicleObject["vehicleRego"] as? String
        cell.hiredLbl.text = vehicleObject["vehicleStatus"] as? String
        cell.daysLbl.text = "\(vehicleObject["total_days"] as? Int ?? 0)"
        
        cell.lblDateIn.text = vehicleObject["dateIn"] as? String
        cell.lblTimeIn.text = vehicleObject["timeIn"] as? String
        cell.lblDateOut.text = vehicleObject["dateOut"] as? String
        cell.lblTimeOut.text = vehicleObject["timeOut"] as? String
        
        cell.lblDateIn.isHidden = cell.lblDateIn.text == ""
        cell.lblTimeIn.isHidden = cell.lblDateIn.text == ""
        cell.lblDateOut.isHidden = cell.lblDateOut.text == ""
        cell.lblTimeOut.isHidden = cell.lblDateOut.text == ""
        cell.lblTo.isHidden = cell.lblDateIn.isHidden || cell.lblDateOut.isHidden
        
        return cell
    }
    
    func getSearchResult() {
        CommonObject.sharedInstance.showProgress()
        let newAPIPATH = API_PATH //.replacingOccurrences(of: "newapp", with: "app")
        let requestURL = newAPIPATH + EndPoints.SEARCH_REFERENCE
        let parameters : Parameters = ["searchvalue" : searchValue]
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
                     
                    let status = mainDict["status"] as? Int ?? 0
                    if status == 1 {
                        CommonObject.sharedInstance.stopProgress()
                        let dict = mainDict["data"] as? Dictionary<String, Any> ?? [:]
                        print(dict)
                        self.responseDict = dict
                        self.setData()
                        
                    } else {
                        CommonObject.sharedInstance.stopProgress()
                        let errorMsg = mainDict["msg"] as? String ?? ""
                        print(errorMsg)
                        let alert = UIAlertController(title: "", message: errorMsg, preferredStyle: .alert)
                        let yesAction = UIAlertAction(title: "Ok", style: .default) { _ in
            //                self.dismiss(animated: true, completion: nil)
                        }
            //            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                        alert.addAction(yesAction)
            //            alert.addAction(noAction)
                        self.present(alert, animated: true, completion: nil)
                        
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
        self.present(vc, animated: true, completion: nil)
    }
    
    func clearUserDefaults() {
        UserDefaults.standard.setUsername(value: "")
        UserDefaults.standard.setIsLoggedIn(value: false)
        UserDefaults.standard.setUserId(value: "")
    }

}
