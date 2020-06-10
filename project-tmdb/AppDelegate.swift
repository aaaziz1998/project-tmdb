//
//  AppDelegate.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 03/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var userDefaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        userDefaults.setBoolValue(value: false, identifer: .isLogin)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let afterAppDelegate = storyboard.instantiateViewController(withIdentifier: "tabBarViewController")
////        afterAppDelegate?.modalPresentationStyle = .fullScreen
        window?.makeKeyAndVisible()
        window?.rootViewController = afterAppDelegate
        
        
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
//        if userDefaults.getBoolValue(identifier: .isOpenURL){
//            
//            
//        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("You're move to the background")
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        print("Finis Launching ----")
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

