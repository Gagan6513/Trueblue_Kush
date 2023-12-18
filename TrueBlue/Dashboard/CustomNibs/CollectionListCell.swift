//
//  CollectionListCell.swift
//  TrueBlue
//
//  Created by Ashwani Kumar on 26/08/21.
//

import UIKit

class CollectionListCell: UITableViewCell {

    @IBOutlet weak var REGONoLbl: UILabel!
    @IBOutlet weak var borderThreeView: UIView!
    
    @IBOutlet weak var serialNumberLbl: UILabel!
    @IBOutlet weak var applicationIdLbl: UILabel!
    @IBOutlet weak var clientNameLbl: UILabel!
    @IBOutlet weak var borderOneView: UIView!
    @IBOutlet weak var borderTwoView: UIView!
    @IBOutlet weak var borderFourView: UIView!
    @IBOutlet weak var collectionsBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
