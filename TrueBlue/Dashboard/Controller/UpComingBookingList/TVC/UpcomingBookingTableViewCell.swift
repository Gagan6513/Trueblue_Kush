//
//  UpcomingBookingTableViewCell.swift
//  TrueBlue
//
//  Created by Kushkumar Katira iMac on 10/01/24.
//

import UIKit

class UpcomingBookingTableViewCell: UITableViewCell {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var associateLabel: UILabel!
    @IBOutlet weak var clientLabel: UILabel!
    @IBOutlet weak var refLabel: UILabel!
    @IBOutlet weak var regoLabel: UILabel!
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.nextButton.layer.cornerRadius = self.nextButton.frame.height / 2
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
    }
    
    func setData(data: UpcomingBookingData) {
        self.associateLabel.text = data.associate_name
        self.clientLabel.text = data.owner_firstname + data.owner_lastname
        self.refLabel.text = data.application_id
        self.regoLabel.text = data.registration_no
        self.carNameLabel.text = data.vehicle_make
        
        let stringDate = formattedDateFromString(dateString: data.expected_delivery_date, withFormat: "dd")
        
        let stringMonthYear = formattedDateFromString(dateString: data.expected_delivery_date, withFormat: "MMM, yyyy")
        
        self.dateLabel.text = stringDate
        self.monthLabel.text = stringMonthYear
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
