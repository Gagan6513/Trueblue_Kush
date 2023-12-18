//
//  SplashVC.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 14/08/21.
//

import UIKit

class SplashVC: UIViewController {

    @IBOutlet weak var signInBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Delay to check if user is logged in
        if UserDefaults.standard.isLoggedIn() {
            signInBtn.isHidden = true
        }
        self.perform(#selector(loadScreen), with: nil, afterDelay: 0.5)
    }

    @objc func loadScreen() {
        if UserDefaults.standard.isLoggedIn() {
            if UIDevice.current.userInterfaceIdiom == .pad {
                performSegue(withIdentifier: AppSegue.DASHBOARD, sender: nil)
            } else {
                performSegue(withIdentifier: AppSegue.DASHBOARD_PHONE, sender: nil)
            }
        }
    }
    
    @IBAction func signInBtn(_ sender: UIButton) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            performSegue(withIdentifier: AppSegue.LOGIN, sender: nil)
        } else {
            performSegue(withIdentifier: AppSegue.LOGIN_PHONE, sender: nil)
        }
        
    }
}
