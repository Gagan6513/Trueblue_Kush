//
//  CardDetailsVC.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 23/09/21.
//

import UIKit
import Alamofire
class CardDetailsVC: UIViewController {
    var dictCardDetails = CardDetailsModelData()
    @IBOutlet weak var cardHolderNameOneTxtFld: UITextField!
    @IBOutlet weak var cardTypeOneLbl: UILabel!
    @IBOutlet weak var cardNumberOneTxtFld: UITextField!
    @IBOutlet weak var expiryDateOneTxtFld: UITextField!
    @IBOutlet weak var cvvOneTxtFld: UITextField!
    @IBOutlet weak var cardHolderNameTwoTxtFld: UITextField!
    @IBOutlet weak var cardTypeTwoLbl: UILabel!
    @IBOutlet weak var cardNumberTwoTxtFld: UITextField!
    @IBOutlet weak var expiryDateTwoTxtFld: UITextField!
    @IBOutlet weak var cvvTwoTxtFld: UITextField!
    var selectedCardTypeListNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(self.ListNotificationAction(_:)), name: .listCardDetails, object: nil)
        setViews()
    }
    
    func setViews() {
        cardNumberOneTxtFld.keyboardType = .numberPad
        cardNumberTwoTxtFld.keyboardType = .numberPad
        expiryDateOneTxtFld.keyboardType = .numberPad
        expiryDateTwoTxtFld.keyboardType = .numberPad
        cvvOneTxtFld.keyboardType = .numberPad
        cvvTwoTxtFld.keyboardType = .numberPad
    }
    func apiPostRequest(parameters: Parameters, endPoint: String) {
        CommonObject.sharedInstance.showProgress()
        let obj = CardDetailsViewModel()
        obj.delegate = self
        obj.postCardDetails(currentController: self, parameters: parameters, endPoint: endPoint)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cardHolderNameOneTxtFld.text = dictCardDetails.cardOneHolderName
        if !dictCardDetails.cardOneType.isEmpty {
            cardTypeOneLbl.text = dictCardDetails.cardOneType
            cardTypeOneLbl.textColor = UIColor(named: AppColors.BLACK)
        }
        cardNumberOneTxtFld.text = dictCardDetails.cardOneNumber
        expiryDateOneTxtFld.text = dictCardDetails.cardOneExpiryDate
        cvvOneTxtFld.text = dictCardDetails.cardOneCvv
        cardHolderNameTwoTxtFld.text = dictCardDetails.cardTwoHolderName
        if !dictCardDetails.cardTwoType.isEmpty {
            cardTypeTwoLbl.text = dictCardDetails.cardTwoType
            cardTypeTwoLbl.textColor = UIColor(named: AppColors.BLACK)
        }
        cardNumberTwoTxtFld.text = dictCardDetails.cardTwoNumber
        expiryDateTwoTxtFld.text = dictCardDetails.cardTwoExpiryDate
        cvvTwoTxtFld.text = dictCardDetails.cardTwoCvv
    }
    
    @IBAction func closeBtn(_ sender: UIButton) {
        NotificationCenter.default.post(name: .reloadUploadDocuments, object: self, userInfo: nil)
        dismiss(animated: true)
    }
    @IBAction func cardTypeOneTapped(_ sender: UITapGestureRecognizer) {
        let list = ["Master Card","Visa Card","Amex Card", "Diners Card"]
        selectedCardTypeListNumber = 1
        showPickerViewPopUp(list: list, listNameForSelection: AppDropDownLists.CARD_TYPE, notificationName: .listCardDetails)
    }
    
    @IBAction func cardTypeTwoTapped(_ sender: UITapGestureRecognizer) {
        let list = ["Master Card","Visa Card","Amex Card", "Diners Card"]
        selectedCardTypeListNumber = 2
        showPickerViewPopUp(list: list, listNameForSelection: AppDropDownLists.CARD_TYPE, notificationName: .listCardDetails)
    }
    
    @IBAction func submitBtn(_ sender: UIButton) {
        if (cardHolderNameOneTxtFld.text ?? "").isEmpty || (cardHolderNameOneTxtFld.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            
            showToast(strMessage: enterFirstCardName)
            return
        }
        
        if (cardTypeOneLbl.text ?? "").isEmpty || (cardTypeOneLbl.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            
            showToast(strMessage: selectFirstCardType)
            return
        }
        
        if (cardNumberOneTxtFld.text ?? "").isEmpty || (cardNumberOneTxtFld.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            
            showToast(strMessage: enterFirstCardNumber)
            return
        }
        
        if !CreditCardValidator(cardNumberOneTxtFld.text ?? "").isValid {
            showToast(strMessage: invalidFirstCard)
            return
        }
        
        if (expiryDateOneTxtFld.text ?? "").isEmpty || (expiryDateOneTxtFld.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            
            showToast(strMessage: enterFirstCardExpiry)
            return
        }
        if !expiryDateOneTxtFld.text!.isValidExpiryDateFormat() || (expiryDateOneTxtFld.text ?? "").count < 5 {
            showToast(strMessage: invalidFirstCardExpiry)
            return
        }
//        if !expiryDateOneTxtFld.text!.trimmingCharacters(in: .whitespaces).isEmpty {
//
//        }
        
        if (cvvOneTxtFld.text ?? "").isEmpty {
            showToast(strMessage: enterFirstCardCvv)
            return
        }
        
        if !(expiryDateTwoTxtFld.text ?? "").isEmpty {
            if !expiryDateTwoTxtFld.text!.isValidExpiryDateFormat() || (expiryDateTwoTxtFld.text ?? "").count < 5 {
                showToast(strMessage: invalidSecondCardExpiry)
                return
            }
        }
        let parameters: Parameters = ["application_id": CommonObject.sharedInstance.currentReferenceId,
                                      "cardholder_name": cardHolderNameOneTxtFld.text ?? "",
                                      "exp_date": expiryDateOneTxtFld.text ?? "",
                                      "card_type": cardTypeOneLbl.text ?? "",
                                      "card_no": cardNumberOneTxtFld.text ?? "",
                                      "cvv": cvvOneTxtFld.text ?? "",
                                      "cardholder_name2": cardHolderNameTwoTxtFld.text ?? "",
                                      "exp_date2": expiryDateTwoTxtFld.text ?? "",
                                      "card_type2": cardTypeTwoLbl.text ?? "",
                                      "card_no2": cardNumberTwoTxtFld.text ?? "",
                                      "cvv2": cvvTwoTxtFld.text ?? ""]
        apiPostRequest(parameters: parameters, endPoint: EndPoints.SAVE_CARD_DETAILS)
    }
    
    @objc func ListNotificationAction(_ notification: NSNotification){
        if let userInfo = notification.userInfo {
            if let selectedItem = userInfo["selectedItem"] as? String {
//                let selectedItemIndex = userInfo["selectedIndex"] as! Int
                switch selectedCardTypeListNumber {
                case 1:
                    cardTypeOneLbl.textColor = UIColor(named: AppColors.BLACK)
                    cardTypeOneLbl.text = selectedItem
                case 2:
                    cardTypeTwoLbl.textColor = UIColor(named: AppColors.BLACK)
                    cardTypeTwoLbl.text = selectedItem
                default:
                    print("Unkown List")
                }
            }
        }
    }
}

