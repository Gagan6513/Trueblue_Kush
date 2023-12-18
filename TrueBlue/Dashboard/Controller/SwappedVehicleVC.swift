//
//  SwappedVehicleVC.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 25/04/23.
//

import UIKit

class SwappedVehicleVC: UIViewController {

    var vehiclesResultListObj = [VehiclesDetailsModelData]()
    var refNumber = [SearchDashboardResultDetailsModelData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(refNumber)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
extension SwappedVehicleVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CommonObject.sharedInstance.isNewEntry = false
        CommonObject.sharedInstance.currentReferenceId = refNumber[0].referenceNumber
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
extension SwappedVehicleVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehiclesResultListObj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppTblViewCells.SWAPPED_VEHICLE_CELL, for: indexPath as IndexPath) as! SwappedVehicleTblViewCell
        cell.titleLbl.text = vehiclesResultListObj[indexPath.row].content
        return cell
    }
}
