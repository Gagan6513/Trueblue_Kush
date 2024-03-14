//
//  UserDefaultsHelper.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 19/08/21.
//

import Foundation
extension UserDefaults {
    func setUsername(value: String) {
        set(value, forKey: "email")
        synchronize()
    }
    
    func username() -> String {
        return string(forKey: "email") ?? ""
    }
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: "isLoggedIn")
        synchronize()
    }
    func isLoggedIn() -> Bool {
        return bool(forKey: "isLoggedIn")
    }
    func setUserId(value: String) {
        set(value, forKey: "userId")
        synchronize()
    }
    
    func setUserToken(value: String) {
        set(value, forKey: "userToken")
        synchronize()
    }

    func userId() -> String {
        return string(forKey: "userId") ?? ""
    }
    
    func userToken() -> String {
//        return ""
        return string(forKey: "userToken") ?? ""
    }
    
    func setGroupId(value: String) {
        set(value, forKey: "group_id")
        synchronize()
    }
    func getGroupId() -> String {
        return string(forKey: "group_id") ?? ""
    }
    
    func GetReferenceId() -> String {
        return string(forKey: "referenceID") ?? ""
    }
    
    func setReferenceId(refID: String) {
        setValue(refID, forKey: "referenceID")
        synchronize()
    }
    
    func removeReferenceID(){
        removeObject(forKey: "referenceID")
        synchronize()
    }
    
//    func setCurrentReferenceId(value: String) {
//        set(value, forKey: "currentReferenceId")
//        synchronize()
//    }
//
//    func currentReferenceId() -> String {
//        return string(forKey: "currentReferenceId") ?? ""
//    }
    
//
//    func setFcmToken(value: String) {
//        set(value, forKey: "fcmToken")
//        synchronize()
//    }
//
//    func fcmToken() -> String {
//        return string(forKey: "fcmToken") ?? ""
//    }
//
//    func setEmail(value: String) {
//        set(value, forKey: "email")
//        synchronize()
//    }
//
//    func email() -> String {
//        return string(forKey: "email") ?? ""
//    }

//
//    func setNotificationStatus(value: String) {
//        set(value, forKey: "notificationStatus")
//        synchronize()
//    }
//
//    func notificationStatus() -> String {
//        return string(forKey: "notificationStatus")!
//    }
    
//    func setIsVerified(value: String) {
//        set(value, forKey: "isVerified")
//        synchronize()
//    }
//
//    func isVerified() -> String {
//        return string(forKey: "isVerified") ?? ""
//    }
//
//    func setIsProfileCompleted(value: String) {
//        set(value, forKey: "isProfileCompleted")
//        synchronize()
//    }
//
//    func isProfileCompleted() -> String {
//        return string(forKey: "isProfileCompleted") ?? ""
//    }
}
