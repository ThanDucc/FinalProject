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
        
        GetFullAddress().getData()
        
        DispatchQueue.global().async {
            if let url = Bundle.main.url(forResource: "FullCities", withExtension: ".txt") {
                Constant.fullCities = GetFullAddress().readStringsFromFile(fileURL: url) ?? []
            }
            if let url = Bundle.main.url(forResource: "FullDistricts", withExtension: ".txt") {
                Constant.fullDistrics = GetFullAddress().readArrayFromFile(fileURL: url) ?? []
            }
        }
        
        User.getUserInfor {
            RecommendPost.countInteraction { count in
                if count > 5 {
                    if User.user.price == nil || User.user.address == nil || User.user.area == nil {
                        CollaborativeFilter.getRecommend(number: 12, completion: {
                            // Recommend.collaborativePost
                            NotificationCenter.default.post(name: Notification.Name("load collaborative done"), object: nil)
                        })
                        print("collaborative")
                    } else {
                        // have information
                        GetAllPost.getAllPost(completion: {
                            ContentBasedFilter.getRecommend(numberOfRecommend: 6, completion: {
                                NotificationCenter.default.post(name: Notification.Name("load done"), object: nil)
                            })
                        })
            
                        CollaborativeFilter.getRecommend(number: 10, completion: {
                            NotificationCenter.default.post(name: Notification.Name("load done"), object: nil)
                        })
                        print("hybrid")
                    }
                } else {  // less than 5
                    if User.user.price == nil || User.user.address == nil || User.user.area == nil {
                        // less than 5 + no information
                        RecommendPost.getRandomRecommend { postList in
                            RecommendPost.recomendPost = postList
                            NotificationCenter.default.post(name: Notification.Name("load random post done"), object: nil)
                            print("random")
                        }
                    } else {
                        // less than 5 + have information
                        GetAllPost.getAllPost(completion: {
                            ContentBasedFilter.getRecommend(numberOfRecommend: 8, completion: {
                                // Recommend.contentBasedpost
                                NotificationCenter.default.post(name: Notification.Name("load content based done"), object: nil)
                                print("content based")
                            })
                        })
                    }
                }
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

