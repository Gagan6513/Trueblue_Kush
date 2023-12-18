//
//  CollectionsModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 20/08/21.
//

import Foundation
class CollectionsModel : NSObject {
    var arrResult = [CollectionsModelData]()
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictArray = CollectionsModelData()
                dictArray.id = dict["id"] as? String ?? ""
                dictArray.applicationId = dict["application_id"] as? String ?? ""
                dictArray.clientName = dict["name"] as? String ?? ""
                dictArray.clientRago = dict["client_rago"] as? String ?? ""
                dictArray.vehicleId = dict["vehicle_id"] as? String ?? ""
                dictArray.vehicle = dict["vehicle"] as? String ?? ""
                dictArray.dateOut = dict["date_out"] as? String ?? ""
                dictArray.timeOut = dict["time_out"] as? String ?? ""
                dictArray.collectionDate = dict["collection_date"] as? String ?? ""
                dictArray.mileageOut = dict["Mileage_out"] as? String ?? ""
                dictArray.fuelOut = dict["fuel_out"] as? String ?? ""
                dictArray.imageUrlOne = dict["image_url1"] as? String ?? ""
                dictArray.imageUrlTwo = dict["image_url2"] as? String ?? ""
                dictArray.imageUrlThree = dict["image_url3"] as? String ?? ""
                dictArray.imageUrlFour = dict["image_url4"] as? String ?? ""
                dictArray.imageUrl = dict["image_url"] as? String ?? ""
                dictArray.expectedDeliveryDate = dict["expected_delivery_date"] as? String ?? ""
                dictArray.dateIn = dict["date_in"] as? String ?? ""
                dictArray.repairerName = dict["repairer_name"] as? String ?? ""
                arrResult.append(dictArray)
            }
        }
    }
}

struct CollectionsModelData {
    var id : String = ""
    var applicationId : String = ""
    var clientName : String = ""
    var clientRago : String = ""
    var vehicleId : String = ""
    var vehicle : String = ""
    var dateOut : String = ""
    var timeOut : String = ""
    var collectionDate : String = ""
    var mileageOut : String = ""
    var fuelOut : String = ""
    var imageUrlOne : String = ""
    var imageUrlTwo : String = ""
    var imageUrlThree : String = ""
    var imageUrlFour : String = ""
    var imageUrl : String = ""
    var expectedDeliveryDate : String = ""
    var dateIn : String = ""
    var repairerName : String = ""
}


