//
//  SelectItemVC.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 25/08/21.
//

import UIKit

class SelectItemVC: UIViewController {
    var pickerViewData = [String]()
    var selectedItem = String()
    var listName = String()
    var itemSelectedAtRow = Int()
    var currentNotification = NSNotification.Name(String())
    @IBOutlet weak var titleLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = "Select " + listName
        //When user clicks on done button without moving picker view
        selectedItem = pickerViewData[0]
        itemSelectedAtRow = 0
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneBtn(_ sender: UIButton) {
        print(selectedItem)
        print(itemSelectedAtRow)
        print(listName)
        NotificationCenter.default.post(name: currentNotification, object: self, userInfo: ["selectedItem": selectedItem, "selectedIndex" : itemSelectedAtRow, "itemSelectedFromList" : listName])
        dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
extension SelectItemVC: UIPickerViewDelegate , UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedItem = pickerViewData[row]
        itemSelectedAtRow = row
    }
    
    
}
