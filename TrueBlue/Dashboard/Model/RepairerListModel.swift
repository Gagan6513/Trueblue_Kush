//
//  RepairerListModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 25/08/21.
//

import Foundation
class RepairerListModel : NSObject {
    var arrResult = [RepairerListModelData]()
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictArray = RepairerListModelData()
                dictArray.repairerId = dict["rep_id"] as? String ?? ""
                dictArray.repairerName = dict["repairer_name"] as? String ?? ""
                arrResult.append(dictArray)
            }
        }
    }
}


struct RepairerListModelData {
    var repairerId : String = ""
    var repairerName : String = ""
}
