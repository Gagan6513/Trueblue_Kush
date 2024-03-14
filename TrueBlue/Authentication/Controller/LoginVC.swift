//
//  LoginVC.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 14/08/21.
//

import UIKit
import Alamofire
class LoginVC: UIViewController {

    @IBOutlet weak var btnPasswordPrivacy: UIButton!
    @IBOutlet weak var userNameTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var viewLoginBG: UIView!
    @IBOutlet weak var userNameCheckImgView: UIImageView!
    var viewPasswordIsSelected = false
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        // Do any additional setup after loading the view.
    }
    
    func apiPostLogin() {
        CommonObject.sharedInstance.showProgress()
        let parameters : Parameters = ["username": userNameTxtFld.text!,
                                       "password": passwordTxtFld.text!]
        let obj = LoginViewModel()
        obj.delegate = self
        obj.postLogin(currentController: self, parameters: parameters, endPoint: EndPoints.LOGIN)
    }
    
    @IBAction func viewPasswordBtn(_ sender: UIButton) {
        viewPasswordIsSelected = !viewPasswordIsSelected
        if viewPasswordIsSelected {
            btnPasswordPrivacy.setImage(UIImage.init(named: "view"), for: .normal)
            passwordTxtFld.isSecureTextEntry = false
        } else {
            btnPasswordPrivacy.setImage(UIImage.init(named: "ic_passPrivate"), for: .normal)
            passwordTxtFld.isSecureTextEntry = true
        }
        
    }
    @IBAction func loginBtn(_ sender: UIButton) {
//        performSegue(withIdentifier: AppSegue.DASHBOARD, sender: nil)
        if userNameTxtFld.text!.isEmpty {
            showToast(strMessage: "Please enter username.")
            return
        }
        if passwordTxtFld.text!.isEmpty {
            showToast(strMessage: "Please enter password")
            return
        }
        apiPostLogin()
    }

}

extension LoginVC {
    func configureLayout() {
        viewLoginBG.layoutIfNeeded()
        if UIDevice.current.userInterfaceIdiom == .pad {
            viewLoginBG.round(corners: [.topLeft, .topRight], cornerRadius: 60)
        } else {
            viewLoginBG.round(corners: [.topLeft, .topRight], cornerRadius: 30)
        }
    }
}

extension LoginVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case userNameTxtFld:
            textField.superview?.layer.borderColor = UIColor(named: AppColors.BLUE)?.cgColor
            passwordTxtFld.superview?.layer.borderColor = UIColor(named: AppColors.INPUT_BORDER)?.cgColor
        case passwordTxtFld:
            textField.superview?.layer.borderColor = UIColor(named: AppColors.BLUE)?.cgColor
            userNameTxtFld.superview?.layer.borderColor = UIColor(named: AppColors.INPUT_BORDER)?.cgColor
        default:
            print("Unkown")
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.superview?.layer.borderColor = UIColor(named: AppColors.INPUT_BORDER)?.cgColor
        if textField == userNameTxtFld {
            if !textField.text!.isEmpty {
                userNameCheckImgView.isHidden = false
            } else {
                userNameCheckImgView.isHidden = true
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case userNameTxtFld:
            textField.resignFirstResponder()
            passwordTxtFld.becomeFirstResponder()
        case passwordTxtFld:
            textField.resignFirstResponder()
        default:
            print("Unkown")
        }
        return true
    }
}

extension LoginVC : LoginVMDelegate {
    func LoginAPISuccess(objLoginData: LoginModel, strMessage: String) {
        UserDefaults.standard.setUsername(value: objLoginData.dictLogin.name)
        UserDefaults.standard.setIsLoggedIn(value: true)
        UserDefaults.standard.setUserId(value: objLoginData.dictLogin.userId)
        UserDefaults.standard.setUserToken(value: objLoginData.dictLogin.userToken)
        UserDefaults.standard.setGroupId(value: objLoginData.dictLogin.groupId)
        showToast(strMessage: strMessage)
        if UIDevice.current.userInterfaceIdiom == .pad {
            performSegue(withIdentifier: AppSegue.DASHBOARD, sender: nil)
        } else {
            performSegue(withIdentifier: AppSegue.DASHBOARD_PHONE, sender: nil)
        }
        
    }
    
    func LoginAPIFailure(strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
    }
}
