//
//  SendToEmailViewModel.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 02/03/23.
//

import Foundation
import Alamofire
import UIKit

protocol SendToEmailViewVMDelegate {
    func sendToEmailAPISuccess(strMessage: String, serviceKey: String)
    func sendToEmailAPISuccess(objData : SendToEmailModelData,strMessage: String,serviceKey: String)
    func sendToEmailAPIFailure(strMessage : String,serviceKey: String)
}
class  SendToEmailViewModel : NSObject{
    var delegate : SendToEmailViewVMDelegate! = nil
    func sendToEmailAPI(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
}


extension SendToEmailViewModel : DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        print(serviceKey)
        switch serviceKey {
        case EndPoints.MAIL_INVOICE:
            delegate.sendToEmailAPISuccess(strMessage: strMessage, serviceKey: serviceKey)
        default:
            print("Unknown Service Key")
        }
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.MAIL_INVOICE:
            delegate.sendToEmailAPISuccess(strMessage: strMessage, serviceKey: serviceKey)
        
        default:
            print("Unknown Service Key")
        }
    }
}
