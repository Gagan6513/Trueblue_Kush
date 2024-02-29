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
    
    @IBAction func btnCall(_ sender: Any) {
        
        if let urlMobile = NSURL(string: "tel://\(self.phoneNumber.text ?? "")"), UIApplication.shared.canOpenURL(urlMobile as URL) {
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(urlMobile as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(urlMobile as URL)
            }
        }
    }
    
    func setData(data: UpcomingBookingData) {
        
        self.clientLabel.text = data.owner_firstname + data.owner_lastname
        let stringDate = formattedDateFromString(dateString: data.expected_delivery_date, withFormat: "dd")
        
        let stringMonthYear = formattedDateFromString(dateString: data.expected_delivery_date, withFormat: "MMM, yyyy")
        
        self.dateLabel.text = stringDate
        self.monthLabel.text = stringMonthYear
        self.dateLabel.textColor = UIColor(named: "AppGray")
        self.monthLabel.textColor = UIColor(named: "AppGray")
        
        let dateee = data.expected_delivery_date.date(from: .yyyymmdd) ?? Date()
        
        if dateee < Date() {
            self.dateLabel.textColor = UIColor(named: "FF0000")
            self.monthLabel.textColor = UIColor(named: "FF0000")
        } else {
            self.dateLabel.textColor = UIColor(named: "AppGray")
            self.monthLabel.textColor = UIColor(named: "AppGray")
        }
        
        self.phoneNumber.text = data.owner_phone == "" ? "NA" : data.owner_phone
        self.clientLicense.text = data.owner_lic == "" ? "NA" : data.owner_lic
        self.faultPartyInsurance.text = data.insurance_company == "" ? "NA" : data.insurance_company
        self.faultPartyInsuranceNumber.text = data.atfault_claimno == "" ? "NA" : data.atfault_claimno
        
        self.repairerName.text = data.repairer_name == "" ? "NA" : data.repairer_name
        
        self.refNo.text = "Ref# \(data.application_id)"
        
//        self.expiresOn.text = data.ownerlic_exp == "" ? "NA" : data.ownerlic_exp
        
//        if (data.ownerlic_exp == "") {
//            self.expiresOn.textColor = .black
//        } else {
//            let date = data.ownerlic_exp.date(from: .ddmmyyyy) ?? Date()
//            if date < Date() {
//                self.expiresOn.textColor = UIColor(named: "FF0000")
//            } else {
//
//                let dateFormater = DateFormatter()
//                dateFormater.dateFormat = "MM"
//                let monthString = dateFormater.string(from: Date())
//                let expiryMonthString = dateFormater.string(from: date)
//                if monthString == expiryMonthString {
//                    self.expiresOn.textColor = UIColor(named: "FF0000")
//                } else {
//                    self.expiresOn.textColor = UIColor(named: "07B107")
//                }
//            }
//        }
        
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
