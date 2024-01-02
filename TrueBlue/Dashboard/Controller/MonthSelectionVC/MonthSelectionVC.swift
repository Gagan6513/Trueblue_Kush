//
//  MonthSelectionVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 01/01/24.
//

import UIKit

class MonthSelectionVC: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    
    var arrMonth = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    var arrYear = Array(2000 ... 2030)
    var selectedDate: ((Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        if let monthInt = Calendar.current.dateComponents([.month], from: Date()).month {
            print(monthInt) // 4
            self.pickerView.selectRow(monthInt - 1, inComponent: 0, animated: false)
        }
        
        if let yearInt = Calendar.current.dateComponents([.year], from: Date()).year {
            print(yearInt) // 4
            let index = self.arrYear.firstIndex(where: { $0 == yearInt }) ?? 0
            self.pickerView.selectRow(index, inComponent: 1, animated: false)
        }
    }

    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func btnDone(_ sender: Any) {
        let dateFormatter = DateFormatter()
        let selectedMonth = pickerView.selectedRow(inComponent: 0) + 1
        
        print(selectedMonth)
        let monthStr = String(format: "%02d", selectedMonth)
        
        let selectedYear = "\(self.arrYear[pickerView.selectedRow(inComponent: 1)])"
        
        let dateString = "01-\(monthStr)-\(selectedYear)"
        print(dateString)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.selectedDate?(dateFormatter.date(from: dateString) ?? Date())
        self.dismiss(animated: false)
    }
}

extension MonthSelectionVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.arrMonth.count
        } else {
            return self.arrYear.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return self.arrMonth[row]
        } else {
            return "\(self.arrYear[row])"
        }
    }
    
}
