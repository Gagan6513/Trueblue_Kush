//
//  RegoNumberListModel.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 17/04/23.
//

import Foundation

class RegoNumberListModel : NSObject {
    var arrResult = [RegoNumberListModelData]()
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictArray = RegoNumberListModelData()
                dictArray.regoNoID = dict["id"] as? String ?? ""
                dictArray.registrationNo = dict["registration_no"] as? String ?? ""
                arrResult.append(dictArray)
            }
        }
    }
}
struct RegoNumberListModelData {
    var regoNoID : String = ""
    var registrationNo : String = ""
}
