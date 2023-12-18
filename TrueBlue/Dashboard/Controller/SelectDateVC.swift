//
//  SelectDateVC.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 25/08/21.
//

import UIKit

class SelectDateVC: UIViewController {
    var dateTextField = UITextField()
//    var isOnlyMonthYearDatePicker = Bool()
    var currentNotification = NSNotification.Name(String())
    var isFromUpcomingBooking = false
    var isThreeYearsValidation = false
    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFromUpcomingBooking{
            datePicker.minimumDate = Date()
        }
        
        if isThreeYearsValidation{
            datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 3, to: Date())
        }
        
//        if isOnlyMonthYearDatePicker {
//
//            datePicker.datePickerMode = .da
//        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBtn(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "dd-MM-yyyy"//"yyyy-MM-dd"
        let strDate = dateFormatter.string(from: datePicker.date)
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let dateForApi = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "yyyy"
        let strYear = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "MM"
        let strMonth = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "dd"
        let strDay = dateFormatter.string(from: datePicker.date)
        print("Year:\(strYear),Month:\(strMonth),Day:\(strDay)")
        NotificationCenter.default.post(name: currentNotification, object: self, userInfo: ["selectedDate": strDate,"dateTextField" : dateTextField,"selectedYear":strYear,"selectedMonth":strMonth,"selectedDay":strDay])
        dismiss(animated: true, completion: nil)
    }

}
