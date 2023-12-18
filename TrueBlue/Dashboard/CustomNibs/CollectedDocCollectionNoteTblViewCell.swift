//
//  CollectedDocCollectionNoteTblViewCell.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 20/04/23.
//

import UIKit

class CollectedDocCollectionNoteTblViewCell: UITableViewCell {

    @IBOutlet weak var checkImg: UIImageView!
    @IBOutlet weak var documentNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
