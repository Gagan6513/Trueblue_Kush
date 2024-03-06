//
//  MessagePopupVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 06/03/24.
//

import UIKit

class MessagePopupVC: UIViewController {

    @IBOutlet weak var scrollingHeight: NSLayoutConstraint!
    @IBOutlet weak var messageLabel: UILabel!
    
    var message = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messageLabel.text = self.message

        DispatchQueue.main.async {
            self.scrollingHeight.constant = self.messageLabel.calculateContentHeight()
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.scrollingHeight.constant = self.messageLabel.calculateContentHeight()
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: false)
    }
}

extension UILabel {
    
    func calculateContentHeight() -> CGFloat{
        var maxLabelSize: CGSize = CGSizeMake(frame.size.width - 48, CGFloat(9999))
        var expectedLabelSize = self.text!.boundingRect(with: maxLabelSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font], context: nil)
        print("\(expectedLabelSize)")
        return expectedLabelSize.size.height
    }
    
    func numberOfTextLines() -> Int {
        let constraintRect = CGSize(width: self.frame.width, height: .greatestFiniteMagnitude)
        guard let boundingBox = self.text?.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font ?? .systemFont(ofSize: 16)], context: nil) else { return 1 }
        let numberOfLines = Int(ceil(boundingBox.height / font.lineHeight))
        return numberOfLines
    }
}
