//
//  LogSheetTVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 12/01/24.
//

import UIKit

class LogSheetTVC: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var notesImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupDetails(data: NotesResponseObject) {
        self.titleLabel.text = data.u_name
        self.descriptionLabel.text = data.remarks
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: data.Created_date ?? "") {
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            self.dateLabel.text = dateFormatter.string(from: date)
        }
        self.notesImageView.image = (data.from == "App") ? UIImage(named: "App") : UIImage(named: "website")
    }
    
}
