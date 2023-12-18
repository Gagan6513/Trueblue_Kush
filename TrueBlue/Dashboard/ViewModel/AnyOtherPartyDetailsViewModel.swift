//
//  AnyOtherPartyDetailsViewModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 24/08/21.
//

import Foundation
import Alamofire
protocol AnyOtherPartyDetailsVMDelegate {
    func anyOtherPartyDetailsAPISuccess(strMessage: String, serviceKey: String)
    func anyOtherPartyDetailsAPISuccess(objData : AnyOtherPartyDetailsModel,strMessage: String, serviceKey: String)
    func anyOtherPartyDetailsAPISuccess(objData : InsuranceCompanyListModel,strMessage: String, serviceKey: String)
    func anyOtherPartyDetailsAPISuccess(objData : StateListModel,strMessage: String,serviceKey: String)
    func anyOtherPartyDetailsAPIFailure(strMessage : String,serviceKey: String)
}
class AnyOtherPartyDetailsViewModel : NSObject{
    var delegate : AnyOtherPartyDetailsVMDelegate! = nil
    func postAnyOtherPartyDetails(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
    func getAnyOtherPartyDetails(currentController : UIViewController ,parameters : Parameters?,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.getRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
}


extension AnyOtherPartyDetailsViewModel : DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.INSURANCE_COMPANY_LIST:
            let dict = InsuranceCompanyListModel(dict: dictObj)
            print(dict.arrResult)
            delegate.anyOtherPartyDetailsAPISuccess(objData: dict, strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.STATE_LIST:
            let dict = StateListModel(dict: dictObj)
            print(dict)
            delegate.anyOtherPartyDetailsAPISuccess(objData: dict, strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.SAVE_ANY_OTHER_PARTY_DETAILS:
            delegate.anyOtherPartyDetailsAPISuccess(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.GET_ANY_OTHER_PARTY_DETAILS:
            let dict = AnyOtherPartyDetailsModel(dict: dictObj)
            print(dict)
            delegate.anyOtherPartyDetailsAPISuccess(objData: dict, strMessage: strMessage, serviceKey: serviceKey)
        default:
            print("Unknown Service Key")
        }
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.ADD_NEW_ID:
            delegate.anyOtherPartyDetailsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.INSURANCE_COMPANY_LIST:
            delegate.anyOtherPartyDetailsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.STATE_LIST:
            delegate.anyOtherPartyDetailsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.SAVE_ANY_OTHER_PARTY_DETAILS:
            delegate.anyOtherPartyDetailsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.GET_ANY_OTHER_PARTY_DETAILS:
            delegate.anyOtherPartyDetailsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        default:
            print("Unknown Service Key")
        }
    }
}
