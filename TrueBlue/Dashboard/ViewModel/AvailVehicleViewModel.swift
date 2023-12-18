//
//  AvailVehicleViewModel.swift
//  TrueBlue
//
//  Created by Ashwani Kumar on 30/08/21.
//

import Foundation
import Alamofire
protocol AvailVehicleVMDelegate {
    func AvailVehicleAPISuccess(objData : AvailVehicleListModel,strMessage: String)
    func AvailVehicleAPIFailure(strMessage : String, serviceKey: String)
}

class AvailVehicleViewModel : NSObject{
    var delegate : AvailVehicleVMDelegate! = nil
    func postAvailVehicleList(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
    func getAvailVehicleList(currentController : UIViewController ,parameters : Parameters?,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.getRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }

    
}


extension AvailVehicleViewModel : DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        if serviceKey == EndPoints.AVAILABLE_VEHICLE_LIST {
            let dict = AvailVehicleListModel(dict: dictObj)
            print(dict)
            delegate.AvailVehicleAPISuccess(objData: dict, strMessage: strMessage)
        }
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        if serviceKey == EndPoints.AVAILABLE_VEHICLE_LIST {
            delegate.AvailVehicleAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        }
    }
}
