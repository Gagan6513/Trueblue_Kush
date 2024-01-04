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
        statusLabel.text = data.status
        nameLabel.text = data.name
        groupLabel.text = data.group_name
    }
}
