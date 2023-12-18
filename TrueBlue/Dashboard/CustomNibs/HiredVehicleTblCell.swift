//
//  HiredVehicleTblCell.swift
//  TrueBlue
//
//  Created by Ashwani Kumar on 30/08/21.
//

import UIKit

class HiredVehicleTblCell: UITableViewCell {

    @IBOutlet weak var sepFour: UIView!
    @IBOutlet weak var sepThree: UIView!
    @IBOutlet weak var sepTwo: UIView!
    @IBOutlet weak var sepOne: UIView!
    @IBOutlet weak var lblRepairer: UILabel!
    @IBOutlet weak var lblRefNo: UILabel!
    @IBOutlet weak var lblClient: UILabel!
    @IBOutlet weak var lblRegoNo: UILabel!
    @IBOutlet weak var lblSerial: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
