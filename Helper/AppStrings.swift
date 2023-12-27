//
//  AppStrings.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 14/08/21.
//

import Foundation
let APP_NAME = "prod"

//let API_PATH = "http://172.200.221.113/newapp/" // staging
//let new_path = "http://172.200.221.113/app/"// Staging

let API_PATH = "https://www.mytbam.com.au/crm/newapp/" // Prod
let new_path = "https://www.mytbam.com.au/crm/app/"// Prod

/* ---- Added by kush ---- */
//let baseURL = "https://www.mytbam.com.au/crm/app/" // prod
let baseURL = "http://172.200.221.113/app/" // staging
/* */

let IMG_PATH = ""

struct EndPoints {
    static let LOGIN = "login.php"
    static let DASHBOARD_COUNT = "countdashboard.php"
    static let SEARCH_DASHBOARD = "showsearchdata.php"
    static let SEARCH_DASHBOARD_RESULT_DETAILS = "search.php"
    static let ADD_NEW_ID = "addnew_application.php"
    static let ADD_NEW_ENTRY_ID = "get_new_reference.php"
    static let INSURANCE_COMPANY_LIST = "insurance_list.php"
    static let STATE_LIST = "state_list.php"
    static let DOCUMENT_LIST = "documentlist.php"
    static let REPAIRER_LIST = "repairer_list.php"
    static let TODAY_COLLECTION = "today_collection.php"
    static let TODAY_DELIVERY = "today_delivery.php"
    static let PROPOSED_VEHICLE = "proposed_vehicle.php"
    static let GET_NOT_AT_FAULT_DRIVER_DETAILS = "getnotatfault.php"
    static let GET_AT_FAULT_DRIVER_DETAILS = "getatfault.php"
    static let GET_ANY_OTHER_PARTY_DETAILS = "getotherparty.php"
    static let SAVE_NOT_AT_FAULT_DRIVER_DETAILS = "notatfault.php"
    static let SAVE_BOOKING_DETAILS = "savebookingdetails.php"
    static let GET_BOOKING_DETAILS = "getbookingdetails.php"
    static let SAVE_AT_FAULT_DRIVER_DETAILS = "atfault.php"
    static let SAVE_ANY_OTHER_PARTY_DETAILS = "otherparty.php"
    static let UPLOAD_ACCIDENT_PICS = "uploadaccident_pics.php"
    static let DELETE_ACCIDENT_PIC = "deleteaccident_pics.php"
    static let UPLOAD_DOCUMENT = "uploaddocuments.php"
    static let DELETE_UPLOADED_DOCUMENT = "deleteuploadeddoc.php"
    static let UPLOAD_SIGN = "uploadsign.php"
    static let DELETE_SIGN = "deletesign.php"
    static let UPLOAD_MULTIPLE_DOCS = "uploadmultiple_docs.php"
    //static let SAVE_BOOKING_DETAILS = "allocate_vehicle.php"//This was used in Upload Documents previously
    static let GET_UPLOADED_DOCUMENTS_TAB_DETAILS = "getuploaddocuments2.php"//"getuploaddocuments.php"
    static let ADD_HIRER = "hirerinsert.php"
    static let GET_HIRER_DETAILS = "gethirerdetails.php"
    static let SWAP_VEHICLE = "swapVehicle"
    static let SAVE_CARD_DETAILS = "savecarddetails.php"
    
    static let SAVE_ACCIDENT_DIAGRAM = "upload_accidentdiagram.php"
    static let RA_PREVIEW = "RA_preview.php"
    static let MAIL_INVOICE = "mail_invoice.php"
    static let FINAL_SUBMIT = "final_submit.php"
    static let FINAL_NEW_SUBMIT = "savenew_reference.php"
    static let REFERRAL_LIST = "referal_list.php"
    static let CHECK_STATUS = "check_status.php"
    static let DELIVERY_NOTES = "delivery_notes.php"
    static let DELIVERY_NOTE = "delivery_note.php"
    static let BRANCH_LIST = "branch_list.php"
    static let COLLECTION_NOTES = "collection_notes.php"
    static let COLLECTION_NOTE = "collection_note.php"
    static let REGO_NUMBER = "get_rego_number.php"
    static let REPAIRERS = "get_repairers.php"
    static let REFERRALS = "get_referrals.php"
    static let COLLECTED_DOCUMENTS = "collected_documents.php"
    static let RA_NUMBERS = "get_ra_numbers.php"
    static let RETURN_UPLOADED_DOCS = "returnuploaded_docs.php"
    static let UPDATE_BOOKING = "update_booking.php"
    static let GET_ACCIDENT_DETAILS = "get_accident_details.php"
    static let GET_UPCOMING_BOOKINGS = "upcoming_booking.php"
    static let GET_NEW_UPCOMING_BOOKINGS = "upcomingBookings"
    static let GET_NEW_REPAIRER_BOOKINGS = "repairerBookings"
    
    
    //Ashwani
    static let COLLECTION_LIST = "collectionlist.php"
    static let DELIVERYLIST = "deliverylist.php"
    static let HIRED_VEHICLE_LIST = "hiredvehicletable.php"
    static let AVAILABLE_VEHICLE_LIST = "available_vehiclestable.php"
    static let DELIVERED_COLLECTEDBY = "delivered_collectedby.php"
    
    
    static let AVAILABLE_VEHICLE_DROPDOWN_LIST = "available_vehicles.php"
    static let HIRED_VEHICLE_DROPDOWN_LIST = "hiredvehicleslist.php"
    
    
    
