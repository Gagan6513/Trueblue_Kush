//
//  BookingDetailsViewModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 27/08/21.
//

//import Foundation
//import Alamofire
//protocol BookingDetailsVMDelegate {
//    func bookingDetailsAPISuccess(strMessage: String, serviceKey: String)
////    func bookingDetailsAPISuccess(objData : BookingDetailsModel,strMessage: String, serviceKey: String)
//    func bookingDetailsAPIFailure(strMessage : String,serviceKey: String)
//}
//class BookingDetailsViewModel : NSObject{
//    var delegate : BookingDetailsVMDelegate! = nil
//    func postBookingDetails(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
//        let objCallApi = DataSyncManager()
//        objCallApi.delegateDataSync = self
//        objCallApi.postRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
//    }
//    func getBookingDetails(currentController : UIViewController ,parameters : Parameters?,endPoint: String) {
//        let objCallApi = DataSyncManager()
//        objCallApi.delegateDataSync = self
//        objCallApi.getRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
//    }
//}
//
//
//extension BookingDetailsViewModel : DataSyncManagerDelegate {
//    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
//        switch serviceKey {
//        case EndPoints.SAVE_BOOKING_DETAILS:
//            delegate.bookingDetailsAPISuccess(strMessage: strMessage, serviceKey: serviceKey)
//        default:
//            print("Unknown Service Key")
//        }
//    }
//    
//    func requestFailure(serviceKey: String, strMessage: String) {
//        switch serviceKey {
//        case EndPoints.SAVE_BOOKING_DETAILS:
//            delegate.bookingDetailsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
//        default:
//            print("Unknown Service Key")
//        }
//    }
//}
