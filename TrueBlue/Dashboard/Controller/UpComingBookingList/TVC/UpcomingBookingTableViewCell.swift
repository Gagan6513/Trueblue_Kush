//
//  UpcomingBookingTableViewCell.swift
//  TrueBlue
//
//  Created by Kushkumar Katira iMac on 10/01/24.
//

import UIKit

class UpcomingBookingTableViewCell: UITableViewCell {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var clientLabel: UILabel!

    @IBOutlet weak var refNo: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var clientLicense: UILabel!
    @IBOutlet weak var faultPartyInsurance: UILabel!
    @IBOutlet weak var faultPartyInsuranceNumber: UILabel!
    @IBOutlet weak var repairerName: UILabel!
    
    @IBOutlet weak var expiresOn: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(data: UpcomingBookingData) {
        
        self.clientLabel.text = data.owner_firstname + data.owner_lastname
        let stringDate = formattedDateFromString(dateString: data.expected_delivery_date, withFormat: "dd")
        
        let stringMonthYear = formattedDateFromString(dateString: data.expected_delivery_date, withFormat: "MMM, yyyy")
        
        self.dateLabel.text = stringDate
        self.monthLabel.text = stringMonthYear
        
        self.phoneNumber.text = data.owner_phone
        self.clientLicense.text = data.owner_lic
        self.faultPartyInsurance.text = data.atfault_insurancecompany
        self.faultPartyInsuranceNumber.text = data.atfault_lic_no
        
        self.repairerName.text = data.repairer_name
        
        self.refNo.text = "Ref# \(data.application_id)"
        
        self.expiresOn.text = data.expected_delivery_date
        
    }
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy/MM/dd"
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            return outputFormatter.string(from: date)
        }
        return nil
    }
}
