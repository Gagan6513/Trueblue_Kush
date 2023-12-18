//
//  UpcomingBookingListCell.swift
//  TrueBlue
//
//  Created by Inexture Solutions LLP on 05/12/23.
//

import Foundation
import UIKit

class UpcomingBookingListCell: UITableViewCell {

//    @IBOutlet weak var serialNumberLbl: UILabel!
//    @IBOutlet weak var editcollectionNoteBtn: UIButton!
//    @IBOutlet weak var clientNameLbl: UILabel!
//    @IBOutlet weak var regoNoLbl: UILabel!
//    @IBOutlet weak var applicationIdLbl: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var dateMonthYearLbl: UILabel!
    @IBOutlet weak var VehicleRegoLbl: UILabel!
    @IBOutlet weak var MakeModelLbl: UILabel!
    @IBOutlet weak var RefNoLbl: UILabel!
    @IBOutlet weak var AssociateLbl: UILabel!
    @IBOutlet weak var ClientNameLbl: UILabel!
    @IBOutlet weak var viewMainBorder: UIView!
    @IBOutlet weak var lblColor: UILabel!
    @IBOutlet weak var viewColor: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
