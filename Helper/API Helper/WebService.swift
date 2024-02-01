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
                
                DispatchQueue.main.async {
                    
                    if let mainDict = response.data?.convertData(StatusCodeModel.self){
                        if let data = mainDict as? StatusCodeModel {
                            if data.statusCode == 5001 {
                                if let topController = UIApplication.topViewController() {
                                    topController.showAlertWithAction(title: alert_title, messsage: data.msg ?? "") {
                                        self.logout()
                                    }
                                }
                                return
                            }
                        }
                    }
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
                    let mimeType = ("jpg", "image/jpg")
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
                    if let mainDict = response.data?.convertData(StatusCodeModel.self){
                        if let data = mainDict as? StatusCodeModel {
                            if data.statusCode == 5001 {
                                if let topController = UIApplication.topViewController() {
                                    topController.showAlertWithAction(title: alert_title, messsage: data.msg ?? "") {
                                        self.logout()
                                    }
                                }
                                return
                            }
                        }
                    }
                    
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
    
    // MARK: - PERFORM API CALLS
    func performMultipartWebService(endPoint: String, isMultipleImage: Bool = true, parameters: Parameters, imageData: [Dictionary<String, Any>], complition: @escaping ((Data?, String?) -> Void)) {

        if NetworkReachabilityManager()!.isReachable {
            let url = endPoint

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
                    
                    if isMultipleImage {
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMDDYYYHHmmsss"
                        
                        if let imageData = data["image"] as? [Data] {
                            let mimeType = ("jpg", "image/jpg")
                            imageData.enumerated().forEach({ index, dataa in
                                
                                var strDate = dateFormatter.string(from: Date())
                                strDate = strDate.appendingFormat("_%i", index)

                                multiPart.append(dataa, withName: ((data["title"] as? String ?? "") + "[]"),
                                                 fileName: "\(strDate + "\(Date().timeIntervalSinceNow)").\(mimeType.0)",
                                                 mimeType: mimeType.1)
                            })
                        }
                    } else {
                        if let imageData = data["image"] as? Data {
                            let mimeType = ("jpg", "image/jpg")
                            multiPart.append(imageData, withName: (data["title"] as? String ?? ""),
                                             fileName: "\((data["title"] as? String ?? "") + "\(Date().timeIntervalSinceNow)").\(mimeType.0)",
                                             mimeType: mimeType.1)
                        }
                    }
                    
                })
            }, to: url, method: .post , headers: WebServiceModel().headers){ $0.timeoutInterval = 300 }
            
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                print("Upload Progress: \(progress.fractionCompleted)")
            })
            .response(completionHandler: { (response) in
                switch response.result {
                case .success:
                    if let string = String(data: response.data ?? Data(), encoding: .utf8){
                        print("\n==================== API RESPONSE ====================")
                        print("\nAPI URL (POST) : ", response.request?.url?.absoluteString ?? "")
                        print("\nAPI STATUS CODE: \(response.response?.statusCode ?? 0)")
                        print("\nAPI HEADER: ", response.request?.headers ?? HTTPHeaders())
                        print("\nAPI PARAM: ", parameters)
                        print("\nAPI DATA: ", string)
                        print("\n======================== END =========================\n")
                    }
                    DispatchQueue.main.async {
                        if let mainDict = response.data?.convertData(StatusCodeModel.self){
                            if let data = mainDict as? StatusCodeModel {
                                if data.statusCode == 5001 {
                                    if let topController = UIApplication.topViewController() {
                                        topController.showAlertWithAction(title: alert_title, messsage: data.msg ?? "") {
                                            self.logout()
                                        }
                                    }
                                    return
                                }
                            }
                        }
                        
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

class StatusCodeModel : Codable {
    var statusCode: Int?
    var status: Int?
    var msg: String?
}
