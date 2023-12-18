//
//  NotAtFaultDriverDetailsViewModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 24/08/21.
//

import Foundation
import Alamofire
protocol NotAtFaultDriverDetailsVMDelegate {
    func notAtFaultDriverDetailsAPISuccess(dictData: Dictionary<String, Any>, strMessage: String,serviceKey: String)
    func notAtFaultDriverDetailsAPISuccess(objData : NotAtFaultDriverDetailsModel,strMessage: String,serviceKey: String)
    func notAtFaultDriverDetailsAPISuccess(objData : NewReferenceIdModel,strMessage: String,serviceKey: String)
    func notAtFaultDriverDetailsAPISuccess(objData : InsuranceCompanyListModel,strMessage: String, serviceKey: String)
    func notAtFaultDriverDetailsAPISuccess(objData : StateListModel,strMessage: String,serviceKey: String)
    func notAtFaultDriverDetailsAPISuccess(objData : ProposedVehicleModel,strMessage: String,serviceKey: String)
    func notAtFaultDriverDetailsAPISuccess(objData : RepairerListModel,strMessage: String,serviceKey: String)
    func notAtFaultDriverDetailsAPISuccess(objData : ReferralListModel,strMessage: String,serviceKey: String)
    func notAtFaultDriverDetailsAPISuccess(objData : BranchListModel,strMessage: String,serviceKey: String)
    
    func notAtFaultDriverDetailsAPIFailure(strMessage : String,serviceKey: String)
}
class NotAtFaultDriverDetailsViewModel : NSObject{
    var delegate : NotAtFaultDriverDetailsVMDelegate! = nil
    func postNotAtFaultDriverDetails(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
    func getNotAtFaultDriverDetails(currentController : UIViewController ,parameters : Parameters?,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        
        objCallApi.getRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
}


extension NotAtFaultDriverDetailsViewModel : DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.ADD_NEW_ID, EndPoints.ADD_NEW_ENTRY_ID:
            let dict = NewReferenceIdModel(dict: dictObj)
            print(dict)
            delegate.notAtFaultDriverDetailsAPISuccess(objData: dict, strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.PROPOSED_VEHICLE:
            let dict = ProposedVehicleModel(dict: dictObj)
            print(dict)
            delegate.notAtFaultDriverDetailsAPISuccess(objData: dict, strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.INSURANCE_COMPANY_LIST:
            let dict = InsuranceCompanyListModel(dict: dictObj)
            print(dict.arrResult)
            delegate.notAtFaultDriverDetailsAPISuccess(objData: dict, strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.STATE_LIST:
            let dict = StateListModel(dict: dictObj)
            print(dict)
            delegate.notAtFaultDriverDetailsAPISuccess(objData: dict, strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.REPAIRER_LIST:
            let dict = RepairerListModel(dict: dictObj)
            print(dict)
            delegate.notAtFaultDriverDetailsAPISuccess(objData: dict, strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.REFERRAL_LIST:
            let dict = ReferralListModel(dict: dictObj)
            print(dict)
            delegate.notAtFaultDriverDetailsAPISuccess(objData: dict, strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.BRANCH_LIST:
            let dict = BranchListModel(dict: dictObj)
            print(dict)
            delegate.notAtFaultDriverDetailsAPISuccess(objData: dict, strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.SAVE_NOT_AT_FAULT_DRIVER_DETAILS:
            delegate.notAtFaultDriverDetailsAPISuccess(dictData: dictObj, strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.GET_NOT_AT_FAULT_DRIVER_DETAILS:
            let dict = NotAtFaultDriverDetailsModel(dict: dictObj)
            print(dict)
            delegate.notAtFaultDriverDetailsAPISuccess(objData: dict, strMessage: strMessage, serviceKey: serviceKey)
        default:
            print("Unknown Service Key")
        }
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.ADD_NEW_ID:
            delegate.notAtFaultDriverDetailsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.PROPOSED_VEHICLE:
            delegate.notAtFaultDriverDetailsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.INSURANCE_COMPANY_LIST:
            delegate.notAtFaultDriverDetailsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.STATE_LIST:
            delegate.notAtFaultDriverDetailsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.REPAIRER_LIST:
            delegate.notAtFaultDriverDetailsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.SAVE_NOT_AT_FAULT_DRIVER_DETAILS:
            delegate.notAtFaultDriverDetailsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.GET_NOT_AT_FAULT_DRIVER_DETAILS:
            delegate.notAtFaultDriverDetailsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.REFERRAL_LIST:
            delegate.notAtFaultDriverDetailsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.BRANCH_LIST:
            delegate.notAtFaultDriverDetailsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        default:
            print("Unknown Service Key")
        }
    }
}
