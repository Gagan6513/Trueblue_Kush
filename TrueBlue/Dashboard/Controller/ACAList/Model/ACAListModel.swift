//
//  ACAListModel.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 22/12/23.
//

import Foundation

class ACAListModel: Codable {
    
    var data: ACAData?
    var status: Int?
    var msg:String?
    var statusCode: Int?
    
}

class ACAData: Codable {
    
    var response: [ACAList]?
    var total_records: Int?
    
}

class ACAList: Codable {
    
    var ACA_ID: String?
    var AGENT_NAME: String?
    var application_id: String?
    var app_id: String?
    var CREATED_ON: String?
    var ID: String?
    var Q_CONTACT_NUMBER: String?
    var Q_OTHER_DRIVER_MOBILE: String?
    var Q_OTHER_DRIVER_NAME: String?
    var Q_USERNAME: String?
    var STAGE: String?
    
}
