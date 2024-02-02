//
//  ViewReferenceTVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 22/01/24.
//

import UIKit

class FleetViewReferenceTVC: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var clientNameLabel: UILabel!
    @IBOutlet weak var insuranceCompanyNameLabel: UILabel!
    @IBOutlet weak var claimNoLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var dateOutInLabel: UILabel!
    @IBOutlet weak var totalDaysLabel: UILabel!
    
    var detailsButtonClicked: (() -> Void)?
    var viewButtonClicked: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupDetails(data: AccidentReferance) {
        self.idLabel.text = "Ref# \((data.application_id ?? "") == "" ? "NA" : (data.application_id ?? ""))"
        self.clientNameLabel.text = "\(data.owner_firstname ?? "") \(data.owner_lastname ?? "")"
        self.insuranceCompanyNameLabel.text = (data.atfault_firstname ?? "") == "" ? "NA" : (data.atfault_firstname ?? "")
        self.claimNoLabel.text = (data.atfault_claimno ?? "") == "" ? "NA" : (data.atfault_claimno ?? "")
        self.phoneNumberLabel.text = (data.owner_phone ?? "") == "" ? "NA" : (data.owner_phone ?? "")
        
        let date_out = (data.date_out ?? "") == "" ? "NA" : (data.date_out ?? "")
        let date_in = (data.date_in ?? "") == "" ? "NA" : (data.date_in ?? "")
        
        self.dateOutInLabel.text = "\(date_out) / \(date_in)"
        
        let date_outt = date_out.date(from: .ddmmyyyy) ?? Date()
        let date_inn = date_in.date(from: .ddmmyyyy) ?? Date()

        
        self.totalDaysLabel.text = getTimeComponentString(olderDate: date_outt, newerDate: date_inn)
    }
    
    @IBAction func btnCall(_ sender: Any) {
        if let urlMobile = NSURL(string: "tel://\(self.phoneNumberLabel.text ?? "")"), UIApplication.shared.canOpenURL(urlMobile as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(urlMobile as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(urlMobile as URL)
            }
        }
    }
    
    @IBAction func btnOpenDetailsScreen(_ sender: Any) {
        self.detailsButtonClicked?()
    }
    
    @IBAction func btnOpenRefView(_ sender: Any) {
        self.viewButtonClicked?()
    }
    
    func getTimeComponentString(olderDate older: Date,newerDate newer: Date) -> (String?)  {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full

        let componentsLeftTime = Calendar.current.dateComponents([.day], from: older, to: newer)

        let day = componentsLeftTime.day ?? 0
        if  day > 0 {
            formatter.allowedUnits = [.day]
            return formatter.string(from: older, to: newer)
        }

        return "0"
    }
}
