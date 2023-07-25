//
//  SettingScreenController.swift
//  MovieApplication
//
//  Created by thanpd on 11/05/2023.
//

import UIKit

class SettingScreenController: UIViewController {

    @IBOutlet weak var enableNotiCheckbox: UIButton!
    @IBOutlet weak var lbChooseTheme: UILabel!
    @IBOutlet weak var settingTheme: UIView!
    @IBOutlet weak var lbTheme: UILabel!
    
    private var enableNoti = false {
        didSet {
            if enableNoti {
                enableNotiCheckbox.setBackgroundImage(UIImage(named: "checkbox_checked")?.withTintColor(.label), for: .normal)
            } else {
                enableNotiCheckbox.setBackgroundImage(UIImage(named: "checkbox_unchecked")?.withTintColor(.label), for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
    
        settingTheme.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseThemeClicked(_:))))
        settingTheme.isUserInteractionEnabled = true
                
        NotificationCenter.default.addObserver(self, selector: #selector(notificationThemeChange), name: Notification.Name("Theme Changed"), object: nil)
        
        enableNotiCheckbox.setBackgroundImage(UIImage(named: "checkbox_unchecked")?.withTintColor(.label), for: .normal)
        
        changeTheme()
    }
    
    func changeTheme() {
        switch UserDefaults.standard.string(forKey: "ThemeApp") {
        case "dark":
            lbTheme.text = "Tối"
            break
        default:
            lbTheme.text = "Sáng"
            break
        }
    }
    
    @objc func notificationThemeChange() {
        changeTheme()
    }
    
    @objc func chooseThemeClicked(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "SettingThemeView", bundle: nil)
        let settingThemeVC = storyboard.instantiateViewController(withIdentifier: "SettingThemeView") as! SettingThemeView
        settingThemeVC.modalPresentationStyle = .overFullScreen
        settingThemeVC.modalTransitionStyle = .crossDissolve
        self.parent!.present(settingThemeVC, animated: true)
    }

    @IBAction func btnEnableNotiClicked(_ sender: Any) {
        enableNoti = !enableNoti
    }
    
}
