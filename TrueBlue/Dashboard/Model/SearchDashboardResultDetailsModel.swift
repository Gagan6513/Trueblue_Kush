//
//  SearchDashboardResultDetailsModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 01/09/21.
//

import Foundation
class SearchDashboardResultDetailsModel : NSObject {
    var arrResult = [SearchDashboardResultDetailsModelData]()
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictArray = SearchDashboardResultDetailsModelData()
                dictArray.appId = dict["appid"] as? String ?? ""
                dictArray.referenceNumber = dict["refno"] as? String ?? ""
                dictArray.vehicleRego = dict["vehicle_rego"] as? String ?? ""
                dictArray.makeModel = dict["make"] as? String ?? ""
                dictArray.clientName = dict["clientname"] as? String ?? ""
                dictArray.dateIn = dict["datein"] as? String ?? ""
                dictArray.dateOut = dict["dateout"] as? String ?? ""
                dictArray.settledAmount = dict["SettledAmount"] as? String ?? ""
                dictArray.paymentAmount = dict["PaymentAmount"] as? String ?? ""
                dictArray.status = dict["appstatus"] as? String ?? ""
                
                dictArray.clientRego = dict["Client_rego"] as? String ?? ""
                dictArray.clientMakeModel = dict["Clientmake_model"] as? String ?? ""
                dictArray.repairerName = dict["repairer_name"] as? String ?? ""
                dictArray.referralName = dict["referral_name"] as? String ?? ""
                arrResult.append(dictArray)
            }
        }
    }
}


struct SearchDashboardResultDetailsModelData {
    var appId : String = ""
    var referenceNumber : String = ""
    var vehicleRego : String = ""
    var makeModel : String = ""
    var clientName : String = ""
    var dateIn : String = ""
    var dateOut : String = ""
    var settledAmount : String = ""
    var paymentAmount : String = ""
    var status : String = ""
  
    var clientRego : String = ""
    var clientMakeModel : String = ""
    var repairerName : String = ""
    var referralName : String = ""
    
}
