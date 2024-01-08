//
//  NotAtFaultDriverDetailsModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 24/08/21.
//

import Foundation
class NotAtFaultDriverDetailsModel : NSObject {
    var dictResult = NotAtFaultDriverDetailsModelData()
    init(dict : Dictionary<String, Any>) {
        dictResult.id = dict["id"] as? String ?? ""
        dictResult.firstName = dict["owner_firstname"] as? String ?? ""
        dictResult.lic = dict["owner_lic"] as? String ?? ""
        dictResult.licenceExpiry = dict["lincense_exp"] as? String ?? ""
        dictResult.email = dict["owner_email"] as? String ?? ""
        dictResult.phone = dict["owner_phone"] as? String ?? ""
        dictResult.dateOfBirth = dict["owner_dob"] as? String ?? ""
        dictResult.street = dict["owner_street"] as? String ?? ""
        dictResult.suburb = dict["owner_suburb"] as? String ?? ""
        dictResult.state = dict["owner_state"] as? String ?? ""
        dictResult.stateId = dict["state_id"] as? String ?? ""
        dictResult.postalCode = dict["owner_postcode"] as? String ?? ""
        dictResult.country = dict["owner_country"] as? String ?? ""
        dictResult.makeModel = dict["owner_make_model"] as? String ?? ""
        dictResult.registrationNo = dict["owner_registration_no"] as? String ?? ""
        dictResult.insuranceCompanyName = dict["insurance_company"] as? String ?? ""
        dictResult.insuranceCompanyId = dict["insurance_id"] as? String ?? ""
        dictResult.dateOfAccident = dict["dateof_accident"] as? String ?? ""
        dictResult.timeOfAccident = dict["timeofaccident"] as? String ?? ""
        dictResult.accidentLocation = dict["accident_location"] as? String ?? ""
        dictResult.claimNo = dict["owner_claimno"] as? String ?? ""
        dictResult.isBusinessRegistered = dict["is_business_registered"] as? String ?? ""
        dictResult.proposedVehicle = dict["proposed_vehicle"] as? String ?? ""
        dictResult.proposedVehicleCategory = dict["proposed_vehicle_category"] as? String ?? ""
        dictResult.proposedVehicleId = dict["vehicle_id"] as? String ?? ""
        dictResult.bookingType = dict["booking_type"] as? String ?? ""
        dictResult.expectedDeliveryDate = dict["expected_delivery_date"] as? String ?? ""
        dictResult.referralName = dict["referral_name"] as? String ?? ""
        dictResult.repairerName = dict["repairer_name"] as? String ?? ""
        dictResult.repairerId = dict["repairer_id"] as? String ?? ""
        dictResult.referralId = dict["ref_id"] as? String ?? ""
        dictResult.expectedDeliveryTime = dict["expected_delivery_time"] as? String ?? ""
        dictResult.dropLocation = dict["drop_location"] as? String ?? ""
        dictResult.deliveredBy = dict["delivered_by"] as? String ?? ""
        dictResult.accidentDescription = dict["description"] as? String ?? ""
        dictResult.branchName = dict["branch_name"] as? String ?? ""
        dictResult.branchId = dict["branch_id"] as? String ?? ""
        dictResult.recoveryFor = dict["recoveryFor"] as? String ?? ""
        
    }
}


struct NotAtFaultDriverDetailsModelData {
    var id : String = ""
    var firstName : String = ""
    var lic : String = ""
    var licenceExpiry : String = ""
    var email : String = ""
    var phone : String = ""
    var dateOfBirth : String = ""
    var street : String = ""
    var suburb : String = ""
    var state : String = ""
    var stateId : String = ""
    var postalCode : String = ""
    var country : String = ""
    var makeModel : String = ""
    var registrationNo : String = ""
    var insuranceCompanyName : String = ""
    var insuranceCompanyId : String = ""
    var dateOfAccident : String = ""
    var timeOfAccident : String = ""
    var accidentLocation : String = ""
    var claimNo : String = ""
    var isBusinessRegistered : String = ""
    var proposedVehicle : String = ""
    var proposedVehicleCategory : String = ""
    var bookingType : String = ""
    var expectedDeliveryDate : String = ""
    var referralName : String = ""
    var repairerName : String = ""
    var expectedDeliveryTime : String = ""
    var dropLocation : String = ""
    var deliveredBy : String = ""
    var referralId : String = ""
    var repairerId : String = ""
    var proposedVehicleId : String = ""
    var accidentDescription : String = ""
    var branchName : String = ""
    var branchId : String = ""
    var recoveryFor : String = ""
}


