//
//  RepairersListModel.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 17/04/23.
//

import Foundation

class RepairersListModel : NSObject {
    var arrResult = [RepairersListModelData]()
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictArray = RepairersListModelData()
                dictArray.repairersID = dict["id"] as? String ?? ""
                dictArray.repairersName = dict["repairer_name"] as? String ?? ""
                arrResult.append(dictArray)
            }
        }
    }
}
struct RepairersListModelData {
    var repairersID : String = ""
    var repairersName : String = ""
}
