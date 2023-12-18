//
//  SendToEmailModel.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 02/03/23.
//

import Foundation

class SendToEmailModel : NSObject {
    var arrResult = [SendToEmailModelData]()
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictArray = SendToEmailModelData()
                dictArray.msg = dict["msg"] as? String ?? ""
                dictArray.status = dict["status"] as? Int ?? 0
                arrResult.append(dictArray)
            }
        }
    }
}

struct SendToEmailModelData {
    var msg : String = ""
    var status : Int = 0
    var data : String = ""
}
