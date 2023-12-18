//
//  FinalSubmitViewModel.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 02/03/23.
//

import Foundation
import Alamofire
import UIKit

protocol FinalSubmitVMDelegate {
    func finalSubmitAPISuccess(strMessage: String, serviceKey: String)
    func finalSubmitAPISuccess(objData : FinalSubmitModelData,strMessage: String,serviceKey: String)
    func finalSubmitAPIFailure(strMessage : String,serviceKey: String)
}
class  FinalSubmitViewModel : NSObject{
    var delegate : FinalSubmitVMDelegate! = nil
    func finalSubmitAPI(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
}


extension FinalSubmitViewModel : DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        print(serviceKey)
        switch serviceKey {
        
        case EndPoints.FINAL_SUBMIT:
            if !UserDefaults.standard.GetReferenceId().isEmpty{
                UserDefaults.standard.removeReferenceID()
            }
            delegate.finalSubmitAPISuccess(strMessage: strMessage, serviceKey: serviceKey)

        default:
            print("Unknown Service Key")
        }
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.FINAL_SUBMIT:
            delegate.finalSubmitAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        
        default:
            print("Unknown Service Key")
        }
    }
}
