//
//  DeliveriesModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 20/08/21.
//

import Foundation
class DeliveriesModel : NSObject {
    var arrResult = [DeliveriesModelData]()
    
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictArray = DeliveriesModelData()
                
                dictArray.id = dict["id"] as? String ?? ""
                dictArray.applicationId = dict["application_id"] as? String ?? ""
                dictArray.clientName = dict["name"] as? String ?? ""
                dictArray.vehicleId = dict["vehicle_id"] as? String ?? ""
                dictArray.dateOut = dict["date_out"] as? String ?? ""
                dictArray.expectedDeliveryDate = dict["expected_delivery_date"] as? String ?? ""
                dictArray.dateIn = dict["date_in"] as? String ?? ""
                dictArray.repairerName = dict["repairer_name"] as? String ?? ""
                
                dictArray.make = dict["make"] as? String ?? ""
                dictArray.model = dict["model"] as? String ?? ""
                dictArray.app_status = dict["app_status"] as? String ?? ""
                dictArray.owner_registration_no = dict["owner_registration_no"] as? String ?? ""
                dictArray.proposed_vehicle = dict["proposed_vehicle"] as? String ?? ""
                dictArray.sgn = dict["sgn"] as? String ?? ""
                
                arrResult.append(dictArray)
            }
        }
    }
}


struct DeliveriesModelData {
    
    var id : String = ""
    var applicationId : String = ""
    var clientName : String = ""
    var vehicleId : String = ""
    var dateOut : String = ""
    var dateIn : String = ""
    var expectedDeliveryDate : String = ""
    var repairerName : String = ""
    var make : String = ""
    var model : String = ""
    var app_status : String = ""
    var owner_registration_no : String = ""
    var proposed_vehicle : String = ""
    var sgn : String = ""
    
}
