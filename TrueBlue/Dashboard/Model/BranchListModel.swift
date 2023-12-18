//
//  BranchListModel.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 15/04/23.
//

import Foundation

class BranchListModel : NSObject {
    var arrResult = [BranchListModelData]()
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictArray = BranchListModelData()
                dictArray.branchID = dict["branch_id "] as? String ?? ""
                dictArray.branchName = dict["branch_name"] as? String ?? ""
                arrResult.append(dictArray)
            }
        }
    }
}
struct BranchListModelData {
    var branchID : String = ""
    var branchName : String = ""
}
