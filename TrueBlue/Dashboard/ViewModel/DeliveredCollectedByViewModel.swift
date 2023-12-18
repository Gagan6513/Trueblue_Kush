//
//  DeliveredCollectedByViewModel.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 02/03/23.
//

import Foundation
import UIKit
import Alamofire

protocol DeliveredCollectedByVMDelegate {
    func deliveredCollectedByAPISuccess(strMessage: String, serviceKey: String)
    func deliveredCollectedByAPISuccess(objData : DeliveredCollectedByModel,strMessage: String,serviceKey: String)
    func deliveredCollectedByAPIFailure(strMessage : String,serviceKey: String)
}
class  DeliveredCollectedByViewModel : NSObject{
    var delegate : DeliveredCollectedByVMDelegate! = nil
    func deliveredCollectedByAPI(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
}


extension DeliveredCollectedByViewModel : DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        print(serviceKey)
        let collectedByModel = DeliveredCollectedByModel(dict: dictObj)
       
        switch serviceKey {
        
        case EndPoints.DELIVERED_COLLECTEDBY:
            delegate.deliveredCollectedByAPISuccess(strMessage: strMessage, serviceKey: serviceKey)
            delegate.deliveredCollectedByAPISuccess(objData: collectedByModel, strMessage: strMessage, serviceKey: serviceKey)

        default:
            print("Unknown Service Key")
        }
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.DELIVERED_COLLECTEDBY:
            delegate.deliveredCollectedByAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        
        default:
            print("Unknown Service Key")
        }
    }
}
