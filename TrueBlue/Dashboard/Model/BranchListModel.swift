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
    
    var branch_id: String?
    var branch_name: String?
    
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
