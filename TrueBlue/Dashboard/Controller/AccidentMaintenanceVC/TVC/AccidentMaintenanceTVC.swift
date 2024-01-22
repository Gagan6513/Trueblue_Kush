//
//  AccidentMaintenanceTVC.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 22/01/24.
//

import UIKit

class AccidentMaintenanceTVC: UITableViewCell {

    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var carId: UILabel!
    @IBOutlet weak var carTypeLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnReference(_ sender: Any) {
    }
    
    @IBAction func btnServiceHistory(_ sender: Any) {
    }
    
    @IBAction func btnNewBooking(_ sender: Any) {
    }
    
    func setupDetails(data: AccidentMaintenance) {
        self.carNameLabel.text = data.vehicle_model
        self.carId.text = "/ \(data.registration_no ?? "")"
        self.carTypeLabel.text = data.vehicle_category
        self.availableLabel.text = data.status_modified_on
        
        if let url = URL(string: data.fleet_image ?? "") {
            self.carImage.sd_setImage(with: url)
        }
        
    }
}
