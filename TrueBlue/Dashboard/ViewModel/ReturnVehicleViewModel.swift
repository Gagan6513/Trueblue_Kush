//
//  ReturnVehicleViewModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 20/08/21.
//

import Foundation
import Alamofire
protocol ReturnVehicleVMDelegate {
    func returnVehicleAPISuccess(objData : ReturnVehicleModel,strMessage: String)
    func returnVehicleAPISuccess(objData : HiredVehicleDropdownListModel,strMessage: String)
    func returnVehicleAPISuccess(objData : ReturnUploadedDocsModel,strMessage: String)
    func returnVehicleAPIFailure(strMessage : String, serviceKey: String)
}

class ReturnVehicleViewModel : NSObject{
    var delegate : ReturnVehicleVMDelegate! = nil
    func postReturnVehicle(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
    func getReturnVehicle(currentController : UIViewController ,parameters : Parameters?,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.getRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
    func postMultipartReturnVehicle(currentController : UIViewController ,parameters : Parameters,endPoint: String,img: [UIImage],isImage: Bool,isMultipleImg: Bool,imgParameter: String,imgExtension: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequestMultipart(endPoint: endPoint, parameters: parameters,img: img, isImage: isImage, isMultipleImg: isMultipleImg, imgParameter: imgParameter, imgExtension: imgExtension, currentController: currentController)
    }
}


extension ReturnVehicleViewModel : DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        if serviceKey == EndPoints.HIRED_VEHICLE_DROPDOWN_LIST {
            let dict = HiredVehicleDropdownListModel(dict: dictObj)
            print(dict)
            delegate.returnVehicleAPISuccess(objData: dict, strMessage: strMessage)
        }
        
        if serviceKey == EndPoints.RETURN_VEHICLE {
            let dict = ReturnVehicleModel(dict: dictObj)
            print(dict)
            delegate.returnVehicleAPISuccess(objData: dict, strMessage: strMessage)
        }
        if serviceKey == EndPoints.RETURNUPLOADED_DOCS {
            let dict = ReturnUploadedDocsModel(dict: dictObj)
            print(dict)
            delegate.returnVehicleAPISuccess(objData: dict, strMessage: strMessage)
        }
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        if serviceKey == EndPoints.HIRED_VEHICLE_DROPDOWN_LIST, serviceKey == EndPoints.RETURN_VEHICLE ,serviceKey == EndPoints.RETURNUPLOADED_DOCS {
            delegate.returnVehicleAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        }
    }
}

