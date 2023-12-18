//
//  UnderMaintenanceModel.swift
//  TrueBlue
//
//  Created by Gurmeet Kaur Narang on 13/12/23.
//

import Foundation
class UnderMaintenanceModel : NSObject {
    var arrResult = [UnderMaintenanceModelData]()
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictArray = UnderMaintenanceModelData()
                dictArray.category = dict["vehicle_category"] as? String ?? ""
                dictArray.id = dict["id"] as? String ?? ""
                dictArray.make = dict["vehicle_make"] as? String ?? ""
                dictArray.registration_no = dict["registration_no"] as? String ?? ""
                dictArray.fuel_type = dict["fuel_type"] as? String ?? ""
                dictArray.transmission = dict["transmission"] as? String ?? ""
                dictArray.status = dict["status"] as? String ?? ""
                dictArray.purchase_from = dict["purchase_date"] as? String ?? ""
                dictArray.model = dict["vehicle_model"] as? String ?? ""
                arrResult.append(dictArray)
            }
        }
    }
}


struct UnderMaintenanceModelData {

    var category : String = ""
    var id : String = ""
    var make : String = ""
    var registration_no : String = ""
    var model : String = ""
    var fuel_type : String = ""
    var transmission : String = ""
    var status : String = ""
    var purchase_from : String = ""
    
    
}