    static let RETURN_VEHICLE = "return_vehicle.php"
    static let RETURNUPLOADED_DOCS = "returnuploaded_docs.php"
    
    static let UNDER_MAINTENANCE = "getFleetsList"
    static let SEARCH_REFERENCE = "search_reference.php"
    
}
//Diksha Rattan: Segues on storyboard

struct AppSegue {
    static let LOGIN = "segueLogin"
    static let DASHBOARD = "segueDashboard"
    static let DRAWER = "segueDrawer"
    static let RETURN_VEHICLE = "segueReturnVehicle"
    static let DELIVERIES = "segueDeliveries"
    static let COLLECTIONS = "segueCollections"
    static let SWAP_VEHICLE = "segueSwapVehicle"
    static let CREATE_NEW_ENTRY = "segueCreateNewEntry"
    static let COLLECTION_NOTE_LIST = "seguecollectionNoteList"
    static let DELIVERY_NOTE_LIST = "seguedeliveryNoteList"
    static let DIGITAL_SIGNATURE = "segueDigitalSignature"
    static let DASHBOARD_SEARCH_RESULT_DETAILS = "segueDashboardSearchResultDetails"
    static let UPCOMING_BOOKINGS = "upcomingBookings"
    static let UNDER_MAINTENANCE_VEHICLES = "segueUnderMaintenanceVehicle"
    static let REPAIRER_BOOKINGS = "repairerBookings"
    //Ashwani
    static let AVAIL_VEHICLE = "segueAvailVehicle"
    static let HIRED_VEHICLE = "segueHiredVehicle"
    
    //iPhone
    static let LOGIN_PHONE = "segueLoginPhone"
    static let DASHBOARD_PHONE = "segueDashboardPhone"
    
}
//Diksha Rattan: Identifier of collection view cells
struct AppCvCells {
    static let DASHBOARD = "dashboardCvCell"
    static let RETURN_VEHICLE_PICTURES = "returnVehiclePicturesCvCell"
    static let RETURN_VEHICLE_ADD_MORE_PICTURES = "returnVehicleAddMorePicturesCvCell"
    static let NEW_BOOKING_ENTRY_TAB = "newBookingEntryTabCvCell"
    static let ADD_ITEM_CELL = "cellAddItem"
    static let ACCIDENT_PICS = "accidentPicsCvCell"
    static let ADD_MORE_ACCIDENT_PICS = "addMoreAccidentPicsCvCell"
    static let RETURN_UPLOADED_DOCS_CELL = "returnUploadedDocsCell"
    static let SWAP_VEHICLE_PICTURES_CELL = "swapVehiclePicturesCell"
    static let SWAP_VEHICLE_ADDMORE_PICTURES_CELL = "swapVehicleAddMorePicturesCell"
    static let SWAP_VEHICLE_CV_CELL = "swapVehicleCVCell"
}
//Diksha Rattan: Identifier of table view cells
struct AppTblViewCells {
    static let DRAWER = "drawerTblViewCell"
    static let COLLECTIONS_LIST_HEADER = "collectionsHeaderTblViewCell"
    static let COLLECTIONS_CELL = "CollectionListCellId"
    static let UNDER_MAINTENANCE_CELL = "UnderMaintenanceListCellId"
    static let DOCUMENTS_HEADER = "documentsHeaderTblViewCell"
    static let DOCUMENTS = "documentsTblViewCell"
    static let SEARCH_DASHBOARD = "searchDashboardTblViewCell"
    static let SEARCH_DASHBOARD_RESULT_DETAIL = "searchDashboardResultDetailTblViewCell"
//    static let SEARCH_NOT_AT_FAULT_REFERENCE_NUMBER = "searchNotAtFaultReferenceNumberTblViewCell"
    static let SEARCH_LIST = "searchListTblViewCell"
    //Ashwani
    static let DELIVERY_LIST_CELL = "DeliveryListCellId"
    static let AVAIL_VEHICLE_LIST_CELL = "AvailVehicleTblCellId"
    static let HIRED_VEHICLE_LIST_CELL = "HiredVehicleTblCellId"
    static let DELIVERED_COLLECTED_BY_CELL = "deliveredCollectedbyCell"
    static let DELIVERY_NOTES_LIST_CELL = "deliveryNotesListCell"
    static let COLLECTION_NOTES_LIST_CELL = "collectionNotesListCell"
    static let UPCOMING_BOOKING_LIST_CELL = "UpcomingBookingListCell"
    static let COLLECTED_DOCUMENTS_LIST_CELL = "collectedDocumentsListCell"
    static let COLLECTED_DOC_COLLECTION_NOTE_CELL = "collectedDocCollectionNoteCell"
    static let SWAPPED_VEHICLE_CELL = "swappedVehicleCell"
    static let NOTES_LIST_TABLEVIEW_CELL = "NotesListTableViewCell"
    static let REF_SEARCH_RESULT_TABLEVIEW_CELL = "ReferenceSearchResultTableViewCell"
    static let REPAIR_BOOKING_TABLEVIEW_CELL = "RepairerBookingTableViewCell"
}

