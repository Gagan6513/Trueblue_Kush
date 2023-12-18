//
//  CollectionNoteListViewModel.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 17/04/23.
//

import Foundation
import Alamofire

protocol CollectionNoteListVMDelegate {
    //func deliveredNoteListAPISuccess(strMessage: String, serviceKey: String)
    func collectionNoteListAPISuccess(objData : CollectionNotesModel,strMessage: String,serviceKey: String)
    func collectionNoteListAPIFailure(strMessage : String,serviceKey: String)
}
class  CollectionNoteListViewModel : NSObject{
    var delegate : CollectionNoteListVMDelegate! = nil
    
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


extension CollectionNoteListViewModel : DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        print(serviceKey)
        let collectionNotesListModel = CollectionNotesModel(dict: dictObj)
        print(collectionNotesListModel.arrResult)
        switch serviceKey {
        case EndPoints.COLLECTION_NOTES:
            delegate.collectionNoteListAPISuccess(objData: collectionNotesListModel, strMessage: strMessage, serviceKey: serviceKey)
            
        default:
            print("Unknown Service Key")
        }
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.DELIVERY_NOTES:
            delegate.collectionNoteListAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
            
        default:
            print("Unknown Service Key")
        }
    }
}
