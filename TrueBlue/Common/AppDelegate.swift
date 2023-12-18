//
//  AppDelegate.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 13/08/21.
//

import UIKit
import IQKeyboardManagerSwift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 13, *) {
            //Diksha Rattan:This check is for making loader appear in the center
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        //Diksha Rattan: To prevent issues of keyboard sliding up and cover UITextField/UITextView.
        IQKeyboardManager.shared.enable = true
        //Diksha Rattan:For checking if keyboard is displayed and showing toast accordingly
        KeyboardStateListener.shared.start()
        if !UserDefaults.standard.GetReferenceId().isEmpty{
            UserDefaults.standard.removeReferenceID()
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

