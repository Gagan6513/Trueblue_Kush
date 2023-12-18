//
//  PreviewModel.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 01/03/23.
//

import Foundation

class PreviewModel : NSObject {
    var dictResult = PreviewModelData()
    init(dict : Dictionary<String, Any>) {
        dictResult.data = dict["url"] as? String ?? ""
    }
}

struct PreviewModelData {
    var data : String = ""
}
