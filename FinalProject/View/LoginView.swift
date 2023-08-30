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
    
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
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

        tfUsername.delegate = self
        tfPassword.delegate = self
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
        uploadDataToPHP()
    }
    
    func uploadDataToPHP() {
        let requestURL = URL(string: "http://192.168.1.106/final_project/login.php")!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        if let username = tfUsername.text, !username.isEmpty,
            let password = tfPassword.text, !password.isEmpty {
            let phoneNumber = "username=\(username)&&password=\(password)"
            request.httpBody = phoneNumber.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.uploadTask(with: request, from: request.httpBody!) { data, response, error in
                DispatchQueue.main.async { [self] in
                    if let response = String(data: data ?? Data(), encoding: .utf8) {
                        switch response {
                        case "Login Failed. Check your connection":
                            lbLoginStatus.text = "Lỗi kết nối, vui lòng kiểm tra lại!"
                        case "Wrong Password":
                            lbLoginStatus.text = "Bạn nhập sai mật khẩu!"
                            
                        case "Invalid Username":
                            lbLoginStatus.text = "Tên tài khoản không tồn tại!"
                            
                        default:
                            lbLoginStatus.text = "Đăng nhập thành công!"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                                MainScreen.hasAccount = true
                                Constant.userId = response
                                UserDefaults.standard.set(response, forKey: "userId")
                                self.dismiss(animated: true, completion: nil)
                            })
                        }
                    }
                }
                
            }
            task.resume()
        } else {
            lbLoginStatus.text = "Bạn nhập thiếu thông tin!"
        }
        
    }
}

extension LoginView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
