//
//  NewReferenceIdModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 24/08/21.
//

import Foundation
class NewReferenceIdModel : NSObject {
    var dictResult = NewReferenceIdModelData()
    init(dict : Dictionary<String, Any>) {
        if let data = dict["response"] as? Dictionary<String, Any> {
            dictResult.id = data["application_id"] as? String ?? ""
            dictResult.appid = data["application_id"] as? String ?? ""
        }
    }
}


struct NewReferenceIdModelData {
    var id : String = ""
    var appid : String = ""
}
