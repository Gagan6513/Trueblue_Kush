//
//  DeliveryNoteViewModel.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 11/04/23.
//

import Foundation
import Alamofire
import UIKit

protocol DeliveredNoteVMDelegate {
    func deliveredNoteAPISuccess(strMessage: String, serviceKey: String)
    func deliveredNoteAPISuccess(objData : DeliveryNotesListModel,strMessage: String,serviceKey: String)
    func deliveredNoteAPISuccess(objData : RegoNumberListModel,strMessage: String,serviceKey: String)
    func deliveredNoteAPISuccess(objData : RepairersListModel,strMessage: String,serviceKey: String)
    func deliveredNoteAPISuccess(objData : ReferralsListModel,strMessage: String,serviceKey: String)
    func deliveredNoteAPISuccess(objData : CollectedDocumentsModel,strMessage: String,serviceKey: String)
    
    func deliveredNoteAPIFailure(strMessage : String,serviceKey: String)
}
class  DeliveryNoteViewModel : NSObject{
    var delegate : DeliveredNoteVMDelegate! = nil
    
    func postdeliveredNoteDetail(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
    func getDeliveredNoteDetail(currentController : UIViewController ,parameters : Parameters?,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.getRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
    
}


extension DeliveryNoteViewModel : DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        print(serviceKey)
        switch serviceKey {
        case EndPoints.DELIVERY_NOTE:
            let deliveryNotesModel = DeliveryNotesListModel(dict: dictObj)
            delegate.deliveredNoteAPISuccess(strMessage: strMessage, serviceKey: serviceKey)
            delegate.deliveredNoteAPISuccess(objData: deliveryNotesModel, strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.REFERRALS :
            let referralsListModel = ReferralsListModel(dict: dictObj)
            delegate.deliveredNoteAPISuccess(objData: referralsListModel , strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.REPAIRERS :
            let repairersListModel = RepairersListModel(dict: dictObj)
            delegate.deliveredNoteAPISuccess(objData: repairersListModel, strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.REGO_NUMBER:
           let regoNumberListModel = RegoNumberListModel(dict: dictObj)
            delegate.deliveredNoteAPISuccess(objData:regoNumberListModel , strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.COLLECTED_DOCUMENTS:
            let collectedDocumentModel = CollectedDocumentsModel(dict: dictObj)
            delegate.deliveredNoteAPISuccess(objData: collectedDocumentModel, strMessage: strMessage, serviceKey: serviceKey)
        default:
            print("Unknown Service Key")
        }
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.DELIVERY_NOTE:
            delegate.deliveredNoteAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
            
        default:
            print("Unknown Service Key")
        }
    }
}
