//
//  User.swift
//  FinalProject
//
//  Created by ThanDuc on 30/09/2023.
//

import Foundation

class User {
    
    static var user = UserInfor(name: "", phone_number: "", email: "", userId: "", date_of_birth: "", career: "", address: "", price: "", area: "")
    
    static func getUserInfor(completion: @escaping() -> Void) {
        Constant.userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        
        let requestURL = URL(string: Constant.domain + "final_project/getUserInfor.php")!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"

        let data = "userId=\(Constant.userId)"
        
        request.httpBody = data.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.uploadTask(with: request, from: request.httpBody!) { data, response, error in
            if let response = String(data: data ?? Data(), encoding: .utf8) {
                switch response {
                case "Error":
                    print("Lỗi kết nối, vui lòng kiểm tra lại!")
                default:
                    guard let data = data else { return }
                    guard let infor = try? JSONDecoder().decode([UserInfor].self, from: data) else { return }
                    
                    DispatchQueue.main.async {
                        if !infor.isEmpty {
                            user = infor[0]
                            completion()
                        }
                    }
                }
            }
            
        }
        task.resume()
    }
}
