//
//  HiredVehicleViewModel.swift
//  TrueBlue
//
//  Created by Ashwani Kumar on 30/08/21.
//

import Foundation
import Alamofire
protocol HiredVehicleVMDelegate {
    func HiredVehicleAPISuccess(objData : HiredVehicleListModel,strMessage: String)
    func HiredVehicleAPIFailure(strMessage : String, serviceKey: String)
}

class HiredVehicleViewModel : NSObject{
    var delegate : HiredVehicleVMDelegate! = nil
    func postHiredVehiclesList(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
    func getHiredVehiclesList(currentController : UIViewController ,parameters : Parameters?,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.getRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
//    func postMultipartCollections(currentController : UIViewController ,parameters : Parameters,endPoint: String,img: UIImage,isImage: Bool,imgParameter: String,imgExtension: String) {
//        let objCallApi = DataSyncManager()
//        objCallApi.delegateDataSync = self
//        objCallApi.postRequestMultipart(endPoint: endPoint, parameters: parameters,img: img, isImage: isImage, imgParameter: imgParameter, imgExtension: imgExtension, currentController: currentController)
//    }
}


extension HiredVehicleViewModel : DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        if serviceKey == EndPoints.HIRED_VEHICLE_LIST {
            let dict = HiredVehicleListModel(dict: dictObj)
            print(dict)
            delegate.HiredVehicleAPISuccess(objData: dict, strMessage: strMessage)
        }
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        if serviceKey == EndPoints.HIRED_VEHICLE_LIST {
            delegate.HiredVehicleAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        }
    }
}
