//
//  SelectTimeVC.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 25/08/21.
//

import UIKit

class SelectTimeVC: UIViewController {
    var timeTextField = UITextField()
    var currentNotification = NSNotification.Name(String())
    var selectedDate: ((String) -> Void)?

    @IBOutlet weak var timeDatePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timeDatePicker.locale = Locale(identifier: "en_US")//Changes date picker format to 12 hr
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBtn(_ sender: UIButton) {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = DateFormatter.Style.short
        timeFormatter.dateFormat = "HH:mm"
        let strTime = timeFormatter.string(from: timeDatePicker.date)
        NotificationCenter.default.post(name: currentNotification, object: self, userInfo: ["selectedTime": strTime,"timeTextField" : timeTextField])
        selectedDate?(strTime)

        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
