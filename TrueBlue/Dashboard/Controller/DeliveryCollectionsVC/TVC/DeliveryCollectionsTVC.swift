//
//  DeliveryCollectionsTVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 27/02/24.
//

import UIKit
import SDWebImage

class DeliveryCollectionsTVC: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCarName: UILabel!
    @IBOutlet weak var lblCarId: UILabel!
    @IBOutlet weak var lblClientName: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblRefNumber: UILabel!
    @IBOutlet weak var lblCollectedByTitle: UILabel!
    @IBOutlet weak var lblCollectedByName: UILabel!
    @IBOutlet weak var lblCollectedAtTitle: UILabel!
    @IBOutlet weak var lblCollectedAtName: UILabel!
    @IBOutlet weak var lblReferalName: UILabel!
    @IBOutlet weak var carImage: UIImageView!
    
//    @IBOutlet weak var lblRegoNumber: UILabel!
//    @IBOutlet weak var lblStatus: UILabel!
//    @IBOutlet weak var statusIcon: UIImageView!
//    @IBOutlet weak var lblCollectionBy: UILabel!
    
    @IBOutlet weak var hiredDateView: UIView!
    @IBOutlet weak var lblHiredDate: UILabel!
    @IBOutlet weak var daysCountLabel: UILabel!
    
    @IBOutlet weak var serviceMilage: UILabel!
    @IBOutlet weak var serviceDueinfo: UIView!
    
    @IBOutlet weak var imageLblText: UILabel!
    @IBOutlet weak var imageCountPictures: UILabel!
