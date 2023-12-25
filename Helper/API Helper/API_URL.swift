//
//  API_URL.swift
//  RecertMe
//
//  Created by Kushkumar Katira on 26/07/23.
//

import Foundation

class API_URL {
    
    //static let baseURL = "http://172.200.221.113/app/"// staging
    static let baseURL = "https://www.mytbam.com.au/crm/app/"// prod
    static let getACAList = baseURL + "acaRequests"
    static let getUserList = "http://172.200.221.113/app/getUsersList"
    static let save_event = baseURL + "saveCalendarEvent"

}
