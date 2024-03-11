//
//  AccidentMaintenanceTVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 22/01/24.
//

import UIKit
extension UIView {
    func addBottomRoundedCorner(radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: radius, height: radius))
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = bounds
        shapeLayer.path = maskPath.cgPath
        layer.mask = shapeLayer
    }
}
class FleetsTVC: UITableViewCell {

    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var carId: UILabel!
    @IBOutlet weak var carTypeLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var availableTitleLabel: UILabel!
    @IBOutlet weak var btnReferences: UIButton!
    
    @IBOutlet weak var availableView: UIView!
    @IBOutlet weak var hiredTime: UILabel!
    @IBOutlet weak var hiredDate: UILabel!
    @IBOutlet weak var hiredView: UIView!
    @IBOutlet weak var totalHiredView: UIView!
    @IBOutlet weak var txtMenufacturerYear: UILabel!
    @IBOutlet weak var HiredTitle: UILabel!
    
    var accidentMaintenance: AccidentMaintenance?
    var refClicked: (() -> Void)?
    var btnReferanceClicked: (() -> Void)?
    var serviceClicked: (() -> Void)?
    
    @IBOutlet weak var imageLblView: UIView!
    
    @IBOutlet weak var imageLblText: UILabel!
    
    @IBOutlet weak var imageCountPictures: UILabel!
    
    override func awakeFromNib() {
//
        
        super.awakeFromNib()
//        imageLblView.addBottomRoundedCorner(radius: 6)
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
        
        let timeLabel = self.convertToDate(str: (data.status_modified_on ?? "").date(currentFormate: .yyyymmdd_hhmmss_sss, convetedFormate: .yyyymmdd))
        
        self.availableLabel.text = "\((data.status_modified_on ?? "").date(currentFormate: .yyyymmdd_hhmmss_sss ,convetedFormate: .ddmmyyyy)) (\(timeLabel))"
        
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
        
        /* ================================== */
        self.availableView.isHidden = true
        self.hiredView.isHidden = false
        self.carId.isHidden = true
        
        self.hiredDate.text = "\((data.status_modified_on ?? "").date(currentFormate: .yyyymmdd_hhmmss_sss, convetedFormate: .ddMMMMyyyy))"
        self.hiredTime.text = "(\(timeLabel))"
        
        if data.status_modified_on == nil || (data.status_modified_on ?? "") == "" || (data.status_modified_on ?? "") == "0000-00-00" {
            self.hiredDate.text = "NA"
            self.hiredTime.text = ""
            self.hiredDate.textColor = .gray
        } else {
            self.hiredDate.textColor = .black
        }
        /* ================================== */
        
        if data.status_modified_on == nil || (data.status_modified_on ?? "") == "" || (data.status_modified_on ?? "") == "0000-00-00" {
            self.availableLabel.text = "NA"
            self.availableLabel.textColor = .gray
        }
        
        if let url = URL(string: data.fleet_image?.first ?? "") {
            self.carImage.sd_setImage(with: url)
        }
        
        self.availableTitleLabel.text = "Available Since:"

        self.totalHiredView.isHidden = false
        
        if data.status == "Active" && (data.fleet_status == "Returned" || data.fleet_status == "Free") {
            self.availableTitleLabel.text = "Available Since:"
            self.HiredTitle.text = "Available Since:"
//            let timeLabelll = self.convertToDate(str: (data.status_modified_on ?? "").date(currentFormate: .yyyymmdd, convetedFormate: .yyyymmdd))
//            self.availableLabel.text = "\((data.status_modified_on ?? "").date(currentFormate: .yyyymmdd ,convetedFormate: .ddmmyyyy)) (\(timeLabelll))"
//
//            if data.status_modified_on == nil || (data.status_modified_on ?? "") == "" || (data.status_modified_on ?? "") == "0000-00-00" {
//                self.availableLabel.text = "NA"
//                self.availableLabel.textColor = .gray
//            }
//
        } else if data.status == "Active" && (data.fleet_status == "Hired") {
            self.availableTitleLabel.text = "Hired Since:"
            self.HiredTitle.text = "Hired Since:"
            
//            let timeLabel = self.convertToDate(str: (data.status_modified_on ?? "").date(currentFormate: .yyyymmdd_hhmmss_sss, convetedFormate: .yyyymmdd))
//            self.availableLabel.text = "\((data.status_modified_on ?? "").date(currentFormate: .yyyymmdd_hhmmss_sss ,convetedFormate: .ddmmyyyy)) (\(timeLabel))"
//
        } else if data.status == "Maintenance" {
            self.availableTitleLabel.text = "On Maintenance Since:"
            self.HiredTitle.text = "On Maintenance Since:"
//            let timeLabel = self.convertToDate(str: (data.status_modified_on ?? "").date(currentFormate: .yyyymmdd_hhmmss_sss, convetedFormate: .yyyymmdd))
//            self.availableLabel.text = "\((data.status_modified_on ?? "").date(currentFormate: .yyyymmdd_hhmmss_sss ,convetedFormate: .ddmmyyyy)) (\(timeLabel))"
//
//            if data.status_modified_on == nil || (data.status_modified_on ?? "") == "" || (data.status_modified_on ?? "") == "0000-00-00" {
//                self.availableLabel.text = "NA"
//                self.availableLabel.textColor = .gray
//            }
        }
        if(data.fleet_image!.count > 0) {
            imageCountPictures.text = "\(data.fleet_image!.count) pictures"
        }
        imageLblText.text = data.registration_no!
        
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
