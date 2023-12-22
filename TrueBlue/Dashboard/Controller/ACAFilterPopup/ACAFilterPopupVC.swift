//
//  ACAFilterPopupVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 22/12/23.
//

import UIKit

class ACAFilterPopupVC: UIViewController {

    @IBOutlet weak var firstStack: UIStackView!
    @IBOutlet weak var secondStack: UIStackView!
    
    @IBOutlet weak var txtFrom: UITextField!
    @IBOutlet weak var txtTo: UITextField!
    
    @IBOutlet weak var txtStatus: UITextField!
    @IBOutlet weak var txtAssociate: UITextField!
    
    var fromDatePicker = UIDatePicker()
    var toDatePicker = UIDatePicker()
    var statusPicker = UIPickerView()
    var associatePicker = UIPickerView()
    
    var dateFormater = DateFormatter()
    
    var arrStatus = ["Status", "Status", "Status", "Status"]
    var arrAssociate = ["Associate", "Associate", "Associate", "Associate"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func btnSave(_ sender: Any) {
        if validateTextField() {
            self.dismiss(animated: false)
        }
    }
    
    func setupUI() {
        self.dateFormater.dateFormat = "dd-MM-YYYY"
        
        self.firstStack.axis = UIDevice.current.userInterfaceIdiom == .pad ? .horizontal : .vertical
        self.secondStack.axis = UIDevice.current.userInterfaceIdiom == .pad ? .horizontal : .vertical
        
        self.fromDatePicker.datePickerMode = .date
        self.toDatePicker.datePickerMode = .date
        
        self.txtFrom.delegate = self
        self.txtTo.delegate = self
        self.txtFrom.inputView = self.fromDatePicker
        self.txtTo.inputView = self.toDatePicker
        
        self.fromDatePicker.preferredDatePickerStyle = .wheels
        self.toDatePicker.preferredDatePickerStyle = .wheels
        
        self.txtStatus.inputView = self.statusPicker
        self.txtAssociate.inputView = self.associatePicker
        
        self.statusPicker.delegate = self
        self.statusPicker.dataSource = self
        
        self.associatePicker.delegate = self
        self.associatePicker.dataSource = self
    }
    
    func validateTextField() -> Bool {
        
        if self.txtFrom.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please select from date.")
            return false
        }
        
        if self.txtTo.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please select to date.")
            return false
        }
        
        if self.txtStatus.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please select status.")
            return false
        }
        
        if self.txtAssociate.text?.isEmpty ?? true {
            showAlert(title: "Error!", messsage: "Please select associate.")
            return false
        }
        
        return true
    }
}

extension ACAFilterPopupVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtFrom {
            self.txtFrom.text = self.dateFormater.string(from: self.fromDatePicker.date)
        } else if textField == self.txtTo {
            self.txtTo.text = self.dateFormater.string(from: self.toDatePicker.date)
        }
    }
}


extension ACAFilterPopupVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.statusPicker {
            self.txtStatus.text = self.arrStatus.first
            return self.arrStatus.count
        } else {
            self.txtAssociate.text = self.arrAssociate.first
            return self.arrAssociate.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.statusPicker {
            return self.arrStatus[row]
        } else {
            return self.arrAssociate[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.statusPicker {
            self.txtStatus.text = self.arrStatus[row]
        } else {
            self.txtAssociate.text = self.arrAssociate[row]
        }
    }
}
