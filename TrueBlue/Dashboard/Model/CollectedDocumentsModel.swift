//
//  CollectedDocumentsModel.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 18/04/23.
//

import Foundation

class CollectedDocumentsModel : NSObject {
    var arrResult = [CollectedDocumentsModelData]()
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictArray = CollectedDocumentsModelData()
                dictArray.documentID = dict["id"] as? String ?? ""
                dictArray.documentName = dict["document_name"] as? String ?? ""
                
                arrResult.append(dictArray)
            }
        }
    }
}
struct CollectedDocumentsModelData {
    var documentID : String = ""
    var documentName : String = ""
    var isSelected: Bool = false
}
