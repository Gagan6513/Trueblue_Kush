//
//  DigitalSignatureVC.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 18/08/21.
//

import UIKit
import AASignatureView
class DigitalSignatureVC: UIViewController {
    @IBOutlet weak var signatureView: AASignatureView!
    //    @IBOutlet weak var signatureView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setUpSignatureView()
    }
    
    func setUpSignatureView() {
        signatureView.layer.borderColor = UIColor(named: AppColors.INPUT_BORDER)?.cgColor
        if UIDevice.current.userInterfaceIdiom == .pad {
//            signatureView.layer.borderWidth = 3
//            signatureView.layer.cornerRadius = 7.2
        } else {
//            signatureView.layer.borderWidth = 1.1
//            signatureView.layer.cornerRadius = 6
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func clearBtn(_ sender: UIButton) {
        signatureView.clear()
    }
    
    @IBAction func undoBtn(_ sender: UIButton) {
    }
    @IBAction func saveBtn(_ sender: UIButton) {
        if let image = signatureView.signature {
        // Captured image of signature view
            NotificationCenter.default.post(name: .digitalSignature, object: self, userInfo: ["selectedImg": image])
            dismiss(animated: true, completion: nil)
        }
    }

}
