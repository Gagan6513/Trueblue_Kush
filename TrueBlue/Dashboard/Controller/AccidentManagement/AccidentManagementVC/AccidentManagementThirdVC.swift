//
//  AccidentManagementThirdVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 18/01/24.
//

import UIKit

class AccidentManagementThirdVC: UIViewController {

    @IBOutlet weak var txtDateofAccident: UITextField!
    @IBOutlet weak var txtTimeofAccident: UITextField!
    @IBOutlet weak var txtAccidentLocation: UITextField!
    @IBOutlet weak var txtRepairerName: UITextField!
    @IBOutlet weak var txtReferralName: UITextField!
    @IBOutlet weak var txtViewAccidentDescription: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnSaveContinue(_ sender: UIButton) {
    }
    
}
