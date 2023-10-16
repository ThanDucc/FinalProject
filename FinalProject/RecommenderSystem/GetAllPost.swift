//
//  GetAllPost.swift
//  FinalProject
//
//  Created by ThanDuc on 08/10/2023.
//

import Foundation

class GetAllPost {
    
    static var allPost: [Post] = []
    
    static func getAllPost(completion: @escaping() -> Void) {
        let requestURL = URL(string: Constant.domain + "final_project/getPostData.php")!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let address = ""
        
        let data = "address=\(address)&&min_price=\(0)&&max_price=\(1000)&&min_area=\(0)&&max_area=\(1000)"
        
        request.httpBody = data.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.uploadTask(with: request, from: request.httpBody!) { data, response, error in
            if let response = String(data: data ?? Data(), encoding: .utf8) {
                switch response {
                case "Error":
                    print("Lỗi kết nối, vui lòng kiểm tra lại!")
                    
                default:
                    let post = try? JSONDecoder().decode([Post].self, from: data ?? Data())
                    DispatchQueue.main.async {
                        allPost = post ?? [Post]()
                        completion()
                    }
                }
            }
        }
        task.resume()
    }
}
