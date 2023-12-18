//
//  ReferralsListModel.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 17/04/23.
//

import Foundation

class ReferralsListModel : NSObject {
    var arrResult = [ReferralsListModelData]()
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictArray = ReferralsListModelData()
                dictArray.referralsID = dict["id"] as? String ?? ""
                dictArray.referralsName = dict["referral_name"] as? String ?? ""
                arrResult.append(dictArray)
            }
        }
    }
}
struct ReferralsListModelData {
    var referralsID : String = ""
    var referralsName : String = ""
}
