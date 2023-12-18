//
//  UnderMaintenanceViewCell.swift
//  TrueBlue
//
//  Created by Gurmeet Kaur Narang on 13/12/23.
//

import UIKit

class UnderMaintenanceViewCell: UITableViewCell {

    @IBOutlet weak var lbl_SrNo: UILabel!
    @IBOutlet weak var lbl_SrNo1: UILabel!
    @IBOutlet weak var lbl_Category: UILabel!
    @IBOutlet weak var lbl_Category1: UILabel!
    @IBOutlet weak var lbl_Model: UILabel!
    @IBOutlet weak var lbl_Model1: UILabel!
    @IBOutlet weak var lbl_RegNo: UILabel!
    @IBOutlet weak var lbl_RegNo1: UILabel!
    @IBOutlet weak var lbl_FuelType: UILabel!
    @IBOutlet weak var lbl_FuelType1: UILabel!
    @IBOutlet weak var lbl_Transmission: UILabel!
    @IBOutlet weak var lbl_Transmission1: UILabel!
    @IBOutlet weak var lbl_Status: UILabel!
    @IBOutlet weak var lbl_Status1: UILabel!
    @IBOutlet weak var lbl_PurchaseDate: UILabel!
    @IBOutlet weak var lbl_PurchaseDate1: UILabel!
    
    @IBOutlet weak var view_Background: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
