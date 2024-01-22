//
//  AvailableVehicleModel.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 18/01/24.
//

import Foundation

class AvailableVehicleModel: Codable {
    
    var data: [AvailableVehicle]?
    var status: Int?
    var msg:String?
    var statusCode: Int?
    
}

class AvailableVehicle: Codable {
    
    var id: String?
    var registration_state: String?
    var registration_no: String?
    var fleet_no: String?
    var engine_no: String?
    var chassis_no: String?
    var key_no: String?
    var vin: String?
    var transmission: String?
    var type: String?
    var basemilage_date: String?
    var basemilage: String?
    var purchase_from: String?
    var fuel_type: String?
    var radio_code: String?
    var yearof_purchase: String?
    var yearof_manufacture: String?
    var color: String?
    var vehicle_type: String?
    var vehicle_cat_id: String?
    var vehicle_make_id: String?
    var vehicle_model_id: String?
    var image_url: String?
    var ownedbycompany: String?
    var purchase_date: String?
    var dealer_name: String?
    var description: String?
    var status: String?
    var fleet_status: String?
    var created_date: String?
    var vehicle_types: String?
    var entry_type: String?
    var cron_status: String?
    var available_location: String?
    var available_date: String?
    var available_time: String?
    var available_status: String?
    var fleet_image: String?
    var vehicle_make: String?
    var vehicle_model: String?
    var vehicle_category: String?
    var status_modified_on: String?
    
}
