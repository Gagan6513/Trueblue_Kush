//
//  API_URL.swift
//  RecertMe
//
//  Created by Kushkumar Katira on 26/07/23.
//

import Foundation

class API_URL {
    
    static let getACAList = new_path + "acaRequests"
    static let getUserList = new_path + "getUsersList"
    static let save_event = new_path + "saveCalendarEvent"
    static let get_eventlist = new_path + "calDateEventsCount"
    static let get_event_details = new_path + "calDateEventsList"
    static let update_event = new_path + "saveCalendarEventStage"
    static let get_all_user = new_path + "getAllUsersData"
    static let force_logout_user = new_path + "setforceLogoutUser"
    static let logSheet = new_path + "getAllNotes"
    static let getReferenceList = new_path + "getReferenceList"
    
    static let UPLOAD_MULTIPLE_DOCS = API_PATH + "uploadmultiple_docs.php"
    static let SWAP_VEHICLE = new_path + "swapVehicle"
    
    static let AVAILABLE_VEHICLE_LIST = new_path + "getAvailableFleets"

}
