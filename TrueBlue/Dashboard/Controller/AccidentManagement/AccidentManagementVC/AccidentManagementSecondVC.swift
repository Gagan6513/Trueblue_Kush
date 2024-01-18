//
//  AccidentManagementSecondVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 18/01/24.
//

import UIKit

class AccidentManagementSecondVC: UIViewController {

    @IBOutlet weak var btnRadioVBYes: UIButton!
    @IBOutlet weak var btnRadioVBNo: UIButton!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtDateofBirth: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtSuburb: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtPinCode: UITextField!
    @IBOutlet weak var txtModel: UITextField!
    @IBOutlet weak var txtRegistrationNo: UITextField!
    @IBOutlet weak var txtInsuranceCompany: UITextField!
    @IBOutlet weak var txtClaimNo: UITextField!
    
    
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
    @IBAction func btnRadioVBYes(_ sender: UIButton) {
        sender.tintColor = .systemGreen
        btnRadioVBNo.tintColor = UIColor(named: "D9D9D9")
    }
    @IBAction func btnRadioVBNo(_ sender: UIButton) {
        sender.tintColor = .systemGreen
        btnRadioVBYes.tintColor = UIColor(named: "D9D9D9")
    }
    
    @IBAction func btnSaveContinue(_ sender: UIButton) {
    }
}
