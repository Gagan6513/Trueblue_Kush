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
    var total_records: CounsForFleet?
}

class CounsForFleet: Codable {
    
    var total_count: String?
    var available_count: String?
    var hired_count: String?
    var maintenance_count: String?
}

class AccidentDetailsModel: Codable {
    
    var data: AccidentDeailsData?
    var status: Int?
    var msg:String?
    var statusCode: Int?
    
}

class AccidentDeailsData: Codable {
    var response : AccidentDetailsResponse?
}

class AccidentDetailsResponse: Codable {
    let id : String?
        let aca_id : String?
        let ref_lead_id : String?
        let associate_id : String?
        let parent_id : String?
        let ourdriver_atfault : String?
        let excess : String?
        let excess_amount : String?
        let is_accident_ref : String?
        let accident_rego : String?
        let recovery_for : String?
        let branch : String?
        let application_id : String?
        let vehicle_drivable : String?
        let owner_firstname : String?
        let owner_email : String?
        let owner_phone : String?
        let owner_street : String?
        let owner_claimno : String?
        let owner_make_model : String?
        let owner_registration_no : String?
        let other_reason : String?
        let insurance : String?
        let dateof_accident : String?
        let timeofaccident : String?
        let accident_location : String?
        let image_url : String?
        let description : String?
        let atfault_firstname : String?
        let atfault_lic_no : String?
        let atfault_phone : String?
        let atfault_dob : String?
        let atfault_street : String?
        let atfault_make_model : String?
        let atfault_registration_no : String?
        let atfault_insurancecompany : String?
        let atfault_claimno : String?
        let party_firstname : String?
        let party_lic_no : String?
        let party_dob : String?
        let party_street : String?
        let party_make_model : String?
        let party_registration_no : String?
        let party_phone : String?
        let party_insurance : String?
        let party_claim_no : String?
        let party_witness_name : String?
        let witness_phone : String?
        let noof_days : String?
        let proposed_vehicle_category : String?
        let proposed_vehicle : String?
        let description_abouthire : String?
        let created_date : String?
        let status : String?
        let is_business_registered : String?
        let do_youpayhire_cost : String?
        let youneed_vehicle : String?
        let public_needs : String?
        let kids_pick_drop : String?
        let road_worthly : String?
        let condition_ofemployment : String?
        let unable_toborrow_family : String?
        let dueto_medical_condition : String?
        let application_date : String?
        let owner_lastname : String?
        let atfault_lastname : String?
        let party_lastname : String?
        let party_mobile : String?
        let atfault_mobile : String?
        let owner_mobile : String?
        let owner_suburb : String?
        let owner_state : String?
        let owner_country : String?
        let atfault_suburb : String?
        let atfault_state : String?
        let atfault_country : String?
        let party_suburb : String?
        let party_state : String?
        let party_country : String?
        let party_postcode : String?
        let atfault_postcode : String?
        let owner_postcode : String?
        let hire2_firstname : String?
        let hire2_lastname : String?
        let hire2_lic_no : String?
        let hire2_exp : String?
        let hire2_street : String?
        let hire2_post_code : String?
        let hire2_phone : String?
        let hire2_email : String?
        let hire2_dob : String?
        let hire2_mobile : String?
        let hire2_suburb : String?
        let hire2_state : String?
        let hire2_country : String?
        let search_field : String?
        let repairer_name : String?
        let referral_name : String?
        let expected_delivery_date : String?
        let expected_delivery_time : String?
        let delivery_location : String?
        let owner_lic : String?
        let ownerlic_exp : String?
        let owner_dob : String?
        let booking_type : String?
        let recovery_status : String?
        let image_url1 : String?
        let image_url2 : String?
        let image_url3 : String?
        let image_url4 : String?
        let image_url5 : String?
        let notes : String?
        let login_id : String?
        let entry_type : String?
        let privatehire_address : String?
        let hire_type : String?
        let liabilityissue : String?
        let isinvoiced : String?
        let hire3_firstname : String?
        let hire3_lastname : String?
        let hire3_email : String?
        let hire3_phone : String?
        let hire3_lic_no : String?
        let hire3_exp : String?
        let hire3_dob : String?
        let hire3_street : String?
        let hire3_suburb : String?
        let hire3_state : String?
        let hire3_post_code : String?
        let hire3_country : String?
        let atfault_exp : String?
        let delivered_by : String?
        let cardholder_name : String?
        let card_type : String?
        let card_no : String?
        let expiry_date : String?
        let cvv : String?
        let cardholder_name2 : String?
        let exp_date2 : String?
        let card_type2 : String?
        let card_no2 : String?
        let cvv2 : String?
        let entry_from : String?
        let liability_status : String?
        let is_swapped : String?
        let clientregoowerlicense : String?
        let hirer2license : String?
        let hirer3license : String?
        let rego_paper : String?
        let atfault_driverlicense : String?
        let accident_pictuers : String?
        let anyother_pictures : String?
        let updated_at : String?
        let repairer_id : String?
        let state : String?
        let insurance_company : String?
        let atfault_insurance_company : String?
        let registration_no: String?
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
    var fleet_image: [String]?
    var vehicle_make: String?
    var vehicle_model: String?
    var vehicle_category: String?
    
