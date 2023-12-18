//
//  DeliveryNotesListModel.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 13/04/23.
//

import Foundation

class DeliveryNotesListModel : NSObject {
    var arrResult = [DeliveryNotesListModelData]()
    
    var detailsModel: DeliveryNotesListModelData?
    
    init(dict : Dictionary<String, Any>) {
        if let arr = dict["response"] as? Array<Dictionary<String, Any>> {
            for dict in arr {
                var dictArray = getParsedDeliveryNoteModel(dict:dict)
                arrResult.append(dictArray)
            }
        } else if let data = dict["response"] as? Dictionary<String, Any>{
            detailsModel = getParsedDeliveryNoteModel(dict: data)
        }
        
        func getParsedDeliveryNoteModel(dict: Dictionary<String, Any>) -> DeliveryNotesListModelData {
            var dictArray = DeliveryNotesListModelData()
            
            dictArray.id = dict["id"] as? String ?? ""
            dictArray.deliveryNote = dict["delivery_note"] as? String ?? ""
            dictArray.phoneNumber = dict["phone_number"] as? String ?? ""
            dictArray.clientName = dict["client_name"] as? String ?? ""
            dictArray.deliveryAddress = dict["delivery_address"] as? String ?? ""
            dictArray.deliveryDate = dict["delivery_date"] as? String ?? ""
            dictArray.deliveryTime = dict["delivery_time"] as? String ?? ""
            dictArray.regoNo = dict["rego_no"] as? String ?? ""
            dictArray.repairerId = dict["repairer_id"] as? String ?? ""
            dictArray.referralId = dict["referral_id"] as? String ?? ""
            dictArray.documentCollectedOther = dict["document_collected_other"] as? String ?? ""
            dictArray.documentsCollected = dict["documents_collected"] as? String ?? ""
            dictArray.specialInstructions = dict["special_instructions"] as? String ?? ""
            dictArray.deliveryBy = dict["delivery_by"] as? String ?? ""
            dictArray.createdDate = dict["created_date"] as? String ?? ""
            dictArray.isDeleted = dict["is_deleted"] as? String ?? ""
            dictArray.repairerName = dict["repairer_name"] as? String ?? ""
            dictArray.referralName = dict["referral_name"] as? String ?? ""
            dictArray.regoName = dict["rego_name"] as? String ?? ""
            
            return dictArray
        }
    }
}


struct DeliveryNotesListModelData {
    var id : String = ""
    var deliveryNote : String = ""
    var clientName : String = ""
    var phoneNumber : String = ""
    var deliveryAddress : String = ""
    var deliveryDate : String = ""
    var deliveryTime : String = ""
    var regoNo : String = ""
    var repairerId : String = ""
    var referralId : String = ""
    var documentCollectedOther : String = ""
    var documentsCollected : String = ""
    var specialInstructions : String = ""
    var deliveryBy : String = ""
    var createdDate : String = ""
    var isDeleted : String = ""
    var repairerName : String = ""
    var referralName : String = ""
    var regoName : String = ""
    
    
}
