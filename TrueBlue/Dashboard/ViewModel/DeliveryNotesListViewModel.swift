//
//  DeliveryNotesListViewModel.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 13/04/23.
//

import Foundation
import Alamofire
import UIKit

protocol DeliveredNoteListVMDelegate {
    //func deliveredNoteListAPISuccess(strMessage: String, serviceKey: String)
    func deliveredNoteListAPISuccess(objData : DeliveryNotesListModel,strMessage: String,serviceKey: String)
    func deliveredNoteListAPIFailure(strMessage : String,serviceKey: String)
}
class  DeliveryNotesListViewModel : NSObject{
    var delegate : DeliveredNoteListVMDelegate! = nil
    
    func postDeliveredNoteDetail(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
    func getdeliveredNoteDetail(currentController : UIViewController ,parameters : Parameters?,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.getRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
}
extension DeliveryNotesListViewModel : DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        print(serviceKey)
        let deliveryNotesListModel = DeliveryNotesListModel(dict: dictObj)
        print(deliveryNotesListModel.arrResult)
        switch serviceKey {
            
        case EndPoints.DELIVERY_NOTES:
            delegate.deliveredNoteListAPISuccess(objData: deliveryNotesListModel, strMessage: strMessage, serviceKey: serviceKey)
            
        default:
            print("Unknown Service Key")
        }
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.DELIVERY_NOTES:
            delegate.deliveredNoteListAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
            
        default:
            print("Unknown Service Key")
        }
    }
}
