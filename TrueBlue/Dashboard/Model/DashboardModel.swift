//
//  DashboardModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 28/08/21.
//

import Foundation
class DashboardModel : NSObject {
    var dictResult = DashboardModelData()
    init(dict : Dictionary<String, Any>) {
        print(dict)
        dictResult.numOfAvailableVehicle = dict["Availablecount"] as? String ?? ""
        dictResult.numOfHiredVehicle = dict["Hiredcount"] as? String ?? ""
        dictResult.numOfTodayDeliveries = dict["todaydeliverycount"] as? String ?? ""
        dictResult.numOfCollections = dict["collectiondcount"] as? String ?? ""
        dictResult.todayDeliveryNotes = dict["today_delivery_notes"] as? String ?? ""
        dictResult.todayCollectionNotes = dict["today_collection_notes"] as? String ?? ""
        dictResult.upcomingbookingcount = dict["upcomingbookingcount"] as? String ?? ""
        dictResult.repairerbookingcount = dict["repairerbookingcount"] as? String ?? ""
    }
}


struct DashboardModelData {
    var numOfAvailableVehicle : String = ""
    var numOfHiredVehicle : String = ""
    var numOfTodayDeliveries : String = ""
    var numOfCollections : String = ""
    var todayDeliveryNotes : String = ""
    var todayCollectionNotes : String = ""
    var upcomingbookingcount : String = ""
    var repairerbookingcount : String = ""
    
}
