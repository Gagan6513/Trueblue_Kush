//
//  ServiceTVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 26/01/24.
//

import UIKit

class ServiceTVC: UITableViewCell {

    @IBOutlet weak var repairerName: UILabel!
    @IBOutlet weak var serviceDate: UILabel!
    @IBOutlet weak var lastServiceMileage: UILabel!
    @IBOutlet weak var nextServiceDue: UILabel!
    
    var btnViewClicked: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnEdit(_ sender: Any) {
        self.btnViewClicked?(false)
    }
    
    @IBAction func btnView(_ sender: Any) {
        self.btnViewClicked?(true)
    }
    
    func setupDetails(data: AccidentService) {
        self.repairerName.text = (data.repairer_name ?? "") == "" ? "NA" : (data.repairer_name ?? "")
        self.serviceDate.text = (data.service_date ?? "") == "" ? "NA" : (data.service_date ?? "").date(convetedFormate: .ddmmyyyy)
        self.lastServiceMileage.text = (data.service_mileage ?? "") == "" ? "NA" : (data.service_mileage ?? "")
        self.nextServiceDue.text = (data.nextserviceduekm ?? "") == "" ? "NA" : (data.nextserviceduekm ?? "")
    }
    
}
