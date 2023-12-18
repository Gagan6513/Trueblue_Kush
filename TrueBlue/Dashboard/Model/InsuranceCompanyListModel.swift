//
//  InsuranceCompanyListModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 23/08/21.
//

import Foundation
class InsuranceCompanyListModel : NSObject {
    var arrResult = [InsuranceCompanyListModelData]()
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictArray = InsuranceCompanyListModelData()
                dictArray.insuranceCompanyId = dict["ins_id"] as? String ?? ""
                dictArray.insuranceCompanyName = dict["insurance_company"] as? String ?? ""
                arrResult.append(dictArray)
            }
        }
    }
}


struct InsuranceCompanyListModelData {
    var insuranceCompanyId : String = ""
    var insuranceCompanyName : String = ""
}
