//
//  UploadDocumentsViewModel.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 25/08/21.
//

import Foundation
import Alamofire
protocol UploadDocumentsVMDelegate {
    func uploadDocumentsAPISuccess(strMessage: String, serviceKey: String)
    func uploadDocumentsAPISuccess(objData : UploadDocumentsModel,strMessage: String,serviceKey: String)
    func uploadDocumentsAPISuccess(objData : DocumentListModel,strMessage: String,serviceKey: String)
    func uploadDocumentsAPIFailure(strMessage : String,serviceKey: String)
}
class UploadDocumentsViewModel : NSObject{
    var delegate : UploadDocumentsVMDelegate! = nil
    func postUploadDocuments(currentController : UIViewController ,parameters : Parameters,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
    func getUploadDocuments(currentController : UIViewController ,parameters : Parameters?,endPoint: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.getRequest(endPoint: endPoint, parameters: parameters , currentController: currentController)
    }
    
    func postMultipartUploadDocuments(currentController : UIViewController ,parameters : Parameters,endPoint: String,img: [UIImage],isImage: Bool,isMultipleImg: Bool,imgParameter: String,imgExtension: String) {
        let objCallApi = DataSyncManager()
        objCallApi.delegateDataSync = self
        objCallApi.postRequestMultipart(endPoint: endPoint, parameters: parameters,img: img, isImage: isImage, isMultipleImg: isMultipleImg, imgParameter: imgParameter, imgExtension: imgExtension, currentController: currentController)
    }
}


extension UploadDocumentsViewModel : DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.DOCUMENT_LIST:
            let dict = DocumentListModel(dict: dictObj)
            print(dict.arrResult)
            delegate.uploadDocumentsAPISuccess(objData: dict, strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.UPLOAD_ACCIDENT_PICS:
            delegate.uploadDocumentsAPISuccess(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.DELETE_ACCIDENT_PIC:
            delegate.uploadDocumentsAPISuccess(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.UPLOAD_DOCUMENT,EndPoints.UPLOAD_MULTIPLE_DOCS:
            delegate.uploadDocumentsAPISuccess(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.DELETE_UPLOADED_DOCUMENT:
            delegate.uploadDocumentsAPISuccess(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.UPLOAD_SIGN:
            delegate.uploadDocumentsAPISuccess(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.DELETE_SIGN:
            delegate.uploadDocumentsAPISuccess(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.GET_UPLOADED_DOCUMENTS_TAB_DETAILS:
            let dict = UploadDocumentsModel(dict: dictObj)
            print(dict.dictResult)
            delegate.uploadDocumentsAPISuccess(objData: dict, strMessage: strMessage, serviceKey: serviceKey)
        default:
            print("Unknown Service Key")
        }
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        switch serviceKey {
        case EndPoints.DOCUMENT_LIST:
            delegate.uploadDocumentsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.UPLOAD_ACCIDENT_PICS:
            delegate.uploadDocumentsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.DELETE_ACCIDENT_PIC:
            delegate.uploadDocumentsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.UPLOAD_DOCUMENT,EndPoints.UPLOAD_MULTIPLE_DOCS:
            delegate.uploadDocumentsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.DELETE_UPLOADED_DOCUMENT:
            delegate.uploadDocumentsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.UPLOAD_SIGN:
            delegate.uploadDocumentsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.DELETE_SIGN:
            delegate.uploadDocumentsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        case EndPoints.GET_UPLOADED_DOCUMENTS_TAB_DETAILS:
            delegate.uploadDocumentsAPIFailure(strMessage: strMessage, serviceKey: serviceKey)
        default:
            print("Unknown Service Key")
        }
    }
}
