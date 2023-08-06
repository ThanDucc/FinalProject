//
//  SettingThemeView.swift
//  Movie Application
//
//  Created by ThanDuc on 26/05/2023.
//

import UIKit

class SettingThemeView: UIViewController {

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var btnDarkTheme: UIButton!
    @IBOutlet weak var btnLightTheme: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        customView.layer.cornerRadius = 8
        parentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView(_:))))
        
        checkAndUpdate()
    }
    
    @objc func dismissView(_ gesture: UITapGestureRecognizer) {
        dismissView()
    }
    
    func setup() {
        let tabBarController = MainScreen.tabbar
        if tabBarController!.overrideUserInterfaceStyle == .dark {
            self.overrideUserInterfaceStyle = .dark
            customView.backgroundColor = #colorLiteral(red: 0.1036594953, green: 0.09714179896, blue: 0.1189824288, alpha: 1)
        } else if tabBarController?.overrideUserInterfaceStyle == .light {
            self.overrideUserInterfaceStyle = .light
            customView.backgroundColor = #colorLiteral(red: 0.9487966895, green: 0.9302164316, blue: 0.966432631, alpha: 1)
        }
    }
    
    @IBAction func btnDarkThemeClicked(_ sender: Any) {
        UserDefaults.standard.setValue("dark", forKey: "ThemeApp")
        MainScreen.tabbar!.overrideUserInterfaceStyle = .dark
        change()
    }
    
    @IBAction func btnLightThemeClicked(_ sender: Any) {
        UserDefaults.standard.setValue("light", forKey: "ThemeApp")
        MainScreen.tabbar!.overrideUserInterfaceStyle = .light
        change()
    }
    
    func change() {
        setup()
        
        MainScreen.tabbar?.viewDidLoad()
        NotificationCenter.default.post(name: Notification.Name("Theme Changed"), object: nil)
        
        checkAndUpdate()
    }
    
    func checkAndUpdate() {
        btnDarkTheme.setBackgroundImage(UIImage(named: "radiobutton_unchecked")?.withTintColor(.label), for: .normal)
        btnLightTheme.setBackgroundImage(UIImage(named: "radiobutton_unchecked")?.withTintColor(.label), for: .normal)
        
        switch UserDefaults.standard.string(forKey: "ThemeApp") {
        case "dark":
            btnDarkTheme.setBackgroundImage(UIImage(named: "radiobutton_checked")?.withTintColor(.label), for: .normal)
            break
        case "light":
            btnLightTheme.setBackgroundImage(UIImage(named: "radiobutton_checked")?.withTintColor(.label), for: .normal)
            break
        default:
            btnLightTheme.setBackgroundImage(UIImage(named: "radiobutton_checked")?.withTintColor(.label), for: .normal)
            break
        }
    }
    
    @IBAction func btnConfirmClicked(_ sender: Any) {
        dismissView()
    }
    
    func dismissView() {
        self.dismiss(animated: true)
    }
}
