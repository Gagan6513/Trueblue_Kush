//
//  DrawerVC.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 14/08/21.
//

import UIKit

class DrawerVC: UIViewController {
    let screenNames = ["Collections","Deliveries","Return Vehicle","Swap Vehicle","Create New Entry", "ACA List"]
    let imageNames = ["collection1","deal","car","exchange","new", "new"]
    
    var selectedRow = -1
    
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
//    func clearUserDefaults() {
//        UserDefaults.standard.setUsername(value: "")
//        UserDefaults.standard.setIsLoggedIn(value: false)
//    }
    override func viewWillAppear(_ animated: Bool) {
        usernameLbl.text = UserDefaults.standard.username()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    @IBAction func logoutBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)//Dismissing drawer when button is pressed.Logout will be performed in view did load of Dashboard
        NotificationCenter.default.post(name: .logout, object: self, userInfo: nil)
    }
    
}

extension DrawerVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppTblViewCells.DRAWER, for: indexPath as IndexPath) as! DrawerTblViewCell
        cell.selectionStyle = .none
        cell.imgView.image = UIImage(named: imageNames[indexPath.row])
        cell.titleLbl.text = screenNames[indexPath.row]
        if selectedRow == indexPath.row {
            cell.backView.backgroundColor = UIColor(named: AppColors.DRAWER_ITEM_SELECTED)
            cell.imgView.setImageColor(color: UIColor(named: AppColors.BLUE)!)
            cell.titleLbl.textColor = UIColor(named: AppColors.BLUE)
        } else {
            cell.backView.backgroundColor = .white
            cell.titleLbl.textColor = UIColor(named: AppColors.BLACK)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 100
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        tableView.reloadData()
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: AppSegue.COLLECTIONS, sender: nil)
        case 1:
            performSegue(withIdentifier: AppSegue.DELIVERIES, sender: nil)
        case 2:
            performSegue(withIdentifier: AppSegue.RETURN_VEHICLE, sender: nil)
        case 3:
            performSegue(withIdentifier: AppSegue.SWAP_VEHICLE, sender: nil)
        case 4:
            CommonObject.sharedInstance.isNewEntry = true
            performSegue(withIdentifier: AppSegue.CREATE_NEW_ENTRY, sender: nil)
        case 5:
            let ctrl = UIStoryboard(name: "DashboardPhone", bundle: nil).instantiateViewController(withIdentifier: "ACAViewController") as! ACAViewController
            ctrl.modalPresentationStyle = .overFullScreen
            self.present(ctrl, animated: true)
        default:
            print("Unkown Selection")
        }
    }
}
