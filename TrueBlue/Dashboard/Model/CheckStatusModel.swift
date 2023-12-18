//
//  CheckStatusModel.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 04/04/23.
//

import Foundation


class CheckStatusModel : NSObject {
    var dictResult = CheckStatusModelData()
    init(dict : Dictionary<String, Any>) {
        dictResult.userId = dict["user_id"] as? String ?? ""
        dictResult.profileStatus = dict["profile_status"] as? String ?? ""
            }
        }

struct CheckStatusModelData {
    var userId : String = ""
    var profileStatus : String = ""
    
}

