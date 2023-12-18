//
//  AvailVehicleListModel.swift
//  TrueBlue
//
//  Created by Ashwani Kumar on 30/08/21.
//

import Foundation
class AvailVehicleListModel : NSObject {
    var arrResult = [AvailVehicleListModelData]()
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictArray = AvailVehicleListModelData()
                dictArray.category = dict["category"] as? String ?? ""
                dictArray.id = dict["id"] as? String ?? ""
                dictArray.make = dict["make"] as? String ?? ""
                dictArray.registration_no = dict["registration_no"] as? String ?? ""
                dictArray.model = dict["model"] as? String ?? ""
                arrResult.append(dictArray)
            }
        }
    }
}


struct AvailVehicleListModelData {

    var category : String = ""
    var id : String = ""
    var make : String = ""
    var registration_no : String = ""
    var model : String = ""
    
}
