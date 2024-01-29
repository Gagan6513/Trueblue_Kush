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

    static let accidentManagementFirst = new_path + "saveAccidentForm"

    static let BRANCH_LIST = new_path + "branchList"
    static let getReferenceDetails = new_path + "getReferenceDetails"

    static let INSURANCE_COMPANY_LIST = API_PATH + "insurance_list.php"
    static let REPAIRER_LIST = API_PATH + "repairer_list.php"
    static let REFERRAL_LIST = API_PATH + "referal_list.php"
    static let getAllNotes = new_path + "getAllNotes"
    static let saveNotes = new_path + "saveNotes"

    static let stateList = new_path + "stateList"
    static let getAllFleets = new_path + "getAllFleets"
    static let getReferenceList = new_path + "getReferenceList"
    
    static let UPLOAD_MULTIPLE_DOCS = API_PATH + "uploadmultiple_docs.php"
    static let DELETE_UPLOADED_DOCUMENT = API_PATH + "deleteuploadeddoc.php"

    static let GET_UPLOADED_DOCUMENTS_TAB_DETAILS = API_PATH + "getuploaddocuments2.php"//"getuploaddocuments.php"

    static let SWAP_VEHICLE = new_path + "swapVehicle"
    
    static let AVAILABLE_VEHICLE_LIST = new_path + "getAvailableFleets"
    
    static let accidentMaintenanceFirst = new_path + "getFleetsList"
    static let getFleetsList = new_path + "getFleetsList"
    static let getRegoServiceHistory = new_path + "getRegoServiceHistory"
    static let accidentBookings = new_path + "accidentBookings"
    static let getRegoBookings = new_path + "getRegoBookings"

}
