//
//  HomeController.swift
//  MovieApplication
//
//  Created by thanpd on 26/04/2023.
//

import UIKit

class MainScreen: UITabBarController {

    @IBOutlet weak var mTabbar: UITabBar!
    public static var tabbar: UITabBarController?
    
    public static var hasAccount = false {
        didSet {
            if hasAccount {
                NotificationCenter.default.post(name: Notification.Name("HadAccount"), object: nil)
            } else {
                NotificationCenter.default.post(name: Notification.Name("HadNotAccount"), object: nil)
            }
//            UserDefaults.standard.set(hasAccount, forKey: "hasAccount")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mTabbar.unselectedItemTintColor = .label.withAlphaComponent(0.5)

        switch UserDefaults.standard.string(forKey: "ThemeApp") {
        case "light":
            overrideUserInterfaceStyle = .light
            mTabbar.backgroundColor = #colorLiteral(red: 0.9487966895, green: 0.9302164316, blue: 0.966432631, alpha: 1)
        case "dark":
            overrideUserInterfaceStyle = .dark
            mTabbar.backgroundColor = #colorLiteral(red: 0.1036594953, green: 0.09714179896, blue: 0.1189824288, alpha: 1)
        default:
            overrideUserInterfaceStyle = .unspecified
        }
        setNeedsStatusBarAppearanceUpdate()
        MainScreen.tabbar = self
        
        MainScreen.hasAccount = UserDefaults.standard.bool(forKey: "hasAccount")
        
    }

}

