//
//  AddHirerViewModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 31/08/21.
//

import Foundation
import Alamofire
protocol AddHirerVMDelegate {
    func addHirerAPISuccess(strMessage : String,serviceKey: String)
    func addHirerAPISuccess(objData: HirerDetailsModel,strMessage : String,serviceKey: String)
    func addHirerAPISuccess(objData: StateListModel,strMessage : String,serviceKey: String)
    func addHirerAPIFailure(strMessage : String, serviceKey: String)
}
class AddHirerViewModel : NSObject{
    var delegate : AddHirerVMDelegate! = nil
    func postAddHirer(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
    func getAddHirer(currentController : UIViewController ,parameters : Parameters?,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.getRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
}


extension AddHirerViewModel : DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.ADD_HIRER:
            delegate.addHirerAPISuccess(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.GET_HIRER_DETAILS:
            let dict = HirerDetailsModel(dict: dictObj)
            delegate.addHirerAPISuccess(objData: dict, strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.STATE_LIST:
            let dict = StateListModel(dict: dictObj)
            delegate.addHirerAPISuccess(objData: dict, strMessage: strMessage, serviceKey: serviceKey)
        default:
            print("Unkown Service Key")
        }
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.ADD_HIRER:
            delegate.addHirerAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.GET_HIRER_DETAILS:
            delegate.addHirerAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.STATE_LIST:
            delegate.addHirerAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        default:
            print("Unkown Service Key")
        }
    }
}

