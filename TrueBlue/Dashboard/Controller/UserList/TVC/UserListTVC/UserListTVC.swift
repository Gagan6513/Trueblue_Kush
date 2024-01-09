//
//  UserListTVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira iMac on 04/01/24.
//

import UIKit

class UserListTVC: UITableViewCell {

//    MARK: - variable
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    
    @IBOutlet weak var deliveryNotesLabel: UILabel!
    @IBOutlet weak var collectionNotesLabel: UILabel!
    @IBOutlet weak var todoNotesLabel: UILabel!
    
    @IBOutlet weak var lastLogin: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    //    MARK: - Variable
    var isLogoutClicked: (() -> Void)?
    
//    MARK: - Override Function
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    MARK: - Button Action
    @IBAction func logOutButtonAction(_ sender: Any) {
        self.isLogoutClicked?()
    }
    
    func setData(data: AllUserListData) {
        userNameLabel.text = data.username
//        statusLabel.text = data.status
//        nameLabel.text = data.name
        groupLabel.text = data.group_name
        
        deliveryNotesLabel.text = data.delivery_notes
        collectionNotesLabel.text = data.collection_notes
        todoNotesLabel.text = data.todo_task
        
        self.btnLogin.isSelected = (data.status ?? "").lowercased() == "active"
        
        lastLogin.text = "Last logged in: \((data.lastLoggedIn ?? ""))"
    }
}

extension Date {
 func timeAgoDisplay() -> String {

        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!

        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "\(diff) sec ago"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return "\(diff) min ago"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return "\(diff) hrs ago"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            return "\(diff) days ago"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        return "\(diff) weeks ago"
    }
}
