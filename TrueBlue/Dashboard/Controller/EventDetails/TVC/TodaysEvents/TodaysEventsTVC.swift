//
//  TodaysEventsTVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 25/12/23.
//

import UIKit

class TodaysEventsTVC: UITableViewCell {

    @IBOutlet weak var lblBy: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTo: UILabel!
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var viewSidebar: UIView!
    @IBOutlet weak var viewBG: UIView!
    
    var events = Events()
    var editButtonClicked: ((Events) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupDetails(data: Events) {
        self.events = data
        self.lblBy.text = data.ASSIGNED_BY_USER?.capitalized
        
        self.lblDescription.text = (data.EVENT_DESC ?? "")
        
        self.lblTo.text = data.ASSIGNED_TO_USER?.capitalized
        self.lblTime.text = data.EVENT_TIME
        
        let api_timeFormater = DateFormatter()
        api_timeFormater.dateFormat =  "HH:mm"
        let api_time = api_timeFormater.date(from: data.EVENT_TIME ?? "")
        api_timeFormater.dateFormat =  "hh:mm a"
        self.lblTime.text = api_timeFormater.string(from: api_time ?? Date())

        if data.EVENT_TYPE ?? "" == "collection_notes" {
            self.imgIcon.image = UIImage(named: "Timer_event")
            self.lblBy.textColor = UIColor(named: "AppOrange")
            self.viewSidebar.backgroundColor = UIColor(named: "AppOrange")
            self.viewBG.backgroundColor = UIColor(named: "AppOrange")?.withAlphaComponent(0.2)
        } else if data.EVENT_TYPE ?? "" == "delivery_notes" {
            self.imgIcon.image = UIImage(named: "Delivery_event")
            self.lblBy.textColor = UIColor(named: "3478F6")
            self.viewSidebar.backgroundColor = UIColor(named: "3478F6")
            self.viewBG.backgroundColor = UIColor(named: "3478F6")?.withAlphaComponent(0.2)
        } else {
            self.imgIcon.image = UIImage(named: "Todo_event")
            self.lblBy.textColor = UIColor(named: "07B107")
            self.viewSidebar.backgroundColor = UIColor(named: "07B107")
            self.viewBG.backgroundColor = UIColor(named: "07B107")?.withAlphaComponent(0.2)
        }
        
        if (data.STAGE?.lowercased() ?? "") == "pending" {
            self.imgIcon.image = UIImage(named: "Timer_event")
        } else {
            self.imgIcon.image = UIImage(named: "Todo_event")
        }
        
    }
    
    @IBAction func btnEdit(_ sender: Any) {
        self.editButtonClicked?(self.events)
    }
}
