//
//  AvailableVehicleDropDownListModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 31/08/21.
//

import Foundation
class AvailableVehicleDropDownListModel : NSObject {
    var arrResult = [AvailableVehicleDropDownListModelData]()
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictArray = AvailableVehicleDropDownListModelData()
                dictArray.id = dict["id"] as? String ?? ""
                dictArray.registration_no = dict["registration_no"] as? String ?? ""
                dictArray.fleet_img = dict["fleet_img"] as? [String] ?? []
                dictArray.vehicle_make = dict["vehicle_make"] as? String ?? ""
                dictArray.vehicle_model = dict["vehicle_model"] as? String ?? ""
                arrResult.append(dictArray)
            }
        }
    }
}


struct AvailableVehicleDropDownListModelData {
    var id : String = ""
    var registration_no : String = ""
    var fleet_img: [String] = []
    var vehicle_make: String = ""
    var vehicle_model: String = ""
}
