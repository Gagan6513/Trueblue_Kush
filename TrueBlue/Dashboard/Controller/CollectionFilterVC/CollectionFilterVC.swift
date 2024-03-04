//
//  CollectionFilterVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 29/02/24.
//

import UIKit

class CollectionFilterVC: UIViewController {

    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var returnView: UIView!
    @IBOutlet weak var swapView: UIView!
    
    var swapbtnClicked: (() -> Void)?
    var returnbtnClicked: (() -> Void)?
    var regobtnClicked: (() -> Void)?
    var refbtnClicked: (() -> Void)?
    var isCollected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.returnView.isHidden = self.isCollected
            self.swapView.isHidden = self.isCollected
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func btnSwap(_ sender: Any) {
        self.swapbtnClicked?()
        self.dismiss(animated: false)
    }
    
    @IBAction func btnReturn(_ sender: Any) {
        self.returnbtnClicked?()
        self.dismiss(animated: false)
    }
   
    @IBAction func btnRegoHistory(_ sender: Any) {
        self.regobtnClicked?()
        self.dismiss(animated: false)
    }
   
    @IBAction func btnRefHistory(_ sender: Any) {
        self.refbtnClicked?()
        self.dismiss(animated: false)
    }
}
