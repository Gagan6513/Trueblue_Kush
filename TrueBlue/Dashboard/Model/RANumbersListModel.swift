//
//  RANumbersListModel.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 19/04/23.
//

import Foundation

class RANumbersListModel : NSObject {
    var arrResult = [RANumbersListModelData]()
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                
                var dictArray = RANumbersListModelData()
                dictArray.raNumbersID = dict["id"] as? String ?? ""
                dictArray.applicationId = dict["application_id"] as? String ?? ""
                arrResult.append(dictArray)
            }
        }
    }
}
struct RANumbersListModelData {
    var raNumbersID : String = ""
    var applicationId : String = ""
}
