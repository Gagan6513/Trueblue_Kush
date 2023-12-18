//
//  FinalSubmitModel.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 02/03/23.
//

import Foundation

class FinalSubmitModel : NSObject {
    var dictResult = FinalSubmitModelData()
    init(dict : Dictionary<String, Any>) {
        dictResult.data = dict["url"] as? String ?? ""
            }
        }

struct FinalSubmitModelData {
    var data : String = ""
}
