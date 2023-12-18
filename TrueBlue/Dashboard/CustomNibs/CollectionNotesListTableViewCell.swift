//
//  CollectionNotesListTableViewCell.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 13/04/23.
//

import UIKit

class CollectionNotesListTableViewCell: UITableViewCell {

    @IBOutlet weak var serialNumberLbl: UILabel!
    @IBOutlet weak var editcollectionNoteBtn: UIButton!
    @IBOutlet weak var clientNameLbl: UILabel!
    @IBOutlet weak var regoNoLbl: UILabel!
    @IBOutlet weak var applicationIdLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
