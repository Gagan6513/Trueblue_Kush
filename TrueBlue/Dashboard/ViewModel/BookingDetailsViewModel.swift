//
//  BookingDetailsViewModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 23/09/21.
//

import Foundation
import Alamofire
protocol BookingDetailsVMDelegate {
    func bookingDetailsAPISuccess(strMessage: String, serviceKey: String)
    func bookingDetailsAPISuccess(objData : BookingDetailsModel,strMessage: String, serviceKey: String)
    func bookingDetailsAPISuccess(objData : ProposedVehicleModel,strMessage: String, serviceKey: String)
    func bookingDetailsAPIFailure(strMessage : String,serviceKey: String)
}
class BookingDetailsViewModel : NSObject{
    var delegate : BookingDetailsVMDelegate! = nil
    func postBookingDetails(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
    func getProposedVehiclesList(currentController : UIViewController ,parameters : Parameters?) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.getRequest(endPoint: EndPoints.PROPOSED_VEHICLE, parameters: parameters , currentController: currentController)
    }
//    func getBookingDetails(currentController : UIViewController ,parameters : Parameters?,endPoint: String) {
//        let objCallApi = DataSyncManager()
//        objCallApi.delegateDataSync = self
//        objCallApi.getRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
//    }
}


extension BookingDetailsViewModel : DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.GET_BOOKING_DETAILS:
            let dict = BookingDetailsModel(dict: dictObj)
            delegate.bookingDetailsAPISuccess(objData: dict, strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.SAVE_BOOKING_DETAILS:
            delegate.bookingDetailsAPISuccess(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.UPDATE_BOOKING:
            delegate.bookingDetailsAPISuccess(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.PROPOSED_VEHICLE:
            let dict = ProposedVehicleModel(dict: dictObj)
            print(dict)
            delegate.bookingDetailsAPISuccess(objData: dict, strMessage: strMessage, serviceKey: serviceKey)

        default:
            print("Unknown Service Key")
        }
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.SAVE_BOOKING_DETAILS,EndPoints.GET_BOOKING_DETAILS, EndPoints.PROPOSED_VEHICLE:
            delegate.bookingDetailsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        default:
            print("Unknown Service Key")
        }
    }
}
