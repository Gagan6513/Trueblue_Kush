//
//  HiredVehicleDropdownListModel.swift
//  TrueBlue
//
//  Created by Ashwani Kumar on 30/08/21.
//

import Foundation
class HiredVehicleDropdownListModel : NSObject {
    var arrResult = [HiredVehicleDropdownListModelData]()
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictArray = HiredVehicleDropdownListModelData()
                dictArray.application_id = dict["application_id"] as? String ?? ""
                dictArray.refno = dict["refno"] as? String ?? ""
                dictArray.vehicle_id = dict["vehicle_id"] as? String ?? ""
                dictArray.registration_no = dict["registration_no"] as? String ?? ""
                
                dictArray.Mileage_out = dict["Mileage_out"] as? String ?? ""
                dictArray.date_out = dict["date_out"] as? String ?? ""
                dictArray.fuel_out = dict["fuel_out"] as? String ?? ""
                dictArray.time_out = dict["time_out"] as? String ?? ""
                
                arrResult.append(dictArray)
            }
        }
    }
}


struct HiredVehicleDropdownListModelData {

    var application_id : String = ""
    var refno : String = ""
    var vehicle_id : String = ""
    var registration_no : String = ""
    
    
    var Mileage_out : String = ""
    var date_out : String = ""
    var fuel_out : String = ""
    var time_out : String = ""
    
}
