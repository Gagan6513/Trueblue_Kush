//
//  UploadDocumentsModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 27/08/21.
//

import Foundation
class UploadDocumentsModel : NSObject {
    var dictResult = UploadDocumentsModelData()
    init(dict : Dictionary<String, Any>) {
//        var dictArray = UploadDocumentsModelData()
        if let temp = dict["accidentpics"] as? Dictionary<String, Any> {
            dictResult.accidentPicsId = temp["id"] as? String ?? ""
            dictResult.accidentPicsImgOne = temp["image"] as? String ?? ""
            dictResult.accidentPicsImgTwo = temp["image_url1"] as? String ?? ""
            dictResult.accidentPicsImgThree = temp["image_url2"] as? String ?? ""
            dictResult.accidentPicsImgFour = temp["image_url3"] as? String ?? ""
            dictResult.accidentPicsImgFive = temp["image_url4"] as? String ?? ""
        }
        if let temp = dict["document_details"] as? Array<Dictionary<String, Any>> {
            for dict1 in temp {
                var dictArray = DocumentsUploadedModelData()
                dictArray.documentId = dict1["doc_id"] as? String ?? ""
                dictArray.document = dict1["document"] as? String ?? ""
                dictArray.documentImg = dict1["image_url"] as? String ?? ""
                dictResult.documentsUploaded.append(dictArray)
            }
        }
//        if let temp = dict["document_details"] as? Array<Dictionary<String, Any>> {
//            print(temp)
//
//            for i in 0...temp.count-1 {
//                print(temp[i])
////                var dictArray = DocumentsUploadedModelData()
////                dictArray.documentId = temp["doc_id"] as? String ?? ""
////                dictArray.document = temp["document"] as? String ?? ""
////                dictArray.documentImg = temp["image_url"] as? String ?? ""
////                dictResult.documentsUploaded.append(DocumentsUploadedModelData)
//            }
//
//        }
        if let temp = dict["sign"] as? Dictionary<String, Any> {
            dictResult.signId = temp["sign_id"] as? String ?? ""
            dictResult.signImg = temp["sign"] as? String ?? ""
            dictResult.signImage2 = temp["sign1"] as? String ?? ""
        }
        
        if let temp = dict["carddetails"] as? Dictionary<String,Any> {
            dictResult.cardDetails.cardOneHolderName = temp["cardholder_name"] as? String ?? ""
            dictResult.cardDetails.cardOneNumber = temp["card_no"] as? String ?? ""
            dictResult.cardDetails.cardOneType = temp["card_type"] as? String ?? ""
            dictResult.cardDetails.cardOneExpiryDate = temp["expiry_date"] as? String ?? ""
            dictResult.cardDetails.cardOneCvv = temp["cvv"] as? String ?? ""
            dictResult.cardDetails.cardTwoHolderName = temp["cardholder_name2"] as? String ?? ""
            dictResult.cardDetails.cardTwoNumber = temp["card_no2"] as? String ?? ""
            dictResult.cardDetails.cardTwoType = temp["card_type2"] as? String ?? ""
            dictResult.cardDetails.cardTwoExpiryDate = temp["expiry_date2"] as? String ?? ""
            dictResult.cardDetails.cardTwoCvv = temp["cvv2"] as? String ?? ""
        }
//        if let temp = dict["bookingdetails"] as? Dictionary<String, Any> {
//            dictResult.bookingDetails.mileageOut = temp["Mileage_out"] as? String ?? ""
//            dictResult.bookingDetails.cardHolderName = temp["cardholder_name"] as? String ?? ""
//            dictResult.bookingDetails.cardNumber = temp["card_no"] as? String ?? ""
//            dictResult.bookingDetails.cardType = temp["card_type"] as? String ?? ""
//            dictResult.bookingDetails.cvv = temp["cvv"] as? String ?? ""
//            dictResult.bookingDetails.dateOut = temp["date_out"] as? String ?? ""
//            dictResult.bookingDetails.expiryDate = temp["expiry_date"] as? String ?? ""
//            dictResult.bookingDetails.fuelOut = temp["fuel_out"] as? String ?? ""
//            dictResult.bookingDetails.timeOut = temp["time_out"] as? String ?? ""
//        }
    }
}


struct UploadDocumentsModelData {
    var accidentPicsId : String = ""
    var accidentPicsImgOne : String = ""
    var accidentPicsImgTwo : String = ""
    var accidentPicsImgThree : String = ""
    var accidentPicsImgFour : String = ""
    var accidentPicsImgFive : String = ""
    var accidentPicsImgSix : String = ""
    var documentsUploaded = [DocumentsUploadedModelData]()
    var signId : String = ""
    var signImg : String = ""
    var signImage2 : String = ""
    var cardDetails = CardDetailsModelData()
    //var bookingDetails = BookingDetailsModelData()
}


struct DocumentsUploadedModelData {
    var documentId : String = ""
    var document : String = ""
    var documentImg : String = ""
}

struct CardDetailsModelData {
    var cardOneHolderName : String = ""
    var cardOneNumber : String = ""
    var cardOneType : String = ""
    var cardOneCvv : String = ""
    var cardOneExpiryDate : String = ""
    var cardTwoHolderName : String = ""
    var cardTwoNumber : String = ""
    var cardTwoType : String = ""
    var cardTwoCvv : String = ""
    var cardTwoExpiryDate : String = ""
}
//struct BookingDetailsModelData {
//    var mileageOut : String = ""
//    var cardHolderName : String = ""
//    var cardNumber : String = ""
//    var cardType : String = ""
//    var cvv : String = ""
//    var dateOut : String = ""
//    var expiryDate : String = ""
//    var fuelOut : String = ""
//    var timeOut : String = ""
//}
