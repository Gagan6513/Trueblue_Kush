//
//  UnderMaintenanceViewModel.swift
//  TrueBlue
//
//  Created by Gurmeet Kaur Narang on 13/12/23.
//

import Foundation
import Alamofire
protocol UnderMaintenanceVMDelegate {
    func UnderMaintenanceAPISuccess(objData : UnderMaintenanceModel,strMessage: String)
    func UnderMaintenanceAPIFailure(strMessage : String, serviceKey: String)
}

class UnderMaintenanceViewModel : NSObject{
    var delegate : UnderMaintenanceVMDelegate! = nil
    func postUnderMaintenanceList(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
    func getUnderMaintenanceList(currentController : UIViewController ,parameters : Parameters?,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.getRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }

    
}


extension UnderMaintenanceViewModel : DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        if serviceKey == EndPoints.UNDER_MAINTENANCE {
            let dict = UnderMaintenanceModel(dict: dictObj)
            print(dict)
            delegate.UnderMaintenanceAPISuccess(objData: dict, strMessage: strMessage)
        }
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        if serviceKey == EndPoints.UNDER_MAINTENANCE {
            delegate.UnderMaintenanceAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        }
    }
}

