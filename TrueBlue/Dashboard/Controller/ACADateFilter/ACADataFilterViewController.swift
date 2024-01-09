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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func btnSave(_ sender: Any) {
        if validateTextField() {
            self.dateClosure?(self.txtFrom.text ?? "", self.txtTo.text ?? "")
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
        self.dateFormater.dateFormat = "dd-MM-YYYY"
        
        self.firstStack.axis = UIDevice.current.userInterfaceIdiom == .pad ? .horizontal : .vertical
        
        self.fromDatePicker.datePickerMode = .date
        self.toDatePicker.datePickerMode = .date
        
        self.txtFrom.delegate = self
        self.txtTo.delegate = self
        self.txtFrom.inputView = self.fromDatePicker
        self.txtTo.inputView = self.toDatePicker
        
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtFrom {
            self.txtFrom.text = self.dateFormater.string(from: self.fromDatePicker.date)
        } else if textField == self.txtTo {
            self.txtTo.text = self.dateFormater.string(from: self.toDatePicker.date)
        }
    }
}
