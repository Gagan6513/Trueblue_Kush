//
//  AccidentMaintenanceModel.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 22/01/24.
//

import Foundation

class AccidentMaintenanceModel: Codable {
    
    var data: AccidentMaintenanceData?
    var status: Int?
    var msg:String?
    var statusCode: Int?
    
}

class AccidentMaintenanceData: Codable {
    var response : [AccidentMaintenance]?
}

class AccidentMaintenance: Codable {
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
    var status_modified_on: String?
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
}




class AccidentReferanceModel: Codable {
    
    var data: AccidentReferanceData?
    var status: Int?
    var msg:String?
    var statusCode: Int?
    
}

class AccidentReferanceData: Codable {
    var response : [AccidentReferance]?
}

class AccidentReferance: Codable {
    let application_id : String?
    let app_id : String?
    let is_accident_ref : String?
    let accident_rego : String?
    let ourdriver_atfault : String?
    let excess : String?
    let excess_amount : String?
    let atfault_phone : String?
    let accident_location : String?
    let dateof_accident : String?
    let timeofaccident : String?
    let status : String?
    let owner_firstname : String?
    let owner_lastname : String?
    let atfault_firstname : String?
    let registration_no : String?
    let repairer_name : String?
    let date_out : String?
    let date_in : String?
    
}
