//
//  LoginRegisterView.swift
//  FinalProject
//
//  Created by ThanDuc on 05/08/2023.
//

import UIKit

class LoginView: UIViewController {

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var customView: UIView!
    
    @IBOutlet weak var lbLoginStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tabBarController = MainScreen.tabbar
        if tabBarController!.overrideUserInterfaceStyle == .dark {
            self.overrideUserInterfaceStyle = .dark
            customView.backgroundColor = #colorLiteral(red: 0.1036594953, green: 0.09714179896, blue: 0.1189824288, alpha: 1)
        } else if tabBarController?.overrideUserInterfaceStyle == .light {
            self.overrideUserInterfaceStyle = .light
        }
        
        parentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView(_:))))

    }
    
    @objc func dismissView(_ gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnRegisterClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "RegisterView", bundle: nil)
        if let registerVC = storyboard.instantiateViewController(withIdentifier: "RegisterView") as? RegisterView {
            registerVC.close = {
                self.dismiss(animated: true, completion: nil)
            }
            self.navigationController?.pushViewController(registerVC, animated: true)
        }
        
    }
    
    @IBAction func btnLoginClicked(_ sender: Any) {
        lbLoginStatus.text = "Đăng nhập thành công!"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            MainScreen.hasAccount = true
            self.dismiss(animated: true, completion: nil)
        })
    }
    
}
