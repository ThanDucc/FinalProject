//
//  RecommendPost.swift
//  FinalProject
//
//  Created by ThanDuc on 27/09/2023.
//

import Foundation

class RecommendPost {
    
    static var contentBasePost: [Post] = []
    static var collaborativePost: [Post] = []
    
    static var recomendPost: [Post] = []
    
    static func getRecommend(address: String) {
        NotificationCenter.default.addObserver(forName: Notification.Name("load random post done"), object: nil, queue: nil) { _ in
            NotificationCenter.default.post(name: Notification.Name("load recommend successfully"), object: nil)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("load content based done"), object: nil, queue: nil) { _ in
            recomendPost = contentBasePost
            getPostAtAddress(address: address)
            NotificationCenter.default.post(name: Notification.Name("load recommend successfully"), object: nil)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("load collaborative done"), object: nil, queue: nil) { _ in
            recomendPost = collaborativePost
            NotificationCenter.default.post(name: Notification.Name("load recommend successfully"), object: nil)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("load done"), object: nil, queue: nil) { _ in
            if contentBasePost.count + collaborativePost.count == 16 {
                recomendPost = contentBasePost + collaborativePost
                getPostAtAddress(address: address)
                NotificationCenter.default.post(name: Notification.Name("load recommend successfully"), object: nil)
            }
        }
    }
    
    static func countInteraction(completion: @escaping(Int) -> Void) {
        let requestURL = URL(string: Constant.domain + "final_project/getCountInteraction.php")!
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
                    let count = Int(response) ?? 0
                    print(count)
                    completion(count)
                }
            }
            
        }
        task.resume()
    }
    
    static func getRandomRecommend(completion: @escaping([Post]) -> Void) {
        let requestURL = URL(string: Constant.domain + "final_project/getRandomPost.php")!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let response = String(data: data ?? Data(), encoding: .utf8) {
                switch response {
                case "Error":
                    print("Lỗi kết nối, vui lòng kiểm tra lại!")
                default:
                    let postList = try? JSONDecoder().decode([Post].self, from: data ?? Data())
                    completion(postList ?? [])
                }
            }
            
        })
        task.resume()
    }
    
    static func getPostAtAddress(address: String) {
        let requestURL = URL(string: Constant.domain + "final_project/getPostData.php")!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
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
                        getAveragePrice(postList: post ?? [])
                    }
                }
            }
        }
        task.resume()
    }
    
    static func getAveragePrice(postList: [Post]) {
        var totalPrice = 0.0
        var totalArea = 0.0
        
        for post in postList {
            let price = Double(post.price.replacingOccurrences(of: " triệu/tháng", with: "").replacingOccurrences(of: "Giá thoả thuận", with: "").trimmingCharacters(in: .whitespaces).replacingOccurrences(of: ",", with: ".")) ?? 0.0

            let area = Double(post.area.replacingOccurrences(of: " m²", with: "").trimmingCharacters(in: .whitespaces).replacingOccurrences(of: ",", with: ".")) ?? 0.0
            
            totalArea += area
            totalPrice += price
        }
        
        let avgPrice = (round(totalPrice/totalArea*1000)/1000)
        
        print(avgPrice)
        
        var weightArray: [Double] = []
        
        for post in recomendPost {
            let price = Double(post.price.replacingOccurrences(of: " triệu/tháng", with: "").replacingOccurrences(of: "Giá thoả thuận", with: "").trimmingCharacters(in: .whitespaces).replacingOccurrences(of: ",", with: ".")) ?? 0.0

            let area = Double(post.area.replacingOccurrences(of: " m²", with: "").trimmingCharacters(in: .whitespaces).replacingOccurrences(of: ",", with: ".")) ?? 0.0
            
            weightArray.append(avgPrice*area-price)
        }
        
        for i in 0..<weightArray.count {
            for j in 0..<(weightArray.count - i - 1) {
                if weightArray[j] < weightArray[j + 1] {
                    weightArray.swapAt(j, j + 1)
                    recomendPost.swapAt(j, j + 1)
                }
            }
        }

    }
}
