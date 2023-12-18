//
//  ReturnVehicleModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 20/08/21.
//

import Foundation
class ReturnVehicleModel : NSObject {
    var dictResult = ReturnVehicleModelData()
    
    init(dict : Dictionary<String, Any>) {
        dictResult.name = dict["name"] as? String ?? ""
        dictResult.userType = dict["usertype"] as? String ?? ""
        dictResult.groupId = dict["group_id"] as? String ?? ""
        dictResult.id = dict["id"] as? String ?? ""
        dictResult.status = dict["status"] as? String ?? ""
        dictResult.message = dict["msg"] as? String ?? ""
        }
}


struct ReturnVehicleModelData {
    var name : String = ""
    var userType : String = ""
    var groupId : String = ""
    var id : String = ""
    var status : String = ""
    var message : String = ""
}
