//
//  AddNotesPopupVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 02/01/24.
//

import UIKit
import IQKeyboardManagerSwift

class AddNotesPopupVC: UIViewController {

    @IBOutlet weak var txtNoteDescription: IQTextView!
    
    var notesDescStr: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func btnSave(_ sender: Any) {
        
        if let text = self.txtNoteDescription.text, text.trimmingCharacters(in: .whitespaces).isEmpty {
            showAlert(title: "Error!", messsage: "Please enter note description.")
            return
        }
        
        self.notesDescStr?(self.txtNoteDescription.text ?? "")
        self.dismiss(animated: false)
    }
    
}
