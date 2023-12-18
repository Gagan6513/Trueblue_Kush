//
//  UpcomingBookingListModel.swift
//  TrueBlue
//
//  Created by Inexture Solutions LLP on 17/11/23.
//

import Foundation
import Alamofire

protocol UpcomingBookingListVMDelegate {
    //func deliveredNoteListAPISuccess(strMessage: String, serviceKey: String)
    func UpcomingBookingListAPISuccess(objData : UpcomingBookingDataModel,strMessage: String,serviceKey: String)
    func UpcomingBookingListAPIFailure(strMessage : String,serviceKey: String)
}
class  UpcomingBookingListViewModel : NSObject{
    var delegate : UpcomingBookingListVMDelegate! = nil
    
    func postCollectionNoteDetail(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
    func getCollectionNoteDetail(currentController : UIViewController ,parameters : Parameters?,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.getRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
}


extension UpcomingBookingListViewModel : DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        print(serviceKey)
        let UpcomingBookingListModel = UpcomingBookingDataModel(dict: dictObj)
        switch serviceKey {
        case EndPoints.GET_NEW_UPCOMING_BOOKINGS:
            delegate.UpcomingBookingListAPISuccess(objData: UpcomingBookingListModel, strMessage: strMessage, serviceKey: serviceKey)
            
        default:
            print("Unknown Service Key")
        }
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.GET_NEW_UPCOMING_BOOKINGS:
            delegate.UpcomingBookingListAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
            
        default:
            print("Unknown Service Key")
        }
    }
}
