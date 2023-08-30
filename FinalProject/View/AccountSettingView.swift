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
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var lbGmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func getInfor() {
        let requestURL = URL(string: "http://192.168.1.106/final_project/getUserInfor.php")!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"

        let data = "userId=\(Constant.userId)"
        
        request.httpBody = data.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.uploadTask(with: request, from: request.httpBody!) { data, response, error in
            DispatchQueue.main.async { [self] in
                if let response = String(data: data ?? Data(), encoding: .utf8) {
                    switch response {
                    case "Error":
                        print("Lỗi kết nối, vui lòng kiểm tra lại!")
                        
                    default:
                        guard let data = data else { return }
                        guard let infor = try? JSONDecoder().decode([UserInfor].self, from: data) else { return }
                        
                        DispatchQueue.main.async {
                            if !infor.isEmpty {
                                if let name = infor[0].name {
                                    if name.isEmpty {
                                        labelName.text = "Name"
                                    } else {
                                        labelName.text = name
                                    }
                                }
                                if let gmail = infor[0].email {
                                    if gmail.isEmpty {
                                        lbGmail.text = "Gmail"
                                    } else {
                                        lbGmail.text = gmail
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        }
        task.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        MainScreen.tabbar?.tabBar.isHidden = false
        
        getInfor()
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
    
    @IBAction func btnLogoutClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Đăng xuất", message: "Bạn có chắc muốn đăng xuất không?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { _ in
            MainScreen.hasAccount = false
            Constant.userId = ""
            UserDefaults.standard.set("", forKey: "userId")
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Huỷ bỏ", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnUpdateInforClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UpdateInformationView", bundle: nil)
        let updateScreen = storyboard.instantiateViewController(withIdentifier: "UpdateInformationView")
        self.navigationController?.pushViewController(updateScreen, animated: true)
    }
    
}
