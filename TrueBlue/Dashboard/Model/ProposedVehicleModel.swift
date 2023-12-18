//
//  ProposedVehicleModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 24/08/21.
//

import Foundation
class ProposedVehicleModel : NSObject {
    var arrResult = [ProposedVehicleModelData]()
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictArray = ProposedVehicleModelData()
                dictArray.fleetId = dict["fleet_id"] as? String ?? ""
                dictArray.registrationNumber = dict["registration_num"] as? String ?? ""
                arrResult.append(dictArray)
            }
        }
    }
}


struct ProposedVehicleModelData {
    var fleetId : String = ""
    var registrationNumber : String = ""
}
