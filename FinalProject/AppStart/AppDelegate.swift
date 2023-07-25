//
//  AppDelegate.swift
//  FinalProject
//
//  Created by ThanDuc on 08/07/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GetFullAddress().getData { success in
            if success {
                GetFullAddress().getFullWardsToCheck()
            }
        }
        
        DispatchQueue.global().async {
            if let url = Bundle.main.url(forResource: "FullCities", withExtension: ".txt") {
                Constant.fullCities = GetFullAddress().readStringsFromFile(fileURL: url) ?? []
            }
            if let url = Bundle.main.url(forResource: "FullCitiesKeywords", withExtension: ".txt") {
                Constant.fullCitiesKeywords = GetFullAddress().readStringsFromFile(fileURL: url) ?? []
            }
            if let url = Bundle.main.url(forResource: "FullDistricts", withExtension: ".txt") {
                Constant.fullDistrics = GetFullAddress().readArrayFromFile(fileURL: url) ?? []
            }
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