    var is_service_due: Int?
    var service_miles_left: Int?
    var last_mileage: String?
    var nextserviceduekm: String?
    var last_service_mileage: String?
    
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
    let owner_phone: String?
    let atfault_claimno: String?
    
}


class AccidentServiceModel: Codable {
    
    var data: AccidentServiceData?
    var status: Int?
    var msg:String?
    var statusCode: Int?
    
}

class AccidentServiceData: Codable {
    var response : [AccidentService]?
}

class AccidentService: Codable {
    let amount_paid : String?
    let amount_paid_date : String?
    let created_date : String?
    let id : String?
    let invoice_number : String?
    let model_id : String?
    let nextserviceduekm : String?
    let Notes : String?
    let repairer_id : String?
    let repairer_name : String?
    let service_date : String?
    let service_mileage : String?
    let service_slip : String?
    let vehicle_id : String?
    let vehicle_make : String?
    let vehicle_model : String?
    let last_service_mileage : String?
    let last_service_date : String?
    let registration_no : String?
    let service_slip1 : String?
    let service_slip2 : String?
    let service_slip3 : String?
    let service_slip4 : String?
    
}

class AccidentServiceDetailsModel: Codable {
    
    var data: AccidentServiceDetailsData?
    var status: Int?
    var msg:String?
    var statusCode: Int?
    
}

class AccidentServiceDetailsData: Codable {
    var response : AccidentService?
}


class LastServiceDetailsModel: Codable {
    
    var data: AccidentServiceDataData?
    var status: Int?
    var msg:String?
    var statusCode: Int?
    
}

class AccidentServiceDataData: Codable {
    var response : LastAccidentServiceData?
}

class LastAccidentServiceData: Codable {
    var last_service_date : String?
    var last_service_mileage : String?
    var repairer_name : String?
}

class CollectionDeliveryModel: Codable {
    
    var data: [CollectionDeliveryDataList]?
    var status: Int?
    var msg:String?
    var statusCode: Int?
    
}

class CollectionDeliveryDataList: Codable {
    
    var application_id: String?
    var app_id: String?
    var collection_by: String?
    var delivered_by: String?
    var delivered_at: String?
    var referral_name: String?
    var collected_at: String?
    var date_in: String?
    var date_out: String?
    var is_swapped: String?
    var owner_firstname: String?
    var owner_lastname: String?
    var owner_phone: String?
    var registration_no: String?
    var status: String?
    var booking_status: String?
    var vehicle_id: String?
    
    var vehicle_make: String?
    var vehicle_model: String?
    var yearof_manufacture: String?
    var vehicle_category: String?
    var fleet_image: [String]?
    
    var is_service_due: Int?
    var service_miles_left: Int?
    var last_mileage: String?
    var nextserviceduekm: String?
    var last_service_mileage: String?
    
}
