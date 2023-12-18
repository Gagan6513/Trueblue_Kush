//
//  HirerDetailsModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 02/09/21.
//

import Foundation
class HirerDetailsModel : NSObject {
    var dictResult = HirerDetailsModelData()
    init(dict : Dictionary<String, Any>) {
        dictResult.hirerFirstName = dict["hire_firstname"] as? String ?? ""
        dictResult.hirerLastName = dict["hire_lastname"] as? String ?? ""
        dictResult.email = dict["hire_email"] as? String ?? ""
        dictResult.phone = dict["hire_phone"] as? String ?? ""
        dictResult.licenceNumber = dict["hire_lic_no"] as? String ?? ""
        dictResult.expiryDate = dict["hire_exp"] as? String ?? ""
        dictResult.dateOfBirth = dict["hire_dob"] as? String ?? ""
        dictResult.streetAddress = dict["hire_street"] as? String ?? ""
        dictResult.suburb = dict["hire_suburb"] as? String ?? ""
        dictResult.state = dict["hire_state"] as? String ?? ""
        dictResult.stateId = dict["hire_stateid"] as? String ?? ""
        dictResult.postalCode = dict["hire_post_code"] as? String ?? ""
        dictResult.country = dict["hire_country"] as? String ?? ""
        
        //Previous Hirer Address
        dictResult.previousStreetAddress = dict["previous_street"] as? String ?? ""
        dictResult.previousSuburb = dict["previous_suburb"] as? String ?? ""
        dictResult.previousState = dict["previous_state"] as? String ?? ""
        dictResult.previousStateId = dict["previous_stateid"] as? String ?? ""
        dictResult.previousPostalCode = dict["previous_post_code"] as? String ?? ""
        dictResult.previousCountry = dict["previous_country"] as? String ?? ""
    }
}


struct HirerDetailsModelData {
    var hirerFirstName : String = ""
    var hirerLastName : String = ""
    var email : String = ""
    var phone : String = ""
    var licenceNumber : String = ""
    var expiryDate : String = ""
    var dateOfBirth : String = ""
    var streetAddress : String = ""
    var suburb : String = ""
    var state : String = ""
    var stateId : String = ""
    var postalCode : String = ""
    var country : String = ""
    
    //Address of previous Hirer
    var previousStreetAddress : String = ""
    var previousSuburb : String = ""
    var previousState : String = ""
    var previousStateId : String = ""
    var previousPostalCode : String = ""
    var previousCountry : String = ""
}
