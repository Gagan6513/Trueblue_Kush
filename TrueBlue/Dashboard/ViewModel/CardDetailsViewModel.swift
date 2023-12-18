//
//  CardDetailsViewModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 23/09/21.
//

import Foundation
import Alamofire
protocol CardDetailsVMDelegate {
    func cardDetailsAPISuccess(strMessage : String, serviceKey: String)
    func cardDetailsAPIFailure(strMessage : String, serviceKey: String)
}
class CardDetailsViewModel : NSObject{
    var delegate : CardDetailsVMDelegate! = nil
    func postCardDetails(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
}


extension CardDetailsViewModel : DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.SAVE_CARD_DETAILS:
            delegate.cardDetailsAPISuccess(strMessage: strMessage, serviceKey: serviceKey)
        default:
            print("Unknown Service Key")
        }
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.SAVE_CARD_DETAILS:
            delegate.cardDetailsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        default:
            print("Unknown Service Key")
        }
    }
}

