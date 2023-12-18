//
//  DocumentListModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 25/08/21.
//

import Foundation
class DocumentListModel : NSObject {
    var arrResult = [DocumentListModelData]()
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictArray = DocumentListModelData()
                dictArray.documentId = dict["document_id"] as? String ?? ""
                dictArray.documentName = dict["document_name"] as? String ?? ""
                arrResult.append(dictArray)
            }
        }
    }
}


struct DocumentListModelData {
    var documentId : String = ""
    var documentName : String = ""
}