//
//    @IBOutlet weak var collectedByTitle: UILabel!
    
    var clickedRefButton: (() -> Void)?
    var clickedRegoButton: (() -> Void)?
    var clickedNextButton: (() -> Void)?
    
    var collectionDeliveryDataList: CollectionDeliveryDataList?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCollectionData(data: CollectionDeliveryDataList) {
        self.collectionDeliveryDataList = data
        let yearOF = data.yearof_manufacture?.date(currentFormate: .yyyymmdd, convetedFormate: .YYYY)
        self.lblCarName.text = convertString(str: data.vehicle_make ?? "") + " \(convertString(str: data.vehicle_model ?? "")) (\(yearOF ?? "NA"))"
        
        self.lblRefNumber.text = "#" + convertString(str: data.application_id ?? "")
        self.lblPhoneNumber.text = convertString(str: data.owner_phone ?? "")
        self.lblClientName.text = (data.owner_firstname ?? "") + " " + (data.owner_lastname ?? "") + ","
        
        self.lblCarId.text = data.registration_no
        self.lblReferalName.text = convertString(str: data.referral_name ?? "")
        
        if let url = URL(string: data.fleet_image?.first ?? "") {
            self.carImage.sd_setImage(with: url)
        }
        
        self.lblCollectedByTitle.text = "Collected By:"
        self.lblCollectedAtTitle.text = "Collected At:"
        
        self.lblCollectedByTitle.textColor = UIColor(named: "F39C12")
        self.lblCollectedAtTitle.textColor = UIColor(named: "F39C12")

        self.lblDate.text = data.date_in?.date(convetedFormate: .ddMMMMyyyy)

        self.lblCollectedByName.text = convertString(str: data.collection_by ?? "") + ", "
        self.lblCollectedAtName.text = convertString(str: data.collected_at ?? "")
        
        self.lblHiredDate.text = "\((data.date_out ?? "").date(convetedFormate: .ddMMMMyyyy))"
        
        let startDate = data.date_out?.date(from: .yyyymmdd) ?? Date()
        let endDate = data.date_in?.date(from: .yyyymmdd) ?? Date()
        
        self.daysCountLabel.text = "(\(startDate.timeAgoDisplay(endDate: endDate)))"
        self.hiredDateView.isHidden = false
        
        if((data.fleet_image?.count ?? 0) > 0) {
            if (data.fleet_image?.count ?? 0) > 1 {
                self.imageCountPictures.text = "\(data.fleet_image?.count ?? 0) pictures"
            } else {
                self.imageCountPictures.text = "\(data.fleet_image?.count ?? 0) picture"
            }
        }
        
        self.imageLblText.text = data.registration_no
        self.serviceDueinfo.isHidden = data.is_service_due == 0
        self.serviceMilage.text = "\(data.service_miles_left ?? 0) miles"
    }
    
    func setDeliveredData(data: CollectionDeliveryDataList) {
        self.collectionDeliveryDataList = data
        let yearOF = data.yearof_manufacture?.date(currentFormate: .yyyymmdd, convetedFormate: .YYYY)
        self.lblCarName.text = convertString(str: data.vehicle_make ?? "") + " \(convertString(str: data.vehicle_model ?? "")) (\(yearOF ?? "NA"))"
        
        self.lblRefNumber.text = "#" + convertString(str: data.application_id ?? "")
        self.lblPhoneNumber.text = convertString(str: data.owner_phone ?? "")
        self.lblClientName.text = (data.owner_firstname ?? "") + " " + (data.owner_lastname ?? "") + ","
        
        self.lblCarId.text = data.registration_no
        self.lblReferalName.text = convertString(str: data.referral_name ?? "")
        
        if let url = URL(string: data.fleet_image?.first ?? "") {
            self.carImage.sd_setImage(with: url)
        }
        
        
        self.lblCollectedByTitle.text = "Delivered By:"
        self.lblCollectedAtTitle.text = "Delivered At:"
        
        self.lblCollectedByTitle.textColor = UIColor(named: "07B107")
        self.lblCollectedAtTitle.textColor = UIColor(named: "07B107")

        self.lblDate.text = data.date_out?.date(convetedFormate: .ddMMMMyyyy)

        self.lblCollectedByName.text = convertString(str: data.delivered_by ?? "") + ", "
        self.lblCollectedAtName.text = convertString(str: data.delivered_at ?? "")
        self.hiredDateView.isHidden = true
        
        if((data.fleet_image?.count ?? 0) > 0) {
            if (data.fleet_image?.count ?? 0) > 1 {
                self.imageCountPictures.text = "\(data.fleet_image?.count ?? 0) pictures"
            } else {
                self.imageCountPictures.text = "\(data.fleet_image?.count ?? 0) picture"
            }
        }
        
        self.imageLblText.text = data.registration_no
        self.serviceDueinfo.isHidden = data.is_service_due == 0
        self.serviceMilage.text = "\(data.service_miles_left ?? 0) miles"
    }
    
    func setupDetails(data: CollectionDeliveryDataList) {
        self.collectionDeliveryDataList = data
        let yearOF = data.yearof_manufacture?.date(currentFormate: .yyyymmdd, convetedFormate: .YYYY)
        self.lblCarName.text = convertString(str: data.vehicle_make ?? "") + " \(convertString(str: data.vehicle_model ?? "")) (\(yearOF ?? "NA"))"
        
        self.lblRefNumber.text = "#" + convertString(str: data.application_id ?? "")
        self.lblPhoneNumber.text = convertString(str: data.owner_phone ?? "")
        self.lblClientName.text = (data.owner_firstname ?? "") + " " + (data.owner_lastname ?? "") + ","
        
        self.lblCarId.text = data.registration_no
        self.lblReferalName.text = convertString(str: data.referral_name ?? "")
        
        if let url = URL(string: data.fleet_image?.first ?? "") {
            self.carImage.sd_setImage(with: url)
        }
        
        if (data.booking_status ?? "").lowercased() == "returned" {
            self.lblCollectedByTitle.text = "Collected By:"
            self.lblCollectedAtTitle.text = "Collected At:"
            
            self.lblCollectedByTitle.textColor = UIColor(named: "F39C12")
            self.lblCollectedAtTitle.textColor = UIColor(named: "F39C12")

            self.lblDate.text = data.date_in?.date(convetedFormate: .ddMMMMyyyy)

            self.lblCollectedByName.text = convertString(str: data.collection_by ?? "") + ", "
            self.lblCollectedAtName.text = convertString(str: data.collected_at ?? "")
            
            self.lblHiredDate.text = "\((data.date_out ?? "").date(convetedFormate: .ddMMMMyyyy))"
            
            let startDate = data.date_out?.date(from: .yyyymmdd) ?? Date()
            let endDate = data.date_in?.date(from: .yyyymmdd) ?? Date()
            
            self.daysCountLabel.text = "(\(startDate.timeAgoDisplay(endDate: endDate)))"
            self.hiredDateView.isHidden = false
        }
        
        if (data.booking_status ?? "").lowercased() == "hired" {
            
            self.lblCollectedByTitle.text = "Delivered By:"
            self.lblCollectedAtTitle.text = "Delivered At:"
            
            self.lblCollectedByTitle.textColor = UIColor(named: "07B107")
            self.lblCollectedAtTitle.textColor = UIColor(named: "07B107")

            self.lblDate.text = data.date_out?.date(convetedFormate: .ddMMMMyyyy)

            self.lblCollectedByName.text = convertString(str: data.delivered_by ?? "") + ", "
            self.lblCollectedAtName.text = convertString(str: data.delivered_at ?? "")
            self.hiredDateView.isHidden = true
            
        }
        
        if((data.fleet_image?.count ?? 0) > 0) {
            if (data.fleet_image?.count ?? 0) > 1 {
                self.imageCountPictures.text = "\(data.fleet_image?.count ?? 0) pictures"
            } else {
                self.imageCountPictures.text = "\(data.fleet_image?.count ?? 0) picture"
            }
        }
        
        self.imageLblText.text = data.registration_no
        self.serviceDueinfo.isHidden = data.is_service_due == 0
        self.serviceMilage.text = "\(data.service_miles_left ?? 0) miles"
        
//        if (data.is_swapped ?? "").lowercased() == "yes" && (data.status ?? "").lowercased() == "hired" {
////            self.statusIcon.image = UIImage(named: "ic_swap_tab")
////            self.collectedByTitle.text = "Swapped By:"
////            self.collectedByTitle.textColor = UIColor(named: "3478F6")
////            self.lblStatus.textColor = UIColor(named: "BF28D8")
////            self.lblCollectionBy.text = convertString(str: data.delivered_by ?? "")
////            self.lblHiredDate.isHidden = true
////            self.daysCountLabel.isHidden = true
////            self.lblDate.text = data.date_out?.date(convetedFormate: .ddMMMMyyyy)
////            self.lblStatus.text = "Swapped"
//        }
    }
    
    @IBAction func fullscreenView(_ sender: Any) {
        
        topMostController()?.setAllImages(currentImg: self.collectionDeliveryDataList?.fleet_image?.first ?? "", allImages: self.collectionDeliveryDataList?.fleet_image ?? [], currentIndex: 0)
        
//        topMostController()?.displayImageOnFullScreen(img: self.carImage.image ?? UIImage())
    }
    
    func convertString(str: String) -> String {
        return str == "" ? "NA" : str
    }
    
    @IBAction func btncall(_ sender: Any) {
        if let urlMobile = NSURL(string: "tel://\(self.lblPhoneNumber.text ?? "")"), UIApplication.shared.canOpenURL(urlMobile as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(urlMobile as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(urlMobile as URL)
            }
        }
    }
    
    @IBAction func btnNext(_ sender: Any) {
        self.clickedNextButton?()
    }
    
    @IBAction func btnRegoNumber(_ sender: Any) {
        self.clickedRegoButton?()
    }
    
    @IBAction func btnRefNumber(_ sender: Any) {
        self.clickedRefButton?()
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
