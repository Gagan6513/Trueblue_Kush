//
//  UserListModel.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 25/12/23.
//

import Foundation

class UserModel: Codable {
    
    var data: UserModelResponse?
    var status: Int?
    var msg:String?
    var statusCode: Int?
    
}

class UserModelResponse: Codable {
    
    var response: [UserList]?
    
}

class UserList: Codable {
    
    var id: String?
    var name: String?
    
}
