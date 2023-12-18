//
//  AvailVehicleTblCell.swift
//  TrueBlue
//
//  Created by Ashwani Kumar on 30/08/21.
//

import UIKit

class AvailVehicleTblCell: UITableViewCell {

    @IBOutlet weak var sepThree: UIView!
    @IBOutlet weak var sepTwo: UIView!
    @IBOutlet weak var sepOne: UIView!
    @IBOutlet weak var lblModel: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblRegoNo: UILabel!
    @IBOutlet weak var lblSerialNo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
