//
//  EventDetailsModel.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 28/12/23.
//

import Foundation

class EventDetailsModel: Codable {
    
    var data: EventDetailsData?
    var status: Int?
    var msg:String?
    var statusCode: Int?
    
}

class EventDetailsData: Codable {
    
    var dayEvents: [Events]?
    var hourEvents: [HourEvents]?
}

class HourEvents: Codable {
    
    var title: String?
    var events: [Events]?
    
}

class Events: Codable {
    
    var ID: String?
    var EVENT_TYPE: String?
    var EVENT_DATE: String?
    var EVENT_TIME: String?
    var EVENT_DESC: String?
    var IS_DAILY_BASE: String?
    var APPLICATION_ID: String?
    var APP_ID: String?
    var ASSIGNED_TO: String?
    var STAGE: String?
    var CREATED_BY: String?
    var ASSIGNED_BY_USER: String?
    var ASSIGNED_TO_USER: String?
    var REMARKS: String?
    
}
