//
//  DeliveredCollectedByModel.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 02/03/23.
//

import Foundation
class DeliveredCollectedByModel : NSObject {
    var arrResult = [DeliveredCollectedByModelData]()
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictArray = DeliveredCollectedByModelData()
                dictArray.id = dict["id"] as? String ?? ""
                dictArray.user_name = dict["user_name"] as? String ?? ""
                arrResult.append(dictArray)
            }
        }
    }
}
struct DeliveredCollectedByModelData {
    var id : String = ""
    var user_name : String = ""
}
