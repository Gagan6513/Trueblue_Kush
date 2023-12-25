//
//  EventTVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 25/12/23.
//

import UIKit

class EventTVC: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    
    @IBOutlet weak var lblTotalEvents: UILabel!
    @IBOutlet weak var lblPendingEvents: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
