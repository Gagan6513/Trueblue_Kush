//
//  LoginModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 18/08/21.
//

import Foundation
class LoginModel : NSObject {
    var dictLogin = LoginModelData()
    
    init(dict : Dictionary<String, Any>) {
        dictLogin.name = dict["name"] as? String ?? ""
        dictLogin.userType = dict["usertype"] as? String ?? ""
        dictLogin.groupId = dict["group_id"] as? String ?? ""
        dictLogin.userId = dict["id"] as? String ?? ""
        dictLogin.status = dict["status"] as? String ?? ""
        dictLogin.message = dict["msg"] as? String ?? ""
        }
}


struct LoginModelData {
    var name : String = ""
    var userType : String = ""
    var groupId : String = ""
    var userId : String = ""
    var status : String = ""
    var message : String = ""
}
