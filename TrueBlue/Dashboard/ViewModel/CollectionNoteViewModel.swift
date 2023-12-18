//
//  CollectionNoteViewModel.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 18/04/23.
//

import Foundation
import UIKit
import Alamofire


protocol CollectionNoteVMDelegate {
    func collectionNoteAPISuccess(strMessage: String, serviceKey: String)
    func collectionNoteAPISuccess(objData : CollectionNotesModel,strMessage: String,serviceKey: String)
    func collectionNoteAPISuccess(objData : RegoNumberListModel,strMessage: String,serviceKey: String)
    func collectionNoteAPISuccess(objData : CollectedDocumentsModel,strMessage: String,serviceKey: String)
    func collectionNoteAPISuccess(objData : RANumbersListModel ,strMessage: String,serviceKey: String)
    func collectionNoteAPISuccess(objData : GetAccidentDetailsModel ,strMessage: String,serviceKey: String)
    
    func collectionNoteAPIFailure(strMessage : String,serviceKey: String)
}
class  CollectionNoteViewModel : NSObject{
    var delegate : CollectionNoteVMDelegate! = nil
    
    func postCollectionNoteDetail(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
    func getCollectionNoteDetail(currentController : UIViewController ,parameters : Parameters?,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.getRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
    
}


extension CollectionNoteViewModel : DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        print(serviceKey)
        switch serviceKey {
        case EndPoints.COLLECTION_NOTE:
            let collectionNotesModel = CollectionNotesModel(dict: dictObj)
            delegate.collectionNoteAPISuccess(strMessage: strMessage, serviceKey: serviceKey)
            delegate.collectionNoteAPISuccess(objData: collectionNotesModel, strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.REGO_NUMBER:
            let regoNumberModel = RegoNumberListModel(dict: dictObj)
            delegate.collectionNoteAPISuccess(objData: regoNumberModel, strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.COLLECTED_DOCUMENTS :
            let collectedDocuments = CollectedDocumentsModel(dict: dictObj)
            delegate.collectionNoteAPISuccess(objData: collectedDocuments, strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.RA_NUMBERS:
            let raNumberListModel = RANumbersListModel(dict: dictObj)
            delegate.collectionNoteAPISuccess(objData: raNumberListModel, strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.GET_ACCIDENT_DETAILS:
            let getAccidentDetailsModel = GetAccidentDetailsModel(dict: dictObj)
            delegate.collectionNoteAPISuccess(objData: getAccidentDetailsModel, strMessage: strMessage, serviceKey: serviceKey)
        default:
            print("Unknown Service Key")
        }
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.COLLECTION_NOTE,EndPoints.GET_ACCIDENT_DETAILS:
            delegate.collectionNoteAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        
        default:
            print("Unknown Service Key")
        }
    }
}
