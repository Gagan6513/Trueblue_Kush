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
                
                dictArray.vehicle_make = dict["vehicle_make"] as? String ?? ""
                dictArray.vehicle_model = dict["vehicle_model"] as? String ?? ""
                
                var fleet_arr = [fleet_docs]()
                
                if let fleet_arr_a = dict["fleet_docs"] as? Array<Dictionary<String, Any>> {
                    for dict in fleet_arr_a {
                        var dictArray = fleet_docs()
                        dictArray.document_name = dict["document_name"] as? String ?? ""
                        dictArray.document_id = dict["document_id"] as? String ?? ""
                        dictArray.booking_id = dict["booking_id"] as? String ?? ""
                        dictArray.image_url = dict["image_url"] as? String ?? ""
                        dictArray.sequence = dict["sequence"] as? String ?? ""
                        fleet_arr.append(dictArray)
                    }
                }
                
                dictArray.fleet_docs = fleet_arr
                
                dictArray.booking_id = dict["booking_id"] as? String ?? ""
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

    var booking_id: String = ""
    var application_id : String = ""
    var refno : String = ""
    var vehicle_id : String = ""
    var registration_no : String = ""
    
    var fleet_docs: [fleet_docs] = []
    
    var Mileage_out : String = ""
    var date_out : String = ""
    var fuel_out : String = ""
    var time_out : String = ""
    
    var vehicle_make: String = ""
    var vehicle_model: String = ""
    
}

struct fleet_docs {
    
    var document_name: String?
    var document_id: String?
    var booking_id: String?
    var image_url: String?
    var sequence: String?
    
}
