//
//  ReturnUploadedDocsModel.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 19/04/23.
//

import Foundation

class ReturnUploadedDocsModel : NSObject {
    var accidentpics = ReturnUploadedDocsModelData()
    var documentDetails = [DocumentDetailsModelData]()
    init(dict : Dictionary<String, Any>) {
//        var dictArray = UploadDocumentsModelData()
        if let temp = dict["accidentpics"] as? Dictionary<String, Any> {
            accidentpics.accidentPicsId = temp["id"] as? String ?? ""
            accidentpics.accidentPicsImgOne = temp["image"] as? String ?? ""
            accidentpics.accidentPicsImgTwo = temp["image_url1"] as? String ?? ""
            accidentpics.accidentPicsImgThree = temp["image_url2"] as? String ?? ""
            accidentpics.accidentPicsImgFour = temp["image_url3"] as? String ?? ""
            accidentpics.accidentPicsImgFive = temp["image_url4"] as? String ?? ""
        }
        if let documentDetailstemp = dict["document_details"] as? Array<Dictionary<String, Any>> {
            for dict1 in documentDetailstemp {
                var dictArray = DocumentDetailsModelData()
    
                dictArray.documentImg = dict1["image_url"] as? String ?? ""
                documentDetails.append(dictArray)
            }
        }
    }
}

struct ReturnUploadedDocsModelData {
    var accidentPicsId : String = ""
    var accidentPicsImgOne : String = ""
    var accidentPicsImgTwo : String = ""
    var accidentPicsImgThree : String = ""
    var accidentPicsImgFour : String = ""
    var accidentPicsImgFive : String = ""
}

struct DocumentDetailsModelData {
    var documentImg : String = ""
}
