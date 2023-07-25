//
//  AccountSettingView.swift
//  MovieApplication
//
//  Created by thanpd on 22/05/2023.
//

import UIKit

class AccountSettingView: UIViewController {

    @IBOutlet var parentView: UIView!
    @IBOutlet weak var btnManageAccount: UIButton!
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var imgAccount: UIImageView!
    @IBOutlet weak var imgAddAccount: UIImageView!
    @IBOutlet weak var imgLogout: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        let tabBarController = MainScreen.tabbar
        if tabBarController!.overrideUserInterfaceStyle == .dark {
            self.overrideUserInterfaceStyle = .dark
            customView.backgroundColor = #colorLiteral(red: 0.1036594953, green: 0.09714179896, blue: 0.1189824288, alpha: 1)
        } else if tabBarController?.overrideUserInterfaceStyle == .light {
            self.overrideUserInterfaceStyle = .light
        }
        
        customView.layer.cornerRadius = 8
        
        btnManageAccount.layer.cornerRadius = 10
        btnManageAccount.layer.borderWidth = 1
        btnManageAccount.layer.borderColor = #colorLiteral(red: 0.8154367805, green: 0.796557188, blue: 0.8166362047, alpha: 1)
        
        imgAccount.layer.cornerRadius = imgAccount.bounds.width/2
        
        parentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView(_:))))
        
        imgAddAccount.image = UIImage(named: "add_account")?.withTintColor(.label)
        imgLogout.image = UIImage(named: "logout")?.withTintColor(.label)
    }
    
    @objc func dismissView(_ gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
}