//Diksha Rattan:App Colour Names
struct AppColors {
    static let BLACK = "AppBlack"
    static let BLUE = "AppBlue"
    static let GREY = "AppGrey"
    static let RED = "AppRed"
    static let GREEN = "AppGreen"
    static let DISBLED_TAB_BACKGROUND = "DisabledTabBackground"
    static let DISABLED_TAB_TEXT = "DisabledTabTxt"
    static let INPUT_BACKGROUND = "InputBackground"
    static let INPUT_BORDER = "InputBorder"
    static let DRAWER_ITEM_SELECTED = "DrawerItemSelected"
}
//Diksha Rattan:App Storyboard Names
struct AppStoryboards {
    static let MAIN = "Main"
    static let DASHBOARD = "Dashboard"
    static let DASHBOARD_PHONE = "DashboardPhone"
}
//Diksha Rattan:App ViewController storyboard id
struct AppStoryboardId {
    static let LOGIN = "loginVC"
    static let DRAWER = "drawerVC"
    static let RETURN_VEHICLE = "returnVehicleVC"
    static let NEW_BOOKING_ENTRY = "newBookingEntryVC"
    static let NOT_AT_FAULT_DRIVER_DETAILS = "notAtFaultDriverDetailsVC"
    static let AT_FAULT_DRIVER_DETAILS = "atFaultDriverDetailsVC"
    static let ANY_OTHER_PARTY_DETAILS = "anyOtherPartyDetailsVC"
    static let UPLOAD_DOCUMENTS = "uploadDocumentsVC"
    static let BOOKING_DETAILS = "bookingDetailsVC"
    static let ADD_HIRER = "addHirerVC"
    static let SELECT_ITEM = "selectItemVC"
    static let SELECT_DATE = "selectDateVC"
    static let SELECT_TIME = "selectTimeVC"
    static let DISPLAY_FULL_IMAGE = "displayFullImageVC"
    static let SEARCH_LIST = "searchListVC"
    static let CARD_DETAILS = "cardDetailsVC"
    static let WEBVIEW = "webViewVC"
    static let SENDTOEMAIL = "sendToEmailVC"
    static let ADD_MORE_DETAILS = "addMoreDetailsVC"
    static let DASHBOARD = "dashboardVC"
    static let DELIVERY_NOTE = "deliveryNoteVC"
    static let COLLECTION_NOTE = "collectionNoteVC"
    static let SWAPPED_VEHICLEVC = "swappedVehicleVC"
    static let ADD_NOTES = "addNotesVC"
    static let NOTES_VC = "notesListIPadVC"
    static let REF_SEARCH_RESULT_VC = "referenceSearchVC"

