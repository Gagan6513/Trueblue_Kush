//
//  DeliveriesViewModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 20/08/21.
//

import Foundation
import Alamofire
protocol DeliveriesVMDelegate {
    func deliveriesAPISuccess(objData : DeliveriesModel,strMessage: String)
    func deliveriesAPIFailure(strMessage : String, serviceKey: String)
}
class DeliveriesViewModel : NSObject{
    var delegate : DeliveriesVMDelegate! = nil
    func postDeliveries(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
    func getDeliveries(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.getRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
//    func postMultipartDeliveries(currentController : UIViewController ,parameters : Parameters,endPoint: String,img: UIImage,isImage: Bool,imgParameter: String,imgExtension: String) {
//        let objCallApi = DataSyncManager()
//        objCallApi.delegateDataSync = self
//        objCallApi.postRequestMultipart(endPoint: endPoint, parameters: parameters,img: img, isImage: isImage, imgParameter: imgParameter, imgExtension: imgExtension, currentController: currentController)
//    }
}


extension DeliveriesViewModel : DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        if serviceKey == EndPoints.DELIVERYLIST {
            let dict = DeliveriesModel(dict: dictObj)
            print(dict)
            delegate.deliveriesAPISuccess(objData: dict, strMessage: strMessage)
        }
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        if serviceKey == EndPoints.DELIVERYLIST {
            delegate.deliveriesAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        }
    }
}

