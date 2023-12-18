//
//  AtFaultDriverDetailsModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 24/08/21.
//

import Foundation
class AtFaultDriverDetailsModel : NSObject {
    var dictResult = AtFaultDriverDetailsModelData()
    init(dict : Dictionary<String, Any>) {
        dictResult.id = dict["id"] as? String ?? ""
        dictResult.firstName = dict["atfault_firstname"] as? String ?? ""
        dictResult.status = dict["status"] as? String ?? ""
        dictResult.lastName = dict["atfault_lastname"] as? String ?? ""
        dictResult.licenceNo = dict["atfault_lic_no"] as? String ?? ""
        dictResult.phoneNumber = dict["atfault_phone"] as? String ?? ""
        dictResult.dateOfBirth = dict["atfault_dob"] as? String ?? ""
        dictResult.makeModelOfVehicle = dict["atfault_make_model"] as? String ?? ""
        dictResult.registrationNo = dict["atfault_registration_no"] as? String ?? ""
        dictResult.claimNo = dict["atfault_claimno"] as? String ?? ""
        dictResult.repairerName = dict["repairer_name"] as? String ?? ""
        dictResult.insuranceCompany = dict["atfault_insurancecompany"] as? String ?? ""
        dictResult.insuranceCompanyId = dict["atfault_insurancecompanyid"] as? String ?? ""
        dictResult.street = dict["atfault_street"] as? String ?? ""
        dictResult.suburb = dict["atfault_suburb"] as? String ?? ""
        dictResult.state = dict["atfault_state"] as? String ?? ""
        dictResult.stateId = dict["atfault_stateid"] as? String ?? ""
        dictResult.postalCode = dict["atfault_postcode"] as? String ?? ""
        dictResult.country = dict["atfault_country"] as? String ?? ""
        dictResult.referralName = dict["referral_name"] as? String ?? ""
        dictResult.expectedDeliveryTime = dict["expected_delivery_time"] as? String ?? ""
        dictResult.deliveryLocation = dict["delivery_location"] as? String ?? ""
    }
}

struct AtFaultDriverDetailsModelData {
    var status : String = ""
    var id : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var licenceNo : String = ""
    var phoneNumber : String = ""
    var dateOfBirth : String = ""
    var makeModelOfVehicle : String = ""
    var registrationNo : String = ""
    var claimNo : String = ""
    var repairerName : String = ""
    var insuranceCompany : String = ""
    var insuranceCompanyId : String = ""
    var street : String = ""
    var suburb : String = ""
    var state : String = ""
    var stateId : String = ""
    var postalCode : String = ""
    var country : String = ""
    var referralName : String = ""
    var expectedDeliveryTime : String = ""
    var deliveryLocation : String = ""
}
