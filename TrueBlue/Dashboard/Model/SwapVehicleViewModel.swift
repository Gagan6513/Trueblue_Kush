//
//  SwapVehicleViewModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 20/08/21.
//

import Foundation
import Alamofire
protocol SwapVehicleVMDelegate {
    func swapVehicleAPISuccess(objData : HiredVehicleDropdownListModel,strMessage: String)
    func swapVehicleAPISuccess(objData : AvailableVehicleDropDownListModel,strMessage: String)
    func swapVehicleAPISuccess(objData : ReturnUploadedDocsModel , strMessage : String)
    func swapVehicleAPISuccess(strMessage : String, serviceKey: String)
    func swapVehicleAPIFailure(strMessage : String, serviceKey: String)
}
class SwapVehicleViewModel : NSObject{
    var delegate : SwapVehicleVMDelegate! = nil
    func postSwapVehicle(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
    func getSwapVehicle(currentController: UIViewController ,parameters : Parameters?,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.getRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
    
    func postMultipartSwapVehicle(currentController : UIViewController ,parameters : Parameters,endPoint: String, img: [UIImage],isImage: Bool,isMultipleImg: Bool,imgParameter: [String], imgExtension: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequestMultipartWithMultipleParam(endPoint: endPoint, parameters: parameters, img: img, isImage: isImage, isMultipleImg: isMultipleImg, imgParameter: imgParameter, imgExtension: imgExtension, currentController: currentController)
    }
}


extension SwapVehicleViewModel : DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.HIRED_VEHICLE_DROPDOWN_LIST:
            let dict = HiredVehicleDropdownListModel(dict: dictObj)
            print(dict)
            delegate.swapVehicleAPISuccess(objData: dict, strMessage: strMessage)
            
        case EndPoints.AVAILABLE_VEHICLE_DROPDOWN_LIST:
            let dict = AvailableVehicleDropDownListModel(dict: dictObj)
            print(dict)
            delegate.swapVehicleAPISuccess(objData: dict, strMessage: strMessage)
            
        case EndPoints.SWAP_VEHICLE:
            delegate.swapVehicleAPISuccess(strMessage: strMessage, serviceKey: serviceKey)
            
        case EndPoints.RETURNUPLOADED_DOCS:
            let dict = ReturnUploadedDocsModel(dict: dictObj)
            print(dict)
            delegate.swapVehicleAPISuccess(objData: dict, strMessage: serviceKey)
        default:
            print("Unknown Service Key")
        }
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.HIRED_VEHICLE_DROPDOWN_LIST,EndPoints.AVAILABLE_VEHICLE_DROPDOWN_LIST,EndPoints.SWAP_VEHICLE:
            delegate.swapVehicleAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        default:
            print("Unknown Service Ke")
        }
    }
}

