//
//  GetAccidentDetailsModel.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 28/04/23.
//

import Foundation

class GetAccidentDetailsModel : NSObject {
    var accidentDetails : GetAccidentDetailsModelData?
    init(dict : Dictionary<String, Any>) {
        if let data = dict["response"] as? Dictionary<String, Any> {
            accidentDetails =  getParsedAccidentDetailsModel(dict: data)
        }
        func getParsedAccidentDetailsModel(dict: Dictionary<String,Any>) -> GetAccidentDetailsModelData {
            var dictArray = GetAccidentDetailsModelData()
            
            dictArray.applicationId = dict["application_id"] as? String ?? ""
            dictArray.ownerPhone = dict["owner_phone"] as? String ?? ""
            dictArray.ownerEmail = dict["owner_email"] as? String ?? ""
            dictArray.ownerFirstname = dict["owner_firstname"] as? String ?? ""
            dictArray.proposedVehicle = dict["proposed_vehicle"] as? String ?? ""
            dictArray.registrationNo = dict["registration_no"] as? String ?? ""
            return dictArray
        }
    }
}
struct GetAccidentDetailsModelData {
    var applicationId : String?
    var ownerPhone : String?
    var ownerEmail : String?
    var ownerFirstname : String?
    var proposedVehicle : String?
    var registrationNo : String?
}

