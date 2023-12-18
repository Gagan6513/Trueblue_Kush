//
//  SearchDashboardResultDetailTblViewCell.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 31/08/21.
//

import UIKit

class SearchDashboardResultDetailTblViewCell: UITableViewCell {


    @IBOutlet weak var referenceNumberLbl: UILabel!
    @IBOutlet weak var vehicleRegoLbl: UILabel!
    @IBOutlet weak var makeModelLbl: UILabel!
    @IBOutlet weak var clientNameLbl: UILabel!
    @IBOutlet weak var dateOutLbl: UILabel!
    @IBOutlet weak var dateInLbl: UILabel!
    @IBOutlet weak var settledAmountLbl: UILabel!
    @IBOutlet weak var paymentAmountLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var totalDaysLbl: UILabel!
    
    @IBOutlet weak var clientRegoLbl: UILabel!
    @IBOutlet weak var clientMakeModelLbl: UILabel!
    @IBOutlet weak var repairerNameLbl: UILabel!
    @IBOutlet weak var referralNameLbl: UILabel!
    
    @IBOutlet weak var viewSwappedVehicleView: UIStackView!
    @IBOutlet weak var viewSwappedVehicleBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
