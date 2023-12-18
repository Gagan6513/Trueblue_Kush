//
//  SearchDashboardModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 31/08/21.
//

import Foundation
class SearchDashboardModel : NSObject {
    var arrResult = [SearchDashboardModelData]()
    var vehicleDetails = [VehiclesDetailsModelData]()
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictArray = SearchDashboardModelData()
                dictArray.searchResult = dict["search"] as? String ?? ""
                dictArray.isSwapped = dict["is_swapped"] as? String ?? ""
                dictArray.vehicleId = dict["vehicle_id"] as? String ?? ""
                dictArray.registrationNo = dict["registration_no"] as? String ?? ""
                dictArray.dateIn = dict["date_in"] as? String ?? ""
                dictArray.dateOut = dict["date_out"] as? String ?? ""
                dictArray.content = dict["content"] as? String ?? ""
                //dictArray.
                arrResult.append(dictArray)
            }
        }
        if let arr = dict["vehicles"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictVehiclesDetails = VehiclesDetailsModelData()
                dictVehiclesDetails.vehicleId = dict["vehicle_id"] as? String ?? ""
                dictVehiclesDetails.registrationNo = dict["registration_no"] as? String ?? ""
                dictVehiclesDetails.dateIn = dict["date_in"] as? String ?? ""
                dictVehiclesDetails.dateOut = dict["date_out"] as? String ?? ""
                dictVehiclesDetails.content = dict["content"] as? String ?? ""
                vehicleDetails.append(dictVehiclesDetails)
            }
        }
    }
}


struct SearchDashboardModelData {
    var searchResult : String = ""
    var isSwapped : String = ""
    var vehicleId : String = ""
    var registrationNo : String = ""
    var dateIn : String = ""
    var dateOut : String = ""
    var content : String = ""
}
struct VehiclesDetailsModelData {
    var vehicleId : String = ""
    var registrationNo : String = ""
    var dateIn : String = ""
    var dateOut : String = ""
    var content : String = ""
}
