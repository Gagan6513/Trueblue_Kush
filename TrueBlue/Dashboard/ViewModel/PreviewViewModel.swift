//
//  PreviewViewModel.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 01/03/23.
//

import Foundation
import Alamofire

protocol PreviewVMDelegate {
    func prviewAPISuccess(strMessage: String, serviceKey: String)
    func prviewAPISuccess(objData : PreviewModel,strMessage: String,serviceKey: String)
    func prviewAPIFailure(strMessage : String,serviceKey: String)
}
class PreviewViewModel : NSObject{
    //var webview = UIWebView()
    var dictPreview = PreviewModelData()
    var delegate : PreviewVMDelegate! = nil
    func previewAPI(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
}


extension PreviewViewModel : DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        
        let previewModel = PreviewModel(dict: dictObj)
        dictPreview.data = previewModel.dictResult.data
        print("Hi \(dictPreview)")
        //let value = dictObj["data"] as? String ?? ""
        let url = dictPreview.data
        print(dictPreview)
        switch serviceKey {
        case EndPoints.RA_PREVIEW:
            //delegate.prviewAPISuccess(strMessage: strMessage, serviceKey: serviceKey)
            delegate.prviewAPISuccess(objData: previewModel , strMessage: strMessage, serviceKey: serviceKey)
            
        default:
            print("Unknown Service Key")
        }
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.RA_PREVIEW:
            delegate.prviewAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        
        default:
            print("Unknown Service Key")
        }
    }
}
