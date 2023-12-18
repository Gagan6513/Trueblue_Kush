//
//  StateListModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 23/08/21.
//

import Foundation
class StateListModel : NSObject {
    var arrResult = [StateListModelData]()
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictArray = StateListModelData()
                dictArray.stateId = dict["state_id"] as? String ?? ""
                dictArray.stateName = dict["state_name"] as? String ?? ""
                arrResult.append(dictArray)
            }
        }
    }
}


struct StateListModelData {
    var stateId : String = ""
    var stateName : String = ""
}
