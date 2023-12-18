//
//  AvailableVehicleVC.swift
//  TrueBlue
//
//  Created by Ashwani Kumar on 30/08/21.
//

import UIKit
import Alamofire
import DZNEmptyDataSet
class AvailableVehicleVC: UIViewController {
    
    var arrAvailVehicles = [AvailVehicleListModelData]()
    @IBOutlet weak var tblAvailVehicles: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //tblCollections.isHidden = true
        tblAvailVehicles.emptyDataSetSource = self;
        tblAvailVehicles.emptyDataSetDelegate = self;
        
        apiPostRequest(parameters: [:], endPoint: EndPoints.AVAILABLE_VEHICLE_LIST)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func apiPostRequest(parameters: Parameters,endPoint: String) {
        CommonObject.sharedInstance.showProgress()
        let obj = AvailVehicleViewModel()
        obj.delegate = self
        obj.postAvailVehicleList(currentController: self, parameters: [:], endPoint: endPoint)
    }

    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension AvailableVehicleVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if arrAvailVehicles.count > 0
        {
            return arrAvailVehicles.count + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppTblViewCells.AVAIL_VEHICLE_LIST_CELL, for: indexPath as IndexPath) as! AvailVehicleTblCell
        cell.selectionStyle = .none
        cell.contentView.layer.borderColor = UIColor(named: AppColors.INPUT_BORDER)?.cgColor
        cell.contentView.layer.borderWidth =  1
        if indexPath.row == 0 {
            cell.contentView.backgroundColor = UIColor(named: AppColors.BLUE)
            cell.sepOne.backgroundColor = UIColor(named: AppColors.BLUE)
            cell.sepTwo.backgroundColor = UIColor(named: AppColors.BLUE)
            cell.sepThree.backgroundColor = UIColor(named: AppColors.BLUE)
            
            cell.lblSerialNo.textColor = .white
            cell.lblModel.textColor = .white
            cell.lblCategory.textColor = .white
            cell.lblRegoNo.textColor = .white
            
            cell.lblSerialNo.text = "#"
            cell.lblRegoNo.text = "REGO No."
            cell.lblCategory.text = "Category"
            cell.lblModel.text = "Model"
            
        } else {
            cell.contentView.backgroundColor = .white
            cell.sepOne.backgroundColor = UIColor(named: AppColors.INPUT_BORDER)
            cell.sepTwo.backgroundColor = UIColor(named: AppColors.INPUT_BORDER)
            cell.sepThree.backgroundColor = UIColor(named: AppColors.INPUT_BORDER)
            
            cell.lblSerialNo.textColor = UIColor(named: AppColors.BLACK)
            cell.lblRegoNo.textColor = UIColor(named: AppColors.BLACK)
            cell.lblCategory.textColor = UIColor(named: AppColors.BLACK)
            cell.lblModel.textColor = UIColor(named: AppColors.BLACK)
            
            cell.lblSerialNo.text = String(indexPath.row)
            cell.lblRegoNo.text = arrAvailVehicles[indexPath.row-1].registration_no
            cell.lblCategory.text = arrAvailVehicles[indexPath.row-1].category
            cell.lblModel.text = arrAvailVehicles[indexPath.row-1].model
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension AvailableVehicleVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIImage(named: AppImageNames.NO_RECORD_FOUND)
        }
        return UIImage(named: AppImageNames.NO_RECORD_FOUND_SMALL)
    }
}


extension AvailableVehicleVC: AvailVehicleVMDelegate {
    
    func AvailVehicleAPISuccess(objData: AvailVehicleListModel, strMessage: String) {
        print(objData.arrResult.count)
        if objData.arrResult.count > 0 {
            arrAvailVehicles = objData.arrResult
            
            //showToast(strMessage: strMessage)
        }
        
        tblAvailVehicles.reloadData()
    }
    
    func AvailVehicleAPIFailure(strMessage: String, serviceKey: String) {
        //showToast(strMessage: strMessage)
        tblAvailVehicles.reloadData()
    }
}
