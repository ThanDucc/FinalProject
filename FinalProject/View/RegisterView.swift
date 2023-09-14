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
        
        tfEmail.delegate = self
        tfPassword.delegate = self
        tfConfirmPassword.delegate = self
        
    }
    
    func setAttributeTextField(textField: UITextField) {
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = #colorLiteral(red: 0.8154367805, green: 0.796557188, blue: 0.8166362047, alpha: 1)
    }
    
    var close: (() -> Void)?

    @IBAction func btnRegisterClicked(_ sender: Any) {
        uploadDataToPHP()
    }
    
    func uploadDataToPHP() {
        let requestURL = URL(string: Constant.domain + "final_project/register.php")!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        if let username = tfEmail.text, !username.isEmpty,
           let password = tfPassword.text, !password.isEmpty,
           let confirmPass = tfConfirmPassword.text, !confirmPass.isEmpty {
            
            if password != confirmPass {
                lbStatus.text = "Mật khẩu không khớp!"
            } else {
                let phoneNumber = "username=\(username)&&password=\(password)"
                request.httpBody = phoneNumber.data(using: String.Encoding.utf8)
                
                let task = URLSession.shared.uploadTask(with: request, from: request.httpBody!) { data, response, error in
                    DispatchQueue.main.async { [self] in
                        if let response = String(data: data ?? Data(), encoding: .utf8) {
                            switch response {
                            case "Connection Error":
                                lbStatus.text = "Lỗi kết nối, vui lòng kiểm tra lại!"
                                
                            case "Username is used":
                                lbStatus.text = "Tên tài khoản đã tồn tại!"
                                
                            default:
                                lbStatus.text = "Đăng kí thành công!"
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                                    MainScreen.hasAccount = true
                                    Constant.userId = response
                                    UserDefaults.standard.set(response, forKey: "userId")
                                    self.close?()
                                })
                            }
                        }
                    }
                    
                }
                task.resume()
            }
            
        } else {
            lbStatus.text = "Bạn nhập thiếu thông tin!"
        }
        
        
    }
}

extension RegisterView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
