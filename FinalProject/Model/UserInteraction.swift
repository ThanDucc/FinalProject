//
//  UserInteraction.swift
//  FinalProject
//
//  Created by ThanDuc on 28/09/2023.
//

import Foundation

class UserInteraction: Codable {
    
    internal init(userId: String, productId: String, number_of_click: String, saved: String, contacted: String, rating: String) {
        self.userId = userId
        self.productId = productId
        self.number_of_click = number_of_click
        self.saved = saved
        self.contacted = contacted
        self.rating = rating
    }
    
    var userId: String
    var productId: String
    var number_of_click: String
    var saved: String
    var contacted: String
    var rating: String
}

class GetUserInteraction {
        
    static func calculateRating(numberOfClick: Double, saved: Double, contacted: Double) -> Double {
        let result = 0.04*numberOfClick + 0.46*saved + 0.5*contacted
        
        return round(result*100)/100
    }
    
    static func getUserInteraction(productId: String, completion: @escaping(UserInteraction?) -> Void) {
        let requestURL = URL(string: Constant.domain + "final_project/getUserInteraction.php")!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let data = "userId=\(Constant.userId)&&productId=\(productId)"
        
        request.httpBody = data.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.uploadTask(with: request, from: request.httpBody!) { data, response, error in
            if let response = String(data: data ?? Data(), encoding: .utf8) {
                switch response {
                case "Error":
                    print(error?.localizedDescription ?? "")
                default:
                    do {
                        let userInteraction = try JSONDecoder().decode([UserInteraction].self, from: data ?? Data())
                        DispatchQueue.main.async {
                            if !userInteraction.isEmpty {
                                completion(userInteraction[0])
                            } else {
                                completion(nil)
                            }
                        }
                    } catch {
                        print("Lỗi khi giải mã JSON: \(error)")
                    }
                }
            }
        }
        task.resume()
    }

    static func updateUserInteraction(userInter: UserInteraction) {
        let requestURL = URL(string: Constant.domain + "final_project/updateUserInteraction.php")!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let data = "userId=\(Constant.userId)&&productId=\(userInter.productId)&&number_of_click=\(userInter.number_of_click)&&saved=\(userInter.saved)&&contacted=\(userInter.contacted)&&rating=\(userInter.rating)"
        
        request.httpBody = data.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.uploadTask(with: request, from: request.httpBody!) { data, response, error in
            if let response = String(data: data ?? Data(), encoding: .utf8) {
                switch response {
                case "Error":
                    print(error?.localizedDescription ?? "")
                default:
                    print("update success")
                }
            }
        }
        task.resume()
    }
    
    static func insertUserInteraction(userInter: UserInteraction) {
        let requestURL = URL(string: Constant.domain + "final_project/insertUserInteraction.php")!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let data = "userId=\(Constant.userId)&&productId=\(userInter.productId)&&number_of_click=\(userInter.number_of_click)&&saved=\(userInter.saved)&&contacted=\(userInter.contacted)&&rating=\(userInter.rating)"
        
        request.httpBody = data.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.uploadTask(with: request, from: request.httpBody!) { data, response, error in
            if let response = String(data: data ?? Data(), encoding: .utf8) {
                switch response {
                case "Error":
                    print(error?.localizedDescription ?? "")
                default:
                    print("insert success")
                }
            }
        }
        task.resume()
    }
}

