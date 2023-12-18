//
//  AtFaultDriverDetailsViewModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 24/08/21.
//

import Foundation
import Alamofire
protocol AtFaultDriverDetailsVMDelegate {
    func atFaultDriverDetailsAPISuccess(strMessage: String, serviceKey: String)
    func atFaultDriverDetailsAPISuccess(objData : AtFaultDriverDetailsModel,strMessage: String, serviceKey: String)
    func atFaultDriverDetailsAPISuccess(objData : InsuranceCompanyListModel,strMessage: String, serviceKey: String)
    func atFaultDriverDetailsAPISuccess(objData : StateListModel,strMessage: String,serviceKey: String)
    func atFaultDriverDetailsAPIFailure(strMessage : String,serviceKey: String)
}
class AtFaultDriverDetailsViewModel : NSObject{
    var delegate : AtFaultDriverDetailsVMDelegate! = nil
    func postAtFaultDriverDetails(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
    func getAtFaultDriverDetails(currentController : UIViewController ,parameters : Parameters?,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.getRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
}


extension AtFaultDriverDetailsViewModel : DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.INSURANCE_COMPANY_LIST:
            let dict = InsuranceCompanyListModel(dict: dictObj)
            print(dict.arrResult)
            delegate.atFaultDriverDetailsAPISuccess(objData: dict, strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.STATE_LIST:
            let dict = StateListModel(dict: dictObj)
            print(dict)
            delegate.atFaultDriverDetailsAPISuccess(objData: dict, strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.SAVE_AT_FAULT_DRIVER_DETAILS:
            delegate.atFaultDriverDetailsAPISuccess(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.GET_AT_FAULT_DRIVER_DETAILS:
            let dict = AtFaultDriverDetailsModel(dict: dictObj)
            print(dict)
            delegate.atFaultDriverDetailsAPISuccess(objData: dict, strMessage: strMessage, serviceKey: serviceKey)
        default:
            print("Unknown Service Key")
        }
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.ADD_NEW_ID:
            delegate.atFaultDriverDetailsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.INSURANCE_COMPANY_LIST:
            delegate.atFaultDriverDetailsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.STATE_LIST:
            delegate.atFaultDriverDetailsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.SAVE_AT_FAULT_DRIVER_DETAILS:
            delegate.atFaultDriverDetailsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.GET_AT_FAULT_DRIVER_DETAILS:
            delegate.atFaultDriverDetailsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        default:
            print("Unknown Service Key")
        }
    }
}
