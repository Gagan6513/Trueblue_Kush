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
    
    @IBOutlet weak var totalHiredView: UIView!
    @IBOutlet weak var txtMenufacturerYear: UILabel!
    
    var accidentMaintenance: AccidentMaintenance?
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
        topMostController()?.setAllImages(currentImg: accidentMaintenance?.fleet_image?.first ?? "", allImages: (accidentMaintenance?.fleet_image ?? []), currentIndex: 0)
//        topMostController()?.displayImageOnFullScreen(img: self.carImage.image ?? UIImage())
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
        self.accidentMaintenance = data
        self.carNameLabel.text = self.convertString(str: (data.vehicle_make ?? "")) + " (\(self.convertString(str: (data.vehicle_model ?? ""))))"
        self.carId.text = "\(self.convertString(str: (data.registration_no ?? "")))"
        self.carTypeLabel.text = self.convertString(str: (data.vehicle_category ?? ""))
        
        let timeLabel = self.convertToDate(str: (data.status_modified_on ?? ""))
        
        self.availableLabel.text = "\((data.status_modified_on ?? "").date(currentFormate: .yyyymmdd_hhmmss_sss ,convetedFormate: .ddmmyyyy))" // (\(timeLabel))"
        
        self.availableLabel.textColor = UIColor(named: "07B107")

        self.txtMenufacturerYear.text = "\((data.yearof_manufacture ?? "").date(currentFormate: .yyyymmdd ,convetedFormate: .ddmmyyyy))"
        
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
        
        if let url = URL(string: data.fleet_image?.first ?? "") {
            self.carImage.sd_setImage(with: url)
        }
        
        self.availableTitleLabel.text = "Available Since:"

        self.totalHiredView.isHidden = false
        
        if data.status == "Active" && (data.fleet_status == "Returned" || data.fleet_status == "Free") {
            self.availableTitleLabel.text = "Available Since:"
            let timeLabelll = self.convertToDate(str: (data.status_modified_on ?? "").date(currentFormate: .yyyymmdd, convetedFormate: .yyyymmdd))
            self.availableLabel.text = "\((data.status_modified_on ?? "").date(currentFormate: .yyyymmdd ,convetedFormate: .ddmmyyyy)) (\(timeLabelll))"
            
            if timeLabelll.contains("days ago") {
                if let month = timeLabelll.first {
                    if (Int(String(month)) ?? 0) <= 28 {
                        self.availableLabel.textColor = UIColor(named: "07B107")
                    } else if (Int(String(month)) ?? 0) <= 168 {
                        self.availableLabel.textColor = UIColor.purple
                    } else {
                        self.availableLabel.textColor = UIColor(named: "FF0000")
                    }
                }
            }
            
            if data.status_modified_on == nil || (data.status_modified_on ?? "") == "" || (data.status_modified_on ?? "") == "0000-00-00" {
                self.availableLabel.text = "NA"
                self.availableLabel.textColor = .gray
            }
            
        } else if data.status == "Active" && (data.fleet_status == "Hired") {
            self.availableTitleLabel.text = "Hired Since:"
            let timeLabel = self.convertToDate(str: (data.status_modified_on ?? "").date(currentFormate: .yyyymmdd_hhmmss_sss, convetedFormate: .yyyymmdd))
            self.availableLabel.text = "\((data.status_modified_on ?? "").date(currentFormate: .yyyymmdd_hhmmss_sss ,convetedFormate: .ddmmyyyy)) (\(timeLabel))"
            
            if data.status_modified_on == nil || (data.status_modified_on ?? "") == "" || (data.status_modified_on ?? "") == "0000-00-00" {
                self.availableLabel.text = "NA"
                self.availableLabel.textColor = .gray
            }
        } else if data.status == "Maintenance" {
            self.availableTitleLabel.text = "On Maintenance Since:"
            let timeLabel = self.convertToDate(str: (data.status_modified_on ?? "").date(currentFormate: .yyyymmdd_hhmmss_sss, convetedFormate: .yyyymmdd))
            self.availableLabel.text = "\((data.status_modified_on ?? "").date(currentFormate: .yyyymmdd_hhmmss_sss ,convetedFormate: .ddmmyyyy)) (\(timeLabel))"

            if data.status_modified_on == nil || (data.status_modified_on ?? "") == "" || (data.status_modified_on ?? "") == "0000-00-00" {
                self.availableLabel.text = "NA"
                self.availableLabel.textColor = .gray
            }
        }
    }
    
    func convertString(str: String) -> String {
        return str == "" ? "NA" : str
    }
    
    func convertToDate(str: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"// HH:mm:ss.SSS"
        let date = dateFormatter.date(from: str) ?? Date()
        return date.getDays()
    }
}
