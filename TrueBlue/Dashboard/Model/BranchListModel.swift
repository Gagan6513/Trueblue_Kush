//
//  BranchListModel.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 15/04/23.
//

import Foundation

class BranchListModel : NSObject {
    var arrResult = [BranchListModelData]()
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictArray = BranchListModelData()
                dictArray.branchID = dict["branch_id "] as? String ?? ""
                dictArray.branchName = dict["branch_name"] as? String ?? ""
                arrResult.append(dictArray)
            }
        }
    }
}
struct BranchListModelData {
    var branchID : String = ""
    var branchName : String = ""
}



class BranchResponse: Codable {
    
    var data: BranchDataResponse?
    var status: Int?
    var msg:String?
    var statusCode: Int?
    
}

class BranchDataResponse: Codable {
    
    var response: [BranchListResponse]?
}

class BranchListResponse: Codable {
    
    var id: String?
    var name: String?
    var city: String?
    var address: String?
    var status: String?
    var created_date: String?
    
}


class InsuranceResponse: Codable {
    
    var data: InsuranceDataResponse?
    var status: Int?
    var msg:String?
    var statusCode: Int?
    
}

class InsuranceDataResponse: Codable {
    
    var response: [InsuranceListResponse]?
}

class InsuranceListResponse: Codable {
    
    var ins_id: String?
    var insurance_company: String?
    
}

class ReferalResponse: Codable {
    
    var data: ReferalDataResponse?
    var status: Int?
    var msg:String?
    var statusCode: Int?
    
}

class ReferalDataResponse: Codable {
    
    var response: [ReferalListResponse]?
}

class ReferalListResponse: Codable {
    
    var ref_id: String?
    var referral_name: String?
    
}



class RepairerResponse: Codable {
    
    var data: RepairerDataResponse?
    var status: Int?
    var msg:String?
    var statusCode: Int?
    
}

class RepairerDataResponse: Codable {
    
    var response: [RepairerListResponse]?
}

class RepairerListResponse: Codable {
    
    var rep_id: String?
    var repairer_name: String?
    
}


class StateResponse: Codable {
    
    var data: StateDataResponse?
    var status: Int?
    var msg:String?
    var statusCode: Int?
    
}

class StateDataResponse: Codable {
    
    var response: [StateListResponse]?
}

class StateListResponse: Codable {
    
    var id: String?
    var state: String?
    var state_code: String?
    var status: String?
    var created_date: String?
}


class RegoResponse: Codable {
    
    var data: [RegoListResponse]?
    var status: Int?
    var msg:String?
    var statusCode: Int?
    
}

class RegoListResponse: Codable {
    
    var available_date: String?
    var available_location: String?
    var available_status: String?
    var available_time: String?
    var basemilage: String?
    var basemilage_date: String?
    var chassis_no: String?
    var color: String?
    var accident_rego: String?
    var created_date: String?
    var cron_status: String?
    var dealer_name: String?
    var description: String?
    var engine_no: String?
    var entry_type: String?
    var fleet_no: String?
    var fleet_status: String?
    var fuel_type: String?
    var id: String?
    var image_url: String?
    var key_no: String?
    var ownedbycompany: String?
    var purchase_date: String?
    var purchase_from: String?
    var radio_code: String?
    var registration_no: String?
    var registration_state: String?
    var status: String?
    var transmission: String?
    var type: String?
    var vehicle_category: String?
    var vehicle_cat_id: String?
    var vehicle_make: String?
    var vehicle_make_id: String?
    var vehicle_model: String?
    var vehicle_model_id: String?
    var vehicle_type: String?
    var vehicle_types: String?
    var vin: String?
    var yearof_manufacture: String?
    var yearof_purchase: String?
}

