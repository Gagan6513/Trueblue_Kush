//
//  BookingDetailsModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 27/08/21.
//
//
import Foundation
class BookingDetailsModel : NSObject {
    var dictResult = BookingDetailsModelData()
    init(dict : Dictionary<String, Any>) {
        dictResult.dateOut = dict["date_out"] as? String ?? ""
        dictResult.timeOut = dict["time_out"] as? String ?? ""
        dictResult.mileageOut = dict["Mileage_out"] as? String ?? ""
        dictResult.fuelOut = dict["fuel_out"] as? String ?? ""
        dictResult.deliveryLocation = dict["delivery_location"] as? String ?? ""
        dictResult.expectedDeliveryDate = dict["expected_delivery_date"] as? String ?? ""
        dictResult.expectedDeliveryTime = dict["expected_delivery_time"] as? String ?? ""
        dictResult.proposedVehicle = dict["proposed_vehicle"] as? String ?? ""
        dictResult.vehicleId = dict["vehicle_id"] as? String ?? ""
        dictResult.proposedVehicleCategory = dict["proposed_vehicle_category"] as? String ?? ""
        dictResult.deliveredBy = dict["delivered_by"] as? String ?? ""
        dictResult.deliveredByname = dict["delivered_byname"] as? String ?? ""
        dictResult.status = dict["Status"] as? String ?? ""
        
        dictResult.is_service_due = dict["is_service_due"] as? Int ?? 0
        dictResult.service_miles_left = dict["service_miles_left"] as? Int ?? 0
        dictResult.last_mileage = dict["last_mileage"] as? String ?? ""
        dictResult.nextserviceduekm = dict["nextserviceduekm"] as? String ?? ""
        dictResult.last_service_mileage = dict["last_service_mileage"] as? String ?? ""
    }
}

struct BookingDetailsModelData {
    var dateOut : String = ""
    var timeOut : String = ""
    var mileageOut : String = ""
    var fuelOut : String = ""
    var deliveryLocation : String = ""
    var expectedDeliveryDate : String = ""
    var expectedDeliveryTime : String = ""
    var proposedVehicle : String = ""
    var vehicleId : String = ""
    var proposedVehicleCategory : String = ""
    var deliveredBy : String = ""
    var deliveredByname : String = ""
    var status : String = ""
    
    
    var is_service_due: Int?
    var service_miles_left: Int?
    var last_mileage: String?
    var nextserviceduekm: String?
    var last_service_mileage: String?
}
