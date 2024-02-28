//
//  ACADataFilterViewController.swift
//  TrueBlue
//
//  Created by Kushkumar Katira iMac on 09/01/24.
//

import UIKit

class ACADataFilterViewController: UIViewController {
    
    @IBOutlet weak var firstStack: UIStackView!
    
    @IBOutlet weak var txtFrom: UITextField!
    @IBOutlet weak var txtTo: UITextField!
    
    var fromDatePicker = UIDatePicker()
    var toDatePicker = UIDatePicker()
    
    var dateFormater = DateFormatter()
    var dateClosure: ((_ fromDate: String, _ toDate: String) -> Void)?
    
    var startDate = ""
    var endDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func btnSave(_ sender: Any) {
        if validateTextField() {
            let startDate = (self.txtFrom.text ?? "").date(currentFormate: .ddmmyyyy, convetedFormate: .yyyymmdd)
            let endDate = (self.txtTo.text ?? "").date(currentFormate: .ddmmyyyy, convetedFormate: .yyyymmdd)
            
            self.dateClosure?(startDate, endDate)
            self.dismiss(animated: false)
        }
    }
    
    @IBAction func btnFromDate(_ sender: Any) {
        var storyboardName = String()
        var vcId = String()
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboardName = AppStoryboards.DASHBOARD
            vcId = AppStoryboardId.SELECT_DATE
        } else {
            storyboardName = AppStoryboards.DASHBOARD_PHONE
            vcId = AppStoryboardId.SELECT_DATE_PHONE
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        let ctrl = storyboard.instantiateViewController(identifier: vcId) as! SelectDateVC
        ctrl.modalPresentationStyle = .overFullScreen
        ctrl.selectedDate = { [weak self] date in
            guard let self else { return }
            self.txtFrom.text = date
        }
        self.present(ctrl, animated: false)
    }
    
    @IBAction func btnToDate(_ sender: Any) {
        var storyboardName = String()
        var vcId = String()
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboardName = AppStoryboards.DASHBOARD
            vcId = AppStoryboardId.SELECT_DATE
        } else {
            storyboardName = AppStoryboards.DASHBOARD_PHONE
            vcId = AppStoryboardId.SELECT_DATE_PHONE
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        let ctrl = storyboard.instantiateViewController(identifier: vcId) as! SelectDateVC
        ctrl.modalPresentationStyle = .overFullScreen
        ctrl.selectedDate = { [weak self] date in
            guard let self else { return }
            self.txtTo.text = date
        }
        self.present(ctrl, animated: false)
    }
    
    func setupUI() {
        
        if self.startDate != "" {
            self.txtFrom.text = self.startDate.date(currentFormate: .yyyymmdd, convetedFormate: .ddmmyyyy)
        }
        if self.endDate != "" {
            self.txtTo.text = self.endDate.date(currentFormate: .yyyymmdd, convetedFormate: .ddmmyyyy)
        }
        
        self.dateFormater.dateFormat = "dd-MM-YYYY"
        
        self.firstStack.axis = UIDevice.current.userInterfaceIdiom == .pad ? .horizontal : .vertical
        
        self.fromDatePicker.datePickerMode = .date
        self.toDatePicker.datePickerMode = .date
        
        self.txtFrom.delegate = self
        self.txtTo.delegate = self
//        self.txtFrom.inputView = self.fromDatePicker
//        self.txtTo.inputView = self.toDatePicker
        
        self.fromDatePicker.preferredDatePickerStyle = .wheels
        self.toDatePicker.preferredDatePickerStyle = .wheels
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
        
        return true
    }
}

extension ACADataFilterViewController: UITextFieldDelegate {
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == self.txtFrom {
//            self.txtFrom.text = self.dateFormater.string(from: self.fromDatePicker.date)
//        } else if textField == self.txtTo {
//            self.txtTo.text = self.dateFormater.string(from: self.toDatePicker.date)
//        }
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var isAllowed = true
        switch textField {
        case txtFrom, txtTo:
            isAllowed = textField.validateDateTyped(shouldChangeCharactersInRange: range, replacementString: string)
//        case txtEventTime :
//            isAllowed = textField.validateTimeTyped(shouldChangeCharactersInRange: range, replacementString: string)
        default:
            print("TextField without restriction")
        }
        return isAllowed
    }
}
