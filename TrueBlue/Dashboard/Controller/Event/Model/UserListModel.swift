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

class EventDataModel: Codable {
    
    var data: [EventList]?
    var status: Int?
    var msg:String?
    var statusCode: Int?
    
}


class EventList: Codable {
    
    var TOTAL_EVENT: String?
    var PENDING_EVENT: String?
    var EVENT_DATE: String?
    var COLLECTION_NOTES: String?
    var DELIVERY_NOTES: String?
    var TODO_TASK: String?
}


class ReferenceModel: Codable {
    
    var data: ReferenceDataModel?
    var status: Int?
    var msg:String?
    var statusCode: Int?
    
}

class ReferenceDataModel: Codable {
    
    var response: [ReferenceResponseModel]?
    
}

class ReferenceResponseModel: Codable {
    
    var id: String?
    var application_id: String?
    
}
