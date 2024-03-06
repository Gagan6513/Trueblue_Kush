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
    
    @IBOutlet weak var byLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var message: Events?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = self.message {
            self.byLabel.text = data.ASSIGNED_BY_USER?.capitalized
            self.toLabel.text = data.ASSIGNED_TO_USER?.capitalized
            self.timeLabel.text = data.EVENT_TIME

            let api_timeFormater = DateFormatter()
            api_timeFormater.dateFormat =  "HH:mm:ss"
            let api_time = api_timeFormater.date(from: data.EVENT_TIME ?? "")
            api_timeFormater.dateFormat =  "hh:mm a"
            self.timeLabel.text = api_timeFormater.string(from: api_time ?? Date())
            
            if let appId = data.APP_ID {
                self.messageLabel.text = "#\(appId) / \(data.EVENT_DESC ?? "")"
            } else {
                self.messageLabel.text = "\(data.EVENT_DESC ?? "")"
            }
            
            if data.EVENT_TYPE ?? "" == "collection_notes" {
                self.byLabel.textColor = UIColor(named: "AppOrange")
            } else if data.EVENT_TYPE ?? "" == "delivery_notes" {
                self.byLabel.textColor = UIColor(named: "3478F6")
            } else {
                self.byLabel.textColor = UIColor(named: "07B107")
            }
            
        }

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
