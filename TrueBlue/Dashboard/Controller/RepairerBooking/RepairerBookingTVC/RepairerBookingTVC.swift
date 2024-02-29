//
//  RepairerBookingTVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 05/02/24.
//

import UIKit

class RepairerBookingTVC: UITableViewCell {

    @IBOutlet weak var refNumberLbl: UILabel!
    @IBOutlet weak var clientNameLbl: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnCall(_ sender: Any) {
        if let urlMobile = NSURL(string: "tel://\(self.mobileNumberLabel.text ?? "")"), UIApplication.shared.canOpenURL(urlMobile as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(urlMobile as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(urlMobile as URL)
            }
        }
    }
}
