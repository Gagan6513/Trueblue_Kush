//
//  NewEventTVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira iMac on 10/01/24.
//

import UIKit

class NewEventTVC: UITableViewCell {

    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var lblTask: UILabel!
    @IBOutlet weak var lblDelivery: UILabel!
    @IBOutlet weak var lblCollection: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(data: EventList) {
        self.lblCollection.text = data.COLLECTION_NOTES ?? "0"
        self.lblDelivery.text = data.DELIVERY_NOTES ?? "0"
        self.lblTask.text = data.TODO_TASK ?? "0"
        self.lblSummary.text = (data.PENDING_EVENT ?? "0") + " / " + (data.TOTAL_EVENT ?? "0")
//        self.lblTotalEvents.text = data.TOTAL_EVENT
//        self.lblPendingEvents.text = data.PENDING_EVENT
    }
}
