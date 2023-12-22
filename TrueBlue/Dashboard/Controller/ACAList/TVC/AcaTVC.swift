//
//  AcaTVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 22/12/23.
//

import UIKit

class AcaTVC: UITableViewCell {

    @IBOutlet weak var lblACANo: UILabel!
    @IBOutlet weak var lblCreatedDate: UILabel!
    @IBOutlet weak var lblClientName: UILabel!
    @IBOutlet weak var lblAssociate: UILabel!
    @IBOutlet weak var lblClientPhone: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupDetails(data: ACAList) {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "YYYY-MM-dd hh:mm:ss"
        let created_date = dateFormater.date(from: data.CREATED_ON ?? "") ?? Date()
        dateFormater.dateFormat = "dd-MM-YYYY"

        self.lblACANo.text = data.ACA_ID
        self.lblCreatedDate.text = "\(dateFormater.string(from: created_date))"
        self.lblClientName.text = data.Q_USERNAME
        self.lblAssociate.text = "-" // data.STAGE
        self.lblClientPhone.text = data.Q_CONTACT_NUMBER
        self.lblStatus.text = data.STAGE?.uppercased()
    }
    
}
