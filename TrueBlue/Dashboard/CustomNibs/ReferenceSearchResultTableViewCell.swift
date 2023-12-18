//
//  ReferenceSearchResultTableViewCell.swift
//  TrueBlue
//
//  Created by Sharad Patil on 16/12/23.
//

import UIKit

class ReferenceSearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var daysLbl: UILabel!
    @IBOutlet weak var hiredLbl: UILabel!
    @IBOutlet weak var carNumberLbl: UILabel!
    @IBOutlet weak var carNameLbl: UILabel!
    @IBOutlet weak var colorView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
