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

}
