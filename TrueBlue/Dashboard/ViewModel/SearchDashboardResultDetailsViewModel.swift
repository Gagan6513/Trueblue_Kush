//
//  SearchDashboardResultDetailsViewModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 01/09/21.
//

import Foundation
import Alamofire
protocol SearchDashboardResultDetailsVMDelegate {
    func searchDashboardResultDetailsAPISuccess(objData : SearchDashboardResultDetailsModel,strMessage: String)
    func searchDashboardResultDetailsAPISuccess(strMessage : String, serviceKey: String)
    func searchDashboardResultDetailsAPIFailure(strMessage : String, serviceKey: String)
}
class SearchDashboardResultDetailsViewModel : NSObject{
    var delegate : SearchDashboardResultDetailsVMDelegate! = nil
    func postSearchDashboardResultDetails(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
    func getSearchDashboardResultDetails(currentController: UIViewController ,parameters : Parameters?,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.getRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
}


extension SearchDashboardResultDetailsViewModel : DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.SEARCH_DASHBOARD_RESULT_DETAILS:
            let dict = SearchDashboardResultDetailsModel(dict: dictObj)
            print(dict)
            delegate.searchDashboardResultDetailsAPISuccess(objData: dict, strMessage: strMessage)
        default:
            print("Unknown Service Key")
        }
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.SEARCH_DASHBOARD_RESULT_DETAILS:
            delegate.searchDashboardResultDetailsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        default:
            print("Unknown Service Key")
        }
    }
}

