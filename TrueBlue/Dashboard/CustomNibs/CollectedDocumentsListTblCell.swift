//
//  CollectedDocumentsListTblCell.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 18/04/23.
//

import UIKit

class CollectedDocumentsListTblCell: UITableViewCell {

    @IBOutlet weak var checkImgeView: UIImageView!
    @IBOutlet weak var documentLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
