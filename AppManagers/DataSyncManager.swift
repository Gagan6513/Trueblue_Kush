//
//  DataSyncManager.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 18/08/21.
//

import Foundation
import Alamofire
protocol DataSyncManagerDelegate {
    func requestSuccess(dictObj: Dictionary<String, Any>, serviceKey : String, strMessage: String)
    func requestFailure(serviceKey : String,strMessage: String)
}
class DataSyncManager :NSObject {
    
    var delegateDataSync : DataSyncManagerDelegate?
    func postRequest(endPoint : String ,parameters : Parameters ,currentController : UIViewController){
        print(parameters)
        
        var requestURL = ""
        requestURL = API_PATH + endPoint
        let header: [String: String] = ["userId" : UserDefaults.standard.userId()]
        var newHeader = HTTPHeaders(header)
        
        if endPoint == EndPoints.SWAP_VEHICLE || endPoint == EndPoints.GET_NEW_UPCOMING_BOOKINGS || endPoint == EndPoints.UNDER_MAINTENANCE{
            let newAPIPATH = API_PATH.replacingOccurrences(of: "newapp", with: "app")
             requestURL = newAPIPATH + endPoint
        }
        
        if NetworkReachabilityManager()!.isReachable {
            print(requestURL)
            print(parameters, newHeader)
        
            AF.request(requestURL, method: .post , parameters: parameters, encoding: URLEncoding.httpBody, headers: newHeader){ $0.timeoutInterval = 60 }.responseJSON{ (response) in
                debugPrint(response)
                CommonObject.sharedInstance.stopProgress()
                //Diksha Rattan:Checking for internet connection
                
                if let mainDict = response.value as? [String : AnyObject] {
                    print(mainDict)
                    let status = mainDict["status"] as? Int ?? 0
                    let success = mainDict["success"] as? Int ?? 0
                    let statusCode = mainDict["statusCode"] as? Int ?? 0
                    let message = mainDict["msg"] as? String ?? ""
                    
                    if statusCode == 5001 {
                        currentController.showAlertWithAction(title: alert_title, messsage: message) {
                            self.logout()
                        }
                        return
                    }
                    //Diksha Rattan:checking status
                    if status == 1 || success == 1{
                        let dict = mainDict["data"] as? Dictionary<String, Any> ?? [:]
                        print(dict)
                        let strMsg = mainDict["msg"] as? String ?? ""
                        self.delegateDataSync?.requestSuccess(dictObj: dict, serviceKey: endPoint, strMessage: strMsg)
                    } else {
                        // for status = 0
                        //print(response.error?.errorDescription)
                        CommonObject.sharedInstance.stopProgress()
                        let errorMsg = mainDict["msg"] as? String ?? ""
                        print(errorMsg)
                        self.delegateDataSync?.requestFailure(serviceKey: endPoint, strMessage: errorMsg)
                    }
                } else {
                    //Diksha Rattan:Api Failure Response
                    CommonObject.sharedInstance.stopProgress()
                    currentController.showAlert(title: alert_title, messsage: somethingWrong)
                }
            }
        } else {
            //Diksha Rattan:No internet
            CommonObject.sharedInstance.stopProgress()
            currentController.showAlert(title: alert_title, messsage: noInternet)
        }
    }
    
    func logout(){
        var vcId = String()
        if UIDevice.current.userInterfaceIdiom == .pad {
            vcId = AppStoryboardId.LOGIN
        } else {
            vcId = AppStoryboardId.LOGIN_PHONE
        }
        self.clearUserDefaults()
        let vc = UIStoryboard(name: AppStoryboards.MAIN, bundle: Bundle.main).instantiateViewController(withIdentifier: vcId)
        vc.modalPresentationStyle = .fullScreen
        if let topController = UIApplication.topViewController() {
            topController.present(vc, animated: true, completion: nil)
        }
    }
    
    func clearUserDefaults() {
        UserDefaults.standard.setUsername(value: "")
        UserDefaults.standard.setIsLoggedIn(value: false)
        UserDefaults.standard.setUserId(value: "")
    }
    
