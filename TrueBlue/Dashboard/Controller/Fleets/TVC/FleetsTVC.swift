//
//  AccidentMaintenanceTVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 22/01/24.
//

import UIKit

class FleetsTVC: UITableViewCell {

    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var carId: UILabel!
    @IBOutlet weak var carTypeLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var availableTitleLabel: UILabel!
    @IBOutlet weak var btnReferences: UIButton!
    
    var refClicked: (() -> Void)?
    var btnReferanceClicked: (() -> Void)?
    var serviceClicked: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnShowFullscreen(_ sender: Any) {
        topMostController()?.displayImageOnFullScreen(img: self.carImage.image ?? UIImage())
    }
    
    @IBAction func btnReference(_ sender: Any) {
        self.refClicked?()
    }
    
    @IBAction func btnServiceHistory(_ sender: Any) {
        self.serviceClicked?()
    }
    
    @IBAction func btnReferences(_ sender: Any) {
        self.btnReferanceClicked?()
    }
    
    func setupDetails(data: AccidentMaintenance) {
        self.carNameLabel.text = self.convertString(str: (data.vehicle_make ?? "")) + " (\(self.convertString(str: (data.vehicle_model ?? ""))))"
        self.carId.text = "\(self.convertString(str: (data.registration_no ?? "")))"
        self.carTypeLabel.text = self.convertString(str: (data.vehicle_category ?? ""))
        
        let timeLabel = self.convertToDate(str: (data.status_modified_on ?? ""))
        
        self.availableLabel.text = timeLabel // self.convertString(str: (data.status_modified_on ?? ""))
        
        self.availableLabel.textColor = UIColor(named: "07B107")

        if timeLabel.contains("days ago") {
            if let month = timeLabel.first {
                if (Int(String(month)) ?? 0) <= 28 {
                    self.availableLabel.textColor = UIColor(named: "07B107")
                } else if (Int(String(month)) ?? 0) <= 168 {
                    self.availableLabel.textColor = UIColor.purple
                } else {
                    self.availableLabel.textColor = UIColor(named: "FF0000")
                }
            }
        }
        
        if data.status_modified_on == nil && (data.status_modified_on ?? "") == "" {
            self.availableLabel.text = "NA"
            self.availableLabel.textColor = .gray
        }

        
        if let url = URL(string: data.fleet_image ?? "") {
            self.carImage.sd_setImage(with: url)
        }
        
    }
    
    func convertString(str: String) -> String {
        return str == "" ? "NA" : str
    }
    
    func convertToDate(str: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let date = dateFormatter.date(from: str) ?? Date()
        return date.timeAgoDisplay()
    }
}
