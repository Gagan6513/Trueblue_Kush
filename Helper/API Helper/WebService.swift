//
//  PerformWebService.swift
//  RecertMe
//
//  Created by Kushkumar Katira on 26/07/23.
//

import Foundation
import Alamofire

class WebServiceModel {
    
    var url: URL = URL(string: "https://www.google.com")!
    var method: HTTPMethod = .get
    var parameters: [String:Any] = [:]
    var headers: HTTPHeaders?
    
    init() {
        self.headers = HTTPHeaders()
        self.headers?.add(name: "Accept", value: "application/json")
        self.headers?.add(name: "Content-type", value: "application/json")
        self.headers?.add(name: "userId", value: UserDefaults.standard.userId())
        
    }
}

import Foundation

class WebService {
    
    static var shared = WebService()
    
    // MARK: - PERFORM API CALLS
    func performWebService(model: WebServiceModel, complition: @escaping ((Data?, String?) -> Void)) {

        AF.request(model.url, method: model.method, parameters: model.parameters, encoding: JSONEncoding.default, headers: model.headers).response(completionHandler: { (response) in
            switch response.result {
            case .success:
                if let string = String(data: response.data ?? Data(), encoding: .utf8){
                    print("\n==================== API RESPONSE ====================")
                    print("\nAPI URL (\(model.method.rawValue)) : ", response.request?.url?.absoluteString ?? "")
                    print("\nAPI STATUS CODE: \(response.response?.statusCode ?? 0)")
                    print("\nAPI HEADER: ", response.request?.headers ?? HTTPHeaders())
                    print("\nAPI PARAM: ", model.parameters)
                    print("\nAPI DATA: ", string)
                    print("\n======================== END =========================\n")
                }
                
                if let mainDict = response.value as? [String : AnyObject] {
                    print(mainDict)
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
                }
                
                DispatchQueue.main.async {
                    switch response.response?.statusCode {
                    default:
                        complition(response.data ?? Data(), nil)
                    }
                }
            case .failure(let error):
                print(error)
            }
        })
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
    
    // MARK: - PERFORM API CALLS
    func performMultipartWebService(model: WebServiceModel, imageData: [Dictionary<String, Any>], complition: @escaping ((Data?, String?) -> Void)) {

        var convertibleURL = URLRequest(url: model.url)
        convertibleURL.method = model.method
        convertibleURL.headers = model.headers ?? HTTPHeaders()
        
        AF.upload(multipartFormData: { multiPart in
            for (key, value) in model.parameters {
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
                    let mimeType = ("png", "image/png")
                    multiPart.append(imageData, withName: (data["title"] as? String ?? ""),
                                     fileName: "\((data["title"] as? String ?? "") + "\(Date().timeIntervalSinceNow)").\(mimeType.0)",
                                     mimeType: mimeType.1)
                }
            })
        }, with: convertibleURL as URLRequestConvertible)
        .uploadProgress(queue: .main, closure: { progress in
            //Current upload progress of file
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .response(completionHandler: { (response) in
            switch response.result {
            case .success:
                if let string = String(data: response.data ?? Data(), encoding: .utf8){
                    print("\n==================== API RESPONSE ====================")
                    print("\nAPI URL (\(model.method.rawValue)) : ", response.request?.url?.absoluteString ?? "")
                    print("\nAPI STATUS CODE: \(response.response?.statusCode ?? 0)")
                    print("\nAPI HEADER: ", response.request?.headers ?? HTTPHeaders())
                    print("\nAPI PARAM: ", model.parameters)
                    print("\nAPI DATA: ", string)
                    print("\n======================== END =========================\n")
                }
                DispatchQueue.main.async {
                    switch response.response?.statusCode {
                    default:
                        complition(response.data ?? Data(), nil)
                    }
                }
            case .failure(let error):
                print(error)
            }
        })
    }
}

// MARK: - Convert Data
extension Data {
    
    func convertData<T: Decodable>(_ model: T.Type) -> Any {
        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let daata = try decoder.decode(model.self, from: self)
            return daata
        } catch {
            print("JSON FAILED: \(error)")
            return "\(error)"
        }
    }
    
}

extension Encodable {
    
    func toDictionary() -> [String:Any] {
        let jsonData = try! JSONEncoder().encode(self)
        return try! JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
    }
    
}
