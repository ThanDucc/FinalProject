//
//  RegisterView.swift
//  FinalProject
//
//  Created by ThanDuc on 05/08/2023.
//

import UIKit

class RegisterView: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var tfConfirmPassword: UITextField!
    
    @IBOutlet weak var lbStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tabBarController = MainScreen.tabbar
        if tabBarController!.overrideUserInterfaceStyle == .dark {
            self.overrideUserInterfaceStyle = .dark
        } else if tabBarController?.overrideUserInterfaceStyle == .light {
            self.overrideUserInterfaceStyle = .light
        }
        
        setAttributeTextField(textField: tfEmail)
        setAttributeTextField(textField: tfPassword)
        setAttributeTextField(textField: tfConfirmPassword)
        
    }
    
    func setAttributeTextField(textField: UITextField) {
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = #colorLiteral(red: 0.8154367805, green: 0.796557188, blue: 0.8166362047, alpha: 1)
    }
    
    var close: (() -> Void)?

    @IBAction func btnRegisterClicked(_ sender: Any) {
        MainScreen.hasAccount = true
        lbStatus.text = "Đăng kí thành công!"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            self.close?()
        })
    }
}