extension CardDetailsVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var isAllowed = true
        switch textField {
        case cvvOneTxtFld,cvvTwoTxtFld:
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            isAllowed = allowedCharacters.isSuperset(of: characterSet)
        case cardNumberOneTxtFld,cardNumberTwoTxtFld:
            isAllowed =  textField.formatCardNumber(shouldChangeCharactersInRange: range, replacementString: string)
        case cardHolderNameOneTxtFld,cardHolderNameTwoTxtFld :
//            let allowedCharacters = CharacterSet.letters
//            let characterSet = CharacterSet(charactersIn: string)
//            isAllowed = allowedCharacters.isSuperset(of: characterSet)
            isAllowed = textField.isValidNameCharacter(characterTyped: string, range: range)
        case expiryDateOneTxtFld,expiryDateTwoTxtFld:
            isAllowed = textField.validateCardExpiryDateTyped(shouldChangeCharactersInRange: range, replacementString: string)
//            let allowedCharacters = CharacterSet.decimalDigits
//            let characterSet = CharacterSet(charactersIn: string)
//
//            if string.isEmpty{
//                if textField.text!.count == 4 {
//                    textField.text!.removeLast()
//                    textField.text!.removeLast()
//
//                }
//            } else {
//                if textField.text!.count == 2 {
//                    textField.text?.append("-")
//                }
//            }
//            isAllowed = allowedCharacters.isSuperset(of: characterSet) && (textField.text!+string).count<8
        default:
            print("TextField without restriction")
        }
        
        return isAllowed
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField {
        case cardNumberOneTxtFld:
            expiryDateOneTxtFld.becomeFirstResponder()
        case expiryDateOneTxtFld:
            cvvOneTxtFld.becomeFirstResponder()
        case cvvOneTxtFld:
            cardHolderNameTwoTxtFld.becomeFirstResponder()
        case cardNumberTwoTxtFld:
            expiryDateTwoTxtFld.becomeFirstResponder()
        case expiryDateTwoTxtFld:
            cvvTwoTxtFld.becomeFirstResponder()
        default:
            print("Error")
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case expiryDateOneTxtFld:
            if !(textField.text ?? "").isEmpty && (textField.text ?? "").count == 5 &&  !(textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isValidExpiryDateFormat() {
                textField.text = ""
                showToast(strMessage: invalidFirstCardExpiry)
            }
        case expiryDateTwoTxtFld:
            if !(textField.text ?? "").isEmpty && (textField.text ?? "").count == 5 &&  !(textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isValidExpiryDateFormat() {
                textField.text = ""
                showToast(strMessage: invalidSecondCardExpiry)
            }
        default:
            print("textFieldDidEndEditing")
        }
    }
}

extension CardDetailsVC: CardDetailsVMDelegate {
    func cardDetailsAPISuccess(strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
        self.dismiss(animated: true)
        }
    }
    
    func cardDetailsAPIFailure(strMessage: String, serviceKey: String) {
        showToast(strMessage: strMessage)
    }
}
