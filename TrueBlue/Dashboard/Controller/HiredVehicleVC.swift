//
//  HiredVehicleVC.swift
//  TrueBlue
//
//  Created by Ashwani Kumar on 30/08/21.
//

import UIKit
import Alamofire
import DZNEmptyDataSet
class HiredVehicleVC: UIViewController {

    var arrHiredVehicles = [HiredVehicleListModelData]()
    @IBOutlet weak var tblHiredVehicles: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        hideKeyboardWhenTappedAround()
        tblHiredVehicles.emptyDataSetSource = self;
        tblHiredVehicles.emptyDataSetDelegate = self;
        
        apiPostRequest(parameters: [:], endPoint: EndPoints.HIRED_VEHICLE_LIST)
        
    }
    
    func apiPostRequest(parameters: Parameters,endPoint: String) {
        CommonObject.sharedInstance.showProgress()
        let obj = HiredVehicleViewModel()
        obj.delegate = self
        obj.postHiredVehiclesList(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @objc func openBookingEntry(_ sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag, tag > 0 else {
            return
        }
        CommonObject.sharedInstance.isNewEntry = false
        CommonObject.sharedInstance.currentReferenceId = arrHiredVehicles[tag-1].refno
        var storyboard = UIStoryboard()
        var vc = UIViewController()
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboard = UIStoryboard(name: AppStoryboards.DASHBOARD, bundle: .main)
            vc = storyboard.instantiateViewController(identifier: AppStoryboardId.NEW_BOOKING_ENTRY)
        } else {
            storyboard = UIStoryboard(name: AppStoryboards.DASHBOARD_PHONE, bundle: .main)
            vc = storyboard.instantiateViewController(identifier: AppStoryboardId.NEW_BOOKIN_ENTRY_PHONE)
        }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension HiredVehicleVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if arrHiredVehicles.count > 0
        {
            return arrHiredVehicles.count + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppTblViewCells.HIRED_VEHICLE_LIST_CELL, for: indexPath as IndexPath) as! HiredVehicleTblCell
        cell.selectionStyle = .none
        cell.contentView.layer.borderColor = UIColor(named: AppColors.INPUT_BORDER)?.cgColor
        cell.contentView.layer.borderWidth =  1
        if indexPath.row == 0 {
            cell.contentView.backgroundColor = UIColor(named: AppColors.BLUE)
            cell.sepOne.backgroundColor = UIColor(named: AppColors.BLUE)
            cell.sepTwo.backgroundColor = UIColor(named: AppColors.BLUE)
            cell.sepThree.backgroundColor = UIColor(named: AppColors.BLUE)
            cell.sepFour.backgroundColor = UIColor(named: AppColors.BLUE)
            
            cell.lblSerial.textColor = .white
            cell.lblRegoNo.textColor = .white
            cell.lblClient.textColor = .white
            cell.lblRepairer.textColor = .white
            cell.lblRefNo.textColor = .white
            
            cell.lblSerial.text = "#"
            cell.lblRefNo.text = "Ref No."
            cell.lblRegoNo.text = "REGO No."
            cell.lblClient.text = "Client"
            cell.lblRepairer.text = "Repairer"
            
        } else {
            cell.contentView.backgroundColor = .white
            cell.sepOne.backgroundColor = UIColor(named: AppColors.INPUT_BORDER)
            cell.sepTwo.backgroundColor = UIColor(named: AppColors.INPUT_BORDER)
            cell.sepThree.backgroundColor = UIColor(named: AppColors.INPUT_BORDER)
            cell.sepFour.backgroundColor = UIColor(named: AppColors.INPUT_BORDER)
            
            cell.lblSerial.textColor = UIColor(named: AppColors.BLACK)
            cell.lblRegoNo.textColor = UIColor(named: AppColors.BLACK)
            cell.lblClient.textColor = UIColor(named: AppColors.BLACK)
            cell.lblRepairer.textColor = UIColor(named: AppColors.BLACK)
            cell.lblRefNo.textColor = UIColor(named: AppColors.BLACK)
            
            cell.lblSerial.text = String(indexPath.row)
            cell.lblRegoNo.text = arrHiredVehicles[indexPath.row-1].registration_no
            cell.lblClient.text = arrHiredVehicles[indexPath.row-1].owner_name
            cell.lblRepairer.text = arrHiredVehicles[indexPath.row-1].repairer_name
            cell.lblRefNo.text = arrHiredVehicles[indexPath.row-1].refno
        }
        cell.lblRegoNo.tag = indexPath.row
        cell.lblRegoNo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openBookingEntry)))
        cell.lblRegoNo.isUserInteractionEnabled = true
        
        cell.lblRefNo.tag = indexPath.row
        cell.lblRefNo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openBookingEntry)))
        cell.lblRefNo.isUserInteractionEnabled = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension HiredVehicleVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIImage(named: AppImageNames.NO_RECORD_FOUND)
        }
        return UIImage(named: AppImageNames.NO_RECORD_FOUND_SMALL)
    }
}

extension HiredVehicleVC: HiredVehicleVMDelegate {
    
    func HiredVehicleAPISuccess(objData: HiredVehicleListModel, strMessage: String) {
        if objData.arrResult.count > 0 {
            arrHiredVehicles = objData.arrResult
            
            //showToast(strMessage: strMessage)
        }
        
        tblHiredVehicles.reloadData()
    }
    
    func HiredVehicleAPIFailure(strMessage: String, serviceKey: String) {
        //showToast(strMessage: strMessage)
        tblHiredVehicles.reloadData()
    }
}

