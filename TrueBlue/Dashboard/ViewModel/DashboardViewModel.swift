//
//  DashboardViewModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 28/08/21.
//

import Foundation
import Alamofire
protocol DashboardVMDelegate {
    func dashboardAPISuccess(objData : DashboardModel,strMessage: String)
    func dashboardAPISuccess(objData : SearchDashboardModel,strMessage: String)
    func checkStatusAPISuccess(objData : CheckStatusModel,strMessage: String)
    func dashboardAPIFailure(strMessage : String, serviceKey: String)
}
class DashboardViewModel : NSObject{
    var delegate : DashboardVMDelegate! = nil
    func postDashboard(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
    func getDashboard(currentController : UIViewController ,parameters : Parameters?,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.getRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
}


extension DashboardViewModel : DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.DASHBOARD_COUNT:
            let dict = DashboardModel(dict: dictObj)
            print(dict)
            delegate.dashboardAPISuccess(objData: dict, strMessage: strMessage)
        case EndPoints.SEARCH_DASHBOARD:
            let dict = SearchDashboardModel(dict: dictObj)
            print(dict)
            delegate.dashboardAPISuccess(objData: dict, strMessage: strMessage)
        case EndPoints.CHECK_STATUS:
            let dict = CheckStatusModel(dict: dictObj)
            print(dict)
            delegate.checkStatusAPISuccess(objData: dict, strMessage: strMessage)
        default:
            print("Default")
        }
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.DASHBOARD_COUNT,EndPoints.SEARCH_DASHBOARD:
            delegate.dashboardAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        default:
            print("Default")
        }
    }
}
