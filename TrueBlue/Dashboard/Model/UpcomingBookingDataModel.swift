//
//  UpcomingBookingDataModel.swift
//  TrueBlue
//
//  Created by Inexture Solutions LLP on 17/11/23.
//

import Foundation

class UpcomingBookingDataModel : NSObject {
    var arrResult = [UpcomingBookingData]()
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictArray = UpcomingBookingData()
                dictArray.id = "\(dict["id"] as? Int ?? 0)"
                dictArray.application_id = dict["application_id"] as? String ?? ""
                dictArray.proposed_vehicle = dict["proposed_vehicle"] as? String ?? ""
                dictArray.registration_no = dict["registration_no"] as? String ?? ""
                dictArray.status = dict["status"] as? String ?? ""
                dictArray.vehicle_make = dict["vehicle_make"] as? String ?? ""
                dictArray.vehicle_model = dict["vehicle_model"] as? String ?? ""
                
                
                dictArray.app_id = dict["app_id"] as? String ?? ""
                dictArray.associate_name = dict["associate_name"] as? String ?? ""
                dictArray.atfault_claimno = dict["atfault_claimno"] as? String ?? ""
                dictArray.atfault_firstname = dict["atfault_firstname"] as? String ?? ""
                dictArray.atfault_insurancecompany = dict["atfault_insurancecompany"] as? String ?? ""
                dictArray.atfault_lic_no = dict["atfault_lic_no"] as? String ?? ""
                dictArray.atfault_phone = dict["atfault_phone"] as? String ?? ""
                dictArray.atfault_registration_no = dict["atfault_registration_no"] as? String ?? ""
                dictArray.clientregoowerlicense = dict["clientregoowerlicense"] as? String ?? ""
                dictArray.expected_delivery_date = dict["expected_delivery_date"] as? String ?? ""
                dictArray.hire2_firstname = dict["hire2_firstname"] as? String ?? ""
                dictArray.hire2_lic_no = dict["hire2_lic_no"] as? String ?? ""
                dictArray.liability_status = dict["liability_status"] as? String ?? ""
                dictArray.owner_firstname = dict["owner_firstname"] as? String ?? ""
                dictArray.owner_lastname = dict["owner_lastname"] as? String ?? ""
                dictArray.owner_lic = dict["owner_lic"] as? String ?? ""
                dictArray.owner_phone = dict["owner_phone"] as? String ?? ""
                dictArray.owner_registration_no = dict["owner_registration_no"] as? String ?? ""
                dictArray.referral_name = dict["referral_name"] as? String ?? ""
                dictArray.repairer_name = dict["repairer_name"] as? String ?? ""
                dictArray.owner_lic = dict["owner_lic"] as? String ?? ""
                dictArray.owner_phone = dict["owner_phone"] as? String ?? ""
                dictArray.owner_registration_no = dict["owner_registration_no"] as? String ?? ""
                arrResult.append(dictArray)
            }
        }
    }
}

struct UpcomingBookingData {
    
    var app_id:String = ""
    var application_id:String = ""
    var associate_name:String = ""
    var atfault_claimno:String = ""
    var atfault_firstname:String = ""
    var atfault_insurancecompany:String = ""
    var insurance_company:String = ""
    var atfault_lic_no:String = ""
    var atfault_phone:String = ""
    var atfault_registration_no:String = ""
    var clientregoowerlicense:String = ""
    var expected_delivery_date:String = ""
    var hire2_firstname:String = ""
    var hire2_lic_no:String = ""
    var id:String = "";
    var liability_status:String = ""
    var owner_firstname:String = ""
    var owner_lastname:String = ""
    var owner_lic:String = ""
    var owner_phone:String = ""
    var owner_registration_no:String = ""
    var proposed_vehicle:String = ""
    var referral_name:String = ""
    var registration_no:String = ""
    var repairer_name:String = ""
    var status:String = ""
    var vehicle_make:String = ""
    var vehicle_model:String = ""
}