    //iPhone
    static let SPLASH_PHONE = "splashPhoneVC"
    static let LOGIN_PHONE = "loginPhoneVC"
    static let DRAWER_PHONE = "drawerPhoneVC"
    static let NEW_BOOKIN_ENTRY_PHONE = "newBookingEntryPhoneVC"
    static let NOT_AT_FAULT_DRIVER_DETAILS_PHONE = "notAtFaultDriverDetailsPhoneVC"
    static let AT_FAULT_DRIVER_DETAILS_PHONE = "atFaultDriverDetailsPhoneVC"
    static let ANY_OTHER_PARTY_DETAILS_PHONE = "anyOtherPartyDetailsPhoneVC"
    static let UPLOAD_DOCUMENTS_PHONE = "uploadDocumentsPhoneVC"
    static let ADD_HIRER_PHONE = "addHirerPhoneVC"
    static let BOOKING_DETAILS_PHONE = "bookingDetailsPhoneVC"
    static let SELECT_TIME_PHONE = "selectTimePhoneVC"
    static let SELECT_DATE_PHONE = "selectDatePhoneVC"
    static let SELECT_ITEM_PHONE = "selectItemPhoneVC"
    static let SEARCH_LIST_PHONE = "searchListPhoneVC"
    static let DASHBOARD_PHONE = "dashboardPhoneVC"
    static let DELIVERY_NOTE_PHONE = "deliveryNotePhoneVC"
    static let COLLECTION_NOTE_PHONE = "collectionNotePhoneVC"
    static let SWAPPED_VEHICLE_PHONE = "swappedVehiclePhoneVC"
    static let ADD_NOTES_PHONE = "addNotesPhoneVC"
    
    static let DIAGRAM = "diagramVC"
    
    static let WEBVIEW_PHONE = "webViewPhoneVC"
    static let SENDTOEMAIL_PHONE = "sendToEmailPhoneVC"
    static let ADD_MORE_DETAILS_PHONE = "addMoreDetailsPhoneVC"
    static let NOTES_PHONE = "notesListVC"
    static let REF_SEARCH_RESULT_PHONE = "referenceSearchPhoneVC"
    
}
//Diksha Rattan:Image names used in code
struct AppImageNames {
    static let RADIO_BTN_SELECTED = "radioBtnSelected"
    static let RADIO_BTN_UNSELECTED = "radioBtnUnselected"
    static let ADD = "plusGrey"
    static let DELETE = "delete"
    static let NO_RECORD_FOUND = "noRecordFound"
    //iPhone
    static let NO_RECORD_FOUND_SMALL = "noRecordFoundSmall"
}
//Diksha Rattan:Local Notifications
struct AppNotificationNames {
    static let LIST = "List"
    static let SELECT_DATE = "SelectDate"
    static let SELECT_TIME = "SelectTime"
}
//Diksha Rattan:Names of dropdowns used in app
struct AppDropDownLists {
    static let PROPOSED_VEHICLE = "Proposed Vehicle"
    static let STATE = "State"
    static let INSURANCE_COMPANY = "Insurance Company"
    static let REPAIRER = "Repairer"
    static let REFERRAL = "Referral"
    static let DOCUMENTS = "Documents"
    static let HIRED_VEHICLE_REGO_RA = "Hired Vehicle Rego RA"
    static let AVAILABLE_VEHICLE_REGO_RA = "Available Vehicle Rego RA"
    static let SEARCH_USER_LIST = "Assign"
    static let RETURN_VEHICLE_REGO = "REGO-RA"//"Return Vehicle Dropdown"
    static let CARD_TYPE = "CardType"
    static let FUEL_OUT = "FuelOut"
    static let DELIVERED_BY = "Delivered By"
    static let COLLECTED_BY = "Collected By"
    static let BRANCH_NAME = "Branch"
    static let REGO_NUMBER = "Rego Number"
    static let RANUNBER_NUMBER = "RA"
    static let RECOVERY_FOR = "Recovery For"
}
//Key Strings of DatePicker
struct DatePickerKeys {
    static let SELECTED_DATE = "selectedDate"
    static let DATE_TEXTFIELD = "dateTextField"
    static let SELECTED_YEAR = "selectedYear"
    static let SELECTED_MONTH = "selectedMonth"
    static let SELECTED_DAY = "selectedDay"
}
//struct AppDropDownListCode {
//    static let PROPOSED_VEHICLE = 0
//    static let STATE = 1
//    static let INSURANCE_COMPANY = 2
//    static let DOCUMENTS = 3
//}
