//
//  UnderMaintenanceVC.swift
//  TrueBlue
//
//  Created by Gurmeet Kaur Narang on 13/12/23.
//

import UIKit
import Alamofire
import DZNEmptyDataSet

class UnderMaintenanceVC: UIViewController {

    @IBOutlet weak var tblUnderMaintenance_View: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var searchTxtFld1: UITextField!
    var arrUnderMaintenance = [UnderMaintenanceModelData]()
    override func viewDidLoad() {
        super.viewDidLoad()

        searchView.layer.borderColor = UIColor(named: "AppBlue")?.cgColor
        searchView.layer.borderWidth = 1
        searchView.layer.cornerRadius = 5
        
        apiUnderMaintenance ()
       
    }
    

    func apiPostMaintenanceList(parameters: Parameters,endPoint: String) {
        CommonObject.sharedInstance.showProgress()
        let obj = UnderMaintenanceViewModel()
        obj.delegate = self
        obj.postUnderMaintenanceList(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    func apiUnderMaintenance() {
        
        let parameters : Parameters = ["status" : "Maintenance",
                                       "limitRecord" : "2", "pageNo" : "0"]
        apiPostMaintenanceList(parameters: parameters, endPoint: EndPoints.UNDER_MAINTENANCE)
    }
    @IBAction func backBtn1(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func btnSearchClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if ((searchTxtFld1.text?.isEmpty) != nil){
            let parameters : Parameters = ["status" : "Maintenance",
                                           "limitRecord" : "2", "pageNo" : "0", "searchval" : searchTxtFld1.text ?? ""]
            apiPostMaintenanceList(parameters: parameters, endPoint: EndPoints.UNDER_MAINTENANCE)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        if textField == searchTxtFld1 && ((searchTxtFld1.text?.isEmpty) != nil){
            let parameters : Parameters = ["status" : "Maintenance",
                                           "limitRecord" : "2", "pageNo" : "0", "searchval" : searchTxtFld1.text ?? ""]
            apiPostMaintenanceList(parameters: parameters, endPoint: EndPoints.UNDER_MAINTENANCE)
        }
        return true
    }
}

extension UnderMaintenanceVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if arrUnderMaintenance.count > 0
        {
            return arrUnderMaintenance.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if UIDevice.current.userInterfaceIdiom == .pad  {
            return 422.0
        } else {
            return 282.0
        }
       //Choose your custom row height
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppTblViewCells.UNDER_MAINTENANCE_CELL, for: indexPath as IndexPath) as! UnderMaintenanceViewCell
        cell.selectionStyle = .none
        cell.contentView.layer.borderColor = UIColor(named: AppColors.INPUT_BORDER)?.cgColor
        cell.contentView.layer.borderWidth =  1
        cell.contentView.backgroundColor = .clear
        cell.view_Background.backgroundColor = .white
        cell.view_Background.layer.cornerRadius = 8
        cell.view_Background.layer.masksToBounds = true

        cell.lbl_SrNo.text = "Sr No."
        cell.lbl_SrNo1.text = String(indexPath.row + 1)
        
        cell.lbl_Category.text = "Category"
        cell.lbl_Category1.text = arrUnderMaintenance[indexPath.row].category
        
        cell.lbl_Model.text = "Model"
        cell.lbl_Model1.text = arrUnderMaintenance[indexPath.row].model
        
        cell.lbl_RegNo.text = "Registration No"
        cell.lbl_RegNo1.text = arrUnderMaintenance[indexPath.row].registration_no
        
        cell.lbl_FuelType.text = "Fuel Type"
        cell.lbl_FuelType1.text = arrUnderMaintenance[indexPath.row].fuel_type
       
        var editedText = cell.lbl_FuelType1.text?.replacingOccurrences(of: "\"", with: "")
        let test = String(editedText!.filter { !" \r\n".contains($0) })
        print(test)
        cell.lbl_FuelType1.text = test
        
        cell.lbl_Transmission.text = "Transmission"
        cell.lbl_Transmission1.text = arrUnderMaintenance[indexPath.row].transmission
        
        cell.lbl_Status.text = "Status"
        cell.lbl_Status1.text = arrUnderMaintenance[indexPath.row].status
        
        cell.lbl_PurchaseDate.text = "Purchase Date"
        cell.lbl_PurchaseDate1.text = arrUnderMaintenance[indexPath.row].purchase_from
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension UnderMaintenanceVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIImage(named: AppImageNames.NO_RECORD_FOUND)
        }
        return UIImage(named: AppImageNames.NO_RECORD_FOUND_SMALL)
    }
}
extension UnderMaintenanceVC: UnderMaintenanceVMDelegate {
    
    func UnderMaintenanceAPISuccess(objData: UnderMaintenanceModel, strMessage: String) {
        print(objData.arrResult.count)
        if objData.arrResult.count > 0 {
            arrUnderMaintenance = objData.arrResult
            
            //showToast(strMessage: strMessage)
        }
        
        tblUnderMaintenance_View.reloadData()
    }
    
    func UnderMaintenanceAPIFailure(strMessage: String, serviceKey: String) {
        //showToast(strMessage: strMessage)
        tblUnderMaintenance_View.reloadData()
    }
}