    func getRequest(endPoint : String,  parameters : Parameters?, currentController : UIViewController) {
        print(parameters)
        let requestURL = API_PATH + endPoint
        let header: [String: String] = ["userId" : UserDefaults.standard.userId()]
        var newHeader = HTTPHeaders(header)
        
        if NetworkReachabilityManager()!.isReachable {
            AF.request(requestURL , method: .get, parameters: parameters, encoding: URLEncoding.httpBody, headers: newHeader) { $0.timeoutInterval = 60 }.responseJSON { (response) in
                debugPrint(response)
                print(requestURL)
                print(parameters)
                CommonObject.sharedInstance.stopProgress()
                if let mainDict = response.value as? [String : AnyObject] {
                    print(mainDict)
                    let status = mainDict["status"] as? Int ?? 0
                    let statusCode = mainDict["statusCode"] as? Int ?? 0
                    let message = mainDict["msg"] as? String ?? ""
                    
                    if statusCode == 5001 {
                        currentController.showAlertWithAction(title: alert_title, messsage: message) {
                            self.logout()
                        }
                        return
                    }
                    
                    if status == 1{
                        CommonObject.sharedInstance.stopProgress()
                        
                        let dict = mainDict["data"] as? Dictionary<String, Any> ?? [:]
                        print(dict)
                        
                        
                        let strMsg = mainDict["msg"] as? String ?? ""
                        self.delegateDataSync?.requestSuccess(dictObj: dict, serviceKey: endPoint, strMessage: strMsg)
                    } else {
                        CommonObject.sharedInstance.stopProgress()
                        let errorMsg = mainDict["msg"] as? String ?? ""
                        print(errorMsg)
                        self.delegateDataSync?.requestFailure(serviceKey: endPoint, strMessage: errorMsg)
                    }
                } else{
                    //Diksha Rattan:Api Failure Response
                    CommonObject.sharedInstance.stopProgress()
                    currentController.showAlert(title: alert_title, messsage: somethingWrong)
                }
            }
        } else {
            //Diksha Rattan: No Internet
            CommonObject.sharedInstance.stopProgress()
            currentController.showAlert(title: alert_title, messsage: noInternet)
        }
    }
    
    
    func postRequestMultipart(endPoint: String, parameters: Parameters, img: [UIImage], isImage: Bool,isMultipleImg: Bool,imgParameter : String,imgExtension: String,currentController : UIViewController) {
        print(parameters)
        if NetworkReachabilityManager()!.isReachable {
            let url = API_PATH + endPoint
            print(parameters)
            AF.upload(multipartFormData: { multipartFormData in
                if isImage{
                    
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMDDYYYHHmmsss"
                    
                    print(img.count)
                    if isMultipleImg {
                        for i in 0...img.count-1 {
                            
                            var strDate = dateFormatter.string(from: date)
                            strDate = strDate.appendingFormat("_%i", i)
                            print(strDate)
                            
                            let data = img[i].jpegData(compressionQuality: 0.7)!
                            print(data)
                            
                            print(img[i].size.width)
                            print(img[i].size.height)
                            multipartFormData.append(data, withName: "\(imgParameter)[]" , fileName: strDate + "." + imgExtension, mimeType: "image/\(imgExtension)")
                        }
                    } else {
                        
                        let strDate = dateFormatter.string(from: date)
                        print(strDate)
                        
                        let data = img[0].jpegData(compressionQuality: 0.1)!// this is 0.7 before
                        print(data)
                        
                        print(img[0].size.width)
                        print(img[0].size.height)
                        
                        multipartFormData.append(data, withName: imgParameter , fileName: strDate + "." + imgExtension, mimeType: "image/\(imgExtension)")
                    }
                   
                }
                for (key, value) in parameters {
                    if let arr = parameters[key] as? [String] {
                        //Diksha Rattan:For sending array in parameter
                        print(arr)
                        if arr.count > 0 {
                            for i in 0...arr.count-1 {
                                multipartFormData.append((arr[i] as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: "\(key)[]")
                            }
                        }
                    } else {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                }
                
            }, to: url, method: .post , headers: nil){ $0.timeoutInterval = 300 }.responseJSON { resp in
                debugPrint(resp)
                print(resp)
                if let mainDict = resp.value as? [String : AnyObject] {
                    let status = mainDict["status"] as? Int ?? 0
                    
                    let statusCode = mainDict["statusCode"] as? Int ?? 0
                    let message = mainDict["msg"] as? String ?? ""
                    
                    if statusCode == 5001 {
                        if let topController = UIApplication.topViewController() {
                            topController.showAlertWithAction(title: alert_title, messsage: message) {
                                self.logout()
                            }
                        }
                        
                        return
                    }
                    
                    if status == 1 {
                        CommonObject.sharedInstance.stopProgress()
                        let dict = mainDict["data"] as? Dictionary<String, Any> ?? [:]
                        print(dict)
                        let strMsg = mainDict["msg"] as? String ?? ""
                        self.delegateDataSync?.requestSuccess(dictObj: dict, serviceKey: endPoint, strMessage: strMsg)
                    } else {
                        CommonObject.sharedInstance.stopProgress()
                        let errorMsg = mainDict["msg"] as? String ?? ""
                        print(errorMsg)
                        self.delegateDataSync?.requestFailure(serviceKey: endPoint, strMessage: errorMsg)
                    }
                } else {
                    //Diksha Rattan:Api Failure Response
                    CommonObject.sharedInstance.stopProgress()
                    currentController.showAlert(title: alert_title, messsage: somethingWrong)
                }
            }
        } else {
            //Diksha Rattan: No Internet
            CommonObject.sharedInstance.stopProgress()
            currentController.showAlert(title: alert_title, messsage: noInternet)
        }
    }
    
    func postRequestMultipartWithMultipleParam(endPoint: String, parameters: Parameters, img: [UIImage], isImage: Bool,isMultipleImg: Bool,imgParameter : [String], imgExtension: String,currentController : UIViewController) {
        print(parameters)
        if NetworkReachabilityManager()!.isReachable {
            let url = new_path + endPoint
            print(parameters)
            AF.upload(multipartFormData: { multipartFormData in
                if isImage {
                    
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMDDYYYHHmmsss"
                    
                    print(img.count)
                    if isMultipleImg {
                        for i in 0...(img.count - 1) {
                            
                            var strDate = dateFormatter.string(from: date)
                            strDate = strDate.appendingFormat("_%i", i)
                            print(strDate)
                            
                            let data = img[i].jpegData(compressionQuality: 0.7)!
                            print(data)
                            
                            print(img[i].size.width)
                            print(img[i].size.height)
                            multipartFormData.append(data, withName: imgParameter[i] , fileName: strDate + "." + imgExtension, mimeType: "image/\(imgExtension)")
                        }
                    } else {
                        
                        let strDate = dateFormatter.string(from: date)
                        print(strDate)
                        
                        let data = img[0].jpegData(compressionQuality: 0.7)!// this is 0.7 before
                        print(data)
                        
                        print(img[0].size.width)
                        print(img[0].size.height)
                        
                        multipartFormData.append(data, withName: imgParameter[0] , fileName: strDate + "." + imgExtension, mimeType: "image/\(imgExtension)")
                    }
                }
                for (key, value) in parameters {
                    if let arr = parameters[key] as? [String] {
                        //Diksha Rattan:For sending array in parameter
                        print(arr)
                        if arr.count > 0 {
                            for i in 0...arr.count-1 {
                                multipartFormData.append((arr[i] as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: "\(key)[]")
                            }
                        }
                    } else {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                }
                
            }, to: url, method: .post , headers: nil){ $0.timeoutInterval = 300 }.responseJSON { resp in
                debugPrint(resp)
                print(resp)
                if let mainDict = resp.value as? [String : AnyObject] {
                    let status = mainDict["status"] as? Int ?? 0
                    
                    let statusCode = mainDict["statusCode"] as? Int ?? 0
                    let message = mainDict["msg"] as? String ?? ""
                    
                    if statusCode == 5001 {
                        if let topController = UIApplication.topViewController() {
                            topController.showAlertWithAction(title: alert_title, messsage: message) {
                                self.logout()
                            }
                        }
                        
                        return
                    }
                    
                    if status == 1 {
                        CommonObject.sharedInstance.stopProgress()
                        let dict = mainDict["data"] as? Dictionary<String, Any> ?? [:]
                        print(dict)
                        let strMsg = mainDict["msg"] as? String ?? ""
                        self.delegateDataSync?.requestSuccess(dictObj: dict, serviceKey: endPoint, strMessage: strMsg)
                    } else {
                        CommonObject.sharedInstance.stopProgress()
                        let errorMsg = mainDict["msg"] as? String ?? ""
                        print(errorMsg)
                        self.delegateDataSync?.requestFailure(serviceKey: endPoint, strMessage: errorMsg)
                    }
                } else {
                    //Diksha Rattan:Api Failure Response
                    CommonObject.sharedInstance.stopProgress()
                    currentController.showAlert(title: alert_title, messsage: somethingWrong)
                }
            }
        } else {
            //Diksha Rattan: No Internet
            CommonObject.sharedInstance.stopProgress()
            currentController.showAlert(title: alert_title, messsage: noInternet)
        }
    }
    
    
//    func getRequestException(endPoint : String,  parameters : Parameters?, currentController : UIViewController) {
//        print(parameters)
//        if NetworkReachabilityManager()!.isReachable {
//            let requestURL = API_PATH + endPoint
//            AF.request(requestURL , method: .get, parameters: nil, encoding: URLEncoding.httpBody){ $0.timeoutInterval = 60 } .responseJSON { (response) in
//                print(response)
//                debugPrint(response)
//                CommonObject.sharedInstance.stopProgress()
//
//                if let mainDict = response.value as? [String : AnyObject] {
//                    print(mainDict)
//                    let status = mainDict["status"] as? Int ?? 0
//                    if status == 1{
//                        CommonObject.sharedInstance.stopProgress()
//                        let dict = mainDict["data"] as? Dictionary<String, Any> ?? [:]
//                        print(dict)
//
//                        let strMsg = mainDict["msg"] as? String ?? ""
//                        self.delegateDataSync?.requestSuccess(dictObj: dict, serviceKey: endPoint, strMessage: strMsg)
//                    } else {
//                        CommonObject.sharedInstance.stopProgress()
//                        let errorMsg = mainDict["msg"] as? String  ?? ""
//                        print(errorMsg)
//                        self.delegateDataSync?.requestFailure(serviceKey: endPoint, strMessage: errorMsg)
//                    }
//                } else{
//                    //Diksha Rattan:Api Failure Response
//                    CommonObject.sharedInstance.stopProgress()
//                    currentController.showAlert(title: APP_NAME, messsage: somethingWrong)
//                }
//            }
//        } else {
//            //Diksha Rattan: No Internet
//            CommonObject.sharedInstance.stopProgress()
//            currentController.showAlert(title: APP_NAME, messsage: noInternet)
//        }
//
//    }
}

extension DataSyncManager {
    
    // MARK: - PERFORM API CALLS
    func performMultipartWebService(endPoint: String, parameters: Parameters, imageData: [Dictionary<String, Any>],currentController : UIViewController) {

        if NetworkReachabilityManager()!.isReachable {
            let url = new_path + endPoint

            AF.upload(multipartFormData: { multiPart in
                for (key, value) in parameters {
                    if let temp = value as? String {
                        multiPart.append(temp.data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? Int {
                        multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                imageData.forEach({ data in
                    if let imageData = data["image"] as? Data {
                        let mimeType = ("jpg", "image/jpg")
                        multiPart.append(imageData, withName: (data["title"] as? String ?? ""),
                                         fileName: "\((data["title"] as? String ?? "") + "\(Date().timeIntervalSinceNow)").\(mimeType.0)",
                                         mimeType: mimeType.1)
                    }
                })
            }, to: url, method: .post , headers: nil)
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                print("Upload Progress: \(progress.fractionCompleted)")
            })
            .responseJSON(completionHandler: { (response) in
                print(response)
                if let mainDict = response.value as? [String : AnyObject] {
                    let status = mainDict["status"] as? Int ?? 0
                    let statusCode = mainDict["statusCode"] as? Int ?? 0
                    let message = mainDict["msg"] as? String ?? ""
                    
                    if statusCode == 5001 {
                        if let topController = UIApplication.topViewController() {
                            topController.showAlertWithAction(title: alert_title, messsage: message) {
                                self.logout()
                            }
                        }
                        
                        return
                    }
                    if status == 1 {
                        CommonObject.sharedInstance.stopProgress()
                        let dict = mainDict["data"] as? Dictionary<String, Any> ?? [:]
                        print(dict)
                        let strMsg = mainDict["msg"] as? String ?? ""
                        self.delegateDataSync?.requestSuccess(dictObj: dict, serviceKey: endPoint, strMessage: strMsg)
                    } else {
                        CommonObject.sharedInstance.stopProgress()
                        let errorMsg = mainDict["msg"] as? String ?? ""
                        print(errorMsg)
                        self.delegateDataSync?.requestFailure(serviceKey: endPoint, strMessage: errorMsg)
                    }
                } else {
                    //Diksha Rattan:Api Failure Response
                    CommonObject.sharedInstance.stopProgress()
                    showGlobelAlert(title: alert_title, msg: somethingWrong)
                }
            })
        }
    }
    
}
