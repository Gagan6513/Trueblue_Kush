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
                
                dictArray.is_service_due = dict["is_service_due"] as? Int ?? 0
                dictArray.service_miles_left = dict["service_miles_left"] as? Int ?? 0
                dictArray.last_mileage = dict["last_mileage"] as? String ?? ""
                dictArray.nextserviceduekm = dict["nextserviceduekm"] as? String ?? ""
                dictArray.last_service_mileage = dict["last_service_mileage"] as? String ?? ""
                
                
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
    
    
    var is_service_due: Int?
    var service_miles_left: Int?
    var last_mileage: String?
    var nextserviceduekm: String?
    var last_service_mileage: String?
}
