//
//  AllUserModel.swift
//  TrueBlue
//
//  Created by Kushkumar Katira iMac on 04/01/24.
//

import Foundation

class AllUserModel: Codable {
    var data: ResponseUserData?
    var status: Int?
    var msg:String?
    var statusCode: Int?
}

class ResponseUserData: Codable {
    var response: [AllUserListData]?
}

class AllUserListData: Codable {
    
    var id: String?
    var group_id: String?
    var name: String?
    var username: String?
    var password: String?
    var user_type: String?
    var login_id: String?
    var status: String?
    var created_date: String?
    var LOGOUT_ID: String?
    var group_name: String?
    
}
