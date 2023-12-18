//
//  DeliveryNotesListTableViewCell.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 12/04/23.
//

import UIKit

class DeliveryNotesListTableViewCell: UITableViewCell {

    @IBOutlet weak var applicationIdLbl: UILabel!
    @IBOutlet weak var serialNumberLbl: UILabel!
    @IBOutlet weak var editDeliveryNoteBtn: UIButton!
    @IBOutlet weak var clientNameLbl: UILabel!
    @IBOutlet weak var REGONoLbl: UILabel!
    @IBOutlet weak var borderOneView: UIView!
    @IBOutlet weak var borderFourView: UIView!
    @IBOutlet weak var borderThreeView: UIView!
    @IBOutlet weak var borderTwoView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
