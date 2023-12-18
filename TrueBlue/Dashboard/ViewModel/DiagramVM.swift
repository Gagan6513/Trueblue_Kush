//
//  DiagramVM.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 09/08/22.
//

import Foundation
import Alamofire

protocol DiagramVMDelegate {
    func success(serviceKey: String, message: String)
    func failure(serviceKey: String, message: String)
}

class DiagramVM: NSObject {
    var delegate: DiagramVMDelegate?
    
    func submitAccidentDiagramAPI(parameters: Parameters, img: [UIImage], isImage: Bool, isMultipleImg: Bool, imgParameter: String, imgExtension: String, controller: UIViewController) {
        let obj = DataSyncManager()
        obj.delegateDataSync = self
        obj.postRequestMultipart(endPoint: EndPoints.SAVE_ACCIDENT_DIAGRAM, parameters: parameters, img: img, isImage: isImage, isMultipleImg: isMultipleImg, imgParameter: imgParameter, imgExtension: imgExtension, currentController: controller)
    }
}

extension DiagramVM: DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey: String, strMessage: String) {
        delegate?.success(serviceKey: serviceKey, message: strMessage)
    }
    
    func requestFailure(serviceKey: String, strMessage: String) {
        delegate?.failure(serviceKey: serviceKey, message: strMessage)
    }
}
