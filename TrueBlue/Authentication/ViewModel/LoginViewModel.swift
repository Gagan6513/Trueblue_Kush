//
//  LoginViewModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 18/08/21.
//

import Foundation
import Alamofire
protocol LoginVMDelegate {
    func LoginAPISuccess(objLoginData : LoginModel,strMessage: String)
    func LoginAPIFailure(strMessage : String, serviceKey: String)
}
class LoginViewModel : NSObject{
    var delegate : LoginVMDelegate! = nil
    func postLogin(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
    func getLogin(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.getRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
//    func postMultipartLogin(currentController : UIViewController ,parameters : Parameters,endPoint: String,img: UIImage,isImage: Bool,imgParameter: String,imgExtension: String) {
//        let objCallApi = DataSyncManager()
//        objCallApi.delegateDataSync = self
//        objCallApi.postRequestMultipart(endPoint: endPoint, parameters: parameters,img: img, isImage: isImage, imgParameter: imgParameter, imgExtension: imgExtension, currentController: currentController)
//    }
}


extension LoginViewModel : DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        if serviceKey == EndPoints.LOGIN {
            let dict = LoginModel(dict: dictObj)
            print(dict)
            delegate.LoginAPISuccess(objLoginData: dict, strMessage: strMessage)
        }
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        if serviceKey == EndPoints.LOGIN {
            delegate.LoginAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        }
    }
}

