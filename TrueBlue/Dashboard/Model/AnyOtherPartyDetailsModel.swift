//
//  AnyOtherPartyDetailsModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 25/08/21.
//

import Foundation
import Foundation
class AnyOtherPartyDetailsModel : NSObject {
    var dictResult = AnyOtherPartyDetailsModelData()
    init(dict : Dictionary<String, Any>) {
        dictResult.id = dict["id"] as? String ?? ""
        dictResult.firstName = dict["party_firstname"] as? String ?? ""
        dictResult.lastName = dict["party_lastname"] as? String ?? ""
        dictResult.licenceNo = dict["party_lic_no"] as? String ?? ""
        dictResult.phoneNumber = dict["party_phone"] as? String ?? ""
        dictResult.witnessName = dict["party_witness_name"] as? String ?? ""
        dictResult.witnessPhoneNumber = dict["witness_phone"] as? String ?? ""
        dictResult.dateOfBirth = dict["party_dob"] as? String ?? ""
        dictResult.makeModelOfVehicle = dict["party_make_model"] as? String ?? ""
        dictResult.claimNo = dict["party_claim_no"] as? String ?? ""
        dictResult.insuranceCompanyName = dict["party_insurance"] as? String ?? ""
        dictResult.insuranceCompanyId = dict["party_insuranceid"] as? String ?? ""
        dictResult.street = dict["party_street"] as? String ?? ""
        dictResult.suburb = dict["party_suburb"] as? String ?? ""
        dictResult.postalCode = dict["party_postcode"] as? String ?? ""
        dictResult.country = dict["party_country"] as? String ?? ""
        dictResult.state = dict["party_state"] as? String ?? ""
        dictResult.stateId = dict["party_stateid"] as? String ?? ""
        dictResult.registrationNumber = dict["party_registration_no"] as? String ?? ""
    }
}

struct AnyOtherPartyDetailsModelData {
    var id : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var licenceNo : String = ""
    var phoneNumber : String = ""
    var witnessName : String = ""
    var witnessPhoneNumber : String = ""
    var dateOfBirth : String = ""
    var makeModelOfVehicle : String = ""
    var claimNo : String = ""
    var insuranceCompanyName : String = ""
    var insuranceCompanyId : String = ""
    var street : String = ""
    var suburb : String = ""
    var state : String = ""
    var stateId : String = ""
    var postalCode : String = ""
    var country : String = ""
    var registrationNumber : String = ""
}
