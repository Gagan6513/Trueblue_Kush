//
//  CollectionsViewModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 20/08/21.
//

import Foundation
import Alamofire
protocol CollectionsVMDelegate {
    func collectionsAPISuccess(objData : CollectionsModel,strMessage: String)
    func collectionsAPIFailure(strMessage : String, serviceKey: String)
}
class CollectionsViewModel : NSObject{
    var delegate : CollectionsVMDelegate! = nil
    func postCollections(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
    func getCollections(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.getRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
//    func postMultipartCollections(currentController : UIViewController ,parameters : Parameters,endPoint: String,img: UIImage,isImage: Bool,imgParameter: String,imgExtension: String) {
//        let objCallApi = DataSyncManager()
//        objCallApi.delegateDataSync = self
//        objCallApi.postRequestMultipart(endPoint: endPoint, parameters: parameters,img: img, isImage: isImage, imgParameter: imgParameter, imgExtension: imgExtension, currentController: currentController)
//    }
}


extension CollectionsViewModel : DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        if serviceKey == EndPoints.COLLECTION_LIST {
            let dict = CollectionsModel(dict: dictObj)
            print(dict)
            delegate.collectionsAPISuccess(objData: dict, strMessage: strMessage)
        }
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        if serviceKey == EndPoints.COLLECTION_LIST {
            delegate.collectionsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        }
    }
}

