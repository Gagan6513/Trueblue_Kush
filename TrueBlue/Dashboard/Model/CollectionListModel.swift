//
//  CollectionListModel.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 15/04/23.
//

import Foundation

class CollectionNotesModel : NSObject {
    var arrResult = [CollectionNotesModelData]()
    
    var collectionDetailsModel : CollectionNotesModelData?
    
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictArray = getParsedCollectionNoteModel(dict:dict)
                arrResult.append(dictArray)
            }
            } else if let data = dict["response"] as? Dictionary<String, Any> {
                collectionDetailsModel = getParsedCollectionNoteModel(dict:data)
            }
        func getParsedCollectionNoteModel(dict: Dictionary<String,Any>) -> CollectionNotesModelData {
            var dictArray = CollectionNotesModelData()
            
                dictArray.id = dict["id"] as? String ?? ""
                dictArray.raNumber = dict["ra_number"] as? String ?? ""
                dictArray.clientName = dict["client_name"] as? String ?? ""
                dictArray.phoneNumber = dict["phone_number"] as? String ?? ""
                dictArray.collectionAddress = dict["collection_address"] as? String ?? ""
                dictArray.collectionDate = dict["collection_date"] as? String ?? ""
                dictArray.collectionTime = dict["collection_time"] as? String ?? ""
                dictArray.regoNo = dict["rego_no"] as? String ?? ""
                dictArray.documentCollectedOther = dict["document_collected_other"] as? String ?? ""
                dictArray.documentsCollected = dict["documents_collected"] as? String ?? ""
                dictArray.specialInstructions = dict["special_instructions"] as? String ?? ""
                dictArray.googleReview = dict["google_review"] as? String ?? ""
                dictArray.collectedBy = dict["collected_by"] as? String ?? ""
                dictArray.isDeleted = dict["is_deleted"] as? String ?? ""
                dictArray.regoName = dict["rego_name"] as? String ?? ""
            
            return dictArray
            }
            
        }
    }
struct CollectionNotesModelData {
    var id : String = ""
    var raNumber : String = ""
    var clientName : String = ""
    var phoneNumber : String = ""
    var collectionAddress : String = ""
    var collectionDate : String = ""
    var collectionTime : String = ""
    var regoNo : String = ""
    var documentCollectedOther : String = ""
    var documentsCollected : String = ""
    var specialInstructions : String = ""
    var googleReview : String = ""
    var collectedBy : String = ""
    var isDeleted : String = ""
    var regoName : String = ""
}


