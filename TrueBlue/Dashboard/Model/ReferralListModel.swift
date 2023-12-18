//
//  ReferralListModel.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 16/03/23.
//

import Foundation

class ReferralListModel : NSObject {
    var arrResult = [ReferralListModelData]()
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictArray = ReferralListModelData()
                dictArray.referralId = dict["ref_id"] as? String ?? ""
                dictArray.referralName = dict["referral_name"] as? String ?? ""
                arrResult.append(dictArray)
            }
        }
    }
}


struct ReferralListModelData {
    var referralId : String = ""
    var referralName : String = ""
}
