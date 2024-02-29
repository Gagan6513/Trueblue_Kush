//
//  DeliveryCollectionsTVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 27/02/24.
//

import UIKit

class DeliveryCollectionsTVC: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblRefNumber: UILabel!
    @IBOutlet weak var lblRegoNumber: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var statusIcon: UIImageView!
    @IBOutlet weak var lblClientName: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblCollectionBy: UILabel!
    @IBOutlet weak var lblHiredDate: UILabel!
    @IBOutlet weak var daysCountLabel: UILabel!
    
    @IBOutlet weak var collectedByTitle: UILabel!
    
    var clickedRefButton: (() -> Void)?
    var clickedRegoButton: (() -> Void)?
    var clickedNextButton: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupDetails(data: CollectionDeliveryDataList) {
        self.lblRefNumber.text = convertString(str: data.application_id ?? "")
        self.lblRegoNumber.text = convertString(str: data.registration_no ?? "")
        self.lblPhoneNumber.text = convertString(str: data.owner_phone ?? "")
        self.lblClientName.text = (data.owner_firstname ?? "") + " " + (data.owner_lastname ?? "")
        
        if (data.status ?? "").lowercased() == "returned" {
            self.statusIcon.image = UIImage(named: "ic_collection_tab")
            self.collectedByTitle.text = "Collected By:"
            self.collectedByTitle.textColor = UIColor(named: "726F6F")
            self.lblStatus.textColor = UIColor(named: "AppOrange")
            self.lblCollectionBy.text = convertString(str: data.collection_by ?? "")
            self.lblHiredDate.isHidden = false
            self.daysCountLabel.isHidden = false
            self.lblHiredDate.text = "Hired Date: \((data.date_out ?? "").date(convetedFormate: .ddMMMMyyyy))" 
            
             let date1st = formattedDateFromString(dateString: data.date_in ?? "", withFormat: "dd")

            let date2nd = formattedDateFromString(dateString: data.date_in ?? "", withFormat: "MMM, yyyy")

            self.lblDate.text = data.date_in?.date(convetedFormate: .ddMMMMyyyy)
            self.lblStatus.text = "Collected"
            
            let startDate = data.date_out?.date(from: .yyyymmdd) ?? Date()
            let endDate = data.date_in?.date(from: .yyyymmdd) ?? Date()
            
            self.daysCountLabel.text = "(\(startDate.timeAgoDisplay(endDate: endDate)))"
        }
        
        if (data.status ?? "").lowercased() == "hired" {
            self.statusIcon.image = UIImage(named: "ic_delivery_tab")
            self.collectedByTitle.text = "Delivered By:"
            self.collectedByTitle.textColor = UIColor(named: "3478F6")
            self.lblStatus.textColor = UIColor(named: "07B107")
            self.lblCollectionBy.text = convertString(str: data.delivered_by ?? "")
            self.lblHiredDate.isHidden = true
            self.daysCountLabel.isHidden = true
            self.lblDate.text = data.date_out?.date(convetedFormate: .ddMMMMyyyy)
            self.lblStatus.text = "Delivered"
        }
        
        if (data.is_swapped ?? "").lowercased() == "yes" && (data.status ?? "").lowercased() == "hired" {
            self.statusIcon.image = UIImage(named: "ic_swap_tab")
            self.collectedByTitle.text = "Swapped By:"
            self.collectedByTitle.textColor = UIColor(named: "3478F6")
            self.lblStatus.textColor = UIColor(named: "BF28D8")
            self.lblCollectionBy.text = convertString(str: data.delivered_by ?? "")
            self.lblHiredDate.isHidden = true
            self.daysCountLabel.isHidden = true
            self.lblDate.text = data.date_out?.date(convetedFormate: .ddMMMMyyyy)
            self.lblStatus.text = "Swapped"
        }
        
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
