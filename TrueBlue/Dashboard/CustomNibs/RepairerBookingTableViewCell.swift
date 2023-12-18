//
//  RepairerBookingTableViewCell.swift
//  TrueBlue
//
//  Created by Sharad Patil on 17/12/23.
//

import UIKit

class RepairerBookingTableViewCell: UITableViewCell {

    @IBOutlet weak var refNoLbl: UILabel!
    
    @IBOutlet weak var vehicleRegoLbl: UILabel!
    
    @IBOutlet weak var makeModelLbl: UILabel!
    
    @IBOutlet weak var associateLbl: UILabel!
    
    @IBOutlet weak var clientNameLbl: UILabel!
    
    @IBOutlet weak var referalName: UILabel!
    
    @IBOutlet weak var repairerName: UILabel!
    
    @IBOutlet weak var statusLbl: UILabel!
    
    @IBOutlet weak var viewMainBorder: UIView!
    
    @IBOutlet weak var dayLbl: UILabel!
    
    @IBOutlet weak var monthYearLbl: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
