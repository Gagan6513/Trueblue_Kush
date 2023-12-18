//
//  HiredVehicleListModel.swift
//  TrueBlue
//
//  Created by Ashwani Kumar on 28/08/21.
//

import Foundation
class HiredVehicleListModel : NSObject {
    var arrResult = [HiredVehicleListModelData]()
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictArray = HiredVehicleListModelData()
                dictArray.application_id = dict["application_id"] as? String ?? ""
                dictArray.refno = dict["refno"] as? String ?? ""
                dictArray.vehicle_id = dict["vehicle_id"] as? String ?? ""
                dictArray.registration_no = dict["registration_no"] as? String ?? ""
                dictArray.owner_name = dict["owner_name"] as? String ?? ""
                dictArray.repairer_name = dict["repairer_name"] as? String ?? ""
                dictArray.srno = dict["srno"] as? String ?? ""
                
                arrResult.append(dictArray)
            }
        }
    }
}


struct HiredVehicleListModelData {

    var application_id : String = ""
    var refno : String = ""
    var vehicle_id : String = ""
    var registration_no : String = ""
    var owner_name : String = ""
    var repairer_name : String = ""
    var srno : String = ""
    
}
