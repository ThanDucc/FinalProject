//
//  PostData.swift
//  FinalProject
//
//  Created by ThanDuc on 08/07/2023.
//

import Foundation
import SwiftSoup
import UIKit

class PostData {
    
    public static var shared = PostData()
    
    var postData: [Post] = []
    
    func fetchDataFromWebsite(url: URL, completion: @escaping (Bool) -> Void) {
        postData.removeAll()
        
        let html = try! String(contentsOf: url)
        
        do {
            let doc: Document = try SwiftSoup.parse(html)
            
            let elements = try doc.select("div.js__card.js__card-full-web")
            for element in elements {
                let title = try element.select("span.pr-title.js__card-title[product-title]").first()?.text() ?? ""
                let price = try element.select("span.re__card-config-price.js__card-config-item").first()?.text() ?? ""
                let area = try element.select("span.re__card-config-area.js__card-config-item").first()?.text() ?? ""
                let location = try element.select("div.re__card-location span").first()?.text() ?? ""
                let link = try element.select(".js__product-link-for-product-id").first()?.attr("href") ?? ""
                let fullLink = "https://batdongsan.com.vn" + link
                let image = try element.select(".re__card-image img").first()?.attr("data-img") ?? ""
                let time = try element.select("span.re__card-published-info-published-at").first()?.attr("aria-label") ?? ""
                let productId = try element.select("a.js__product-link-for-product-id").first()?.attr("data-product-id") ?? ""
                
                if let url = URL(string: image) {
                    if let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
                        postData.append(Post(title: title, price: price, area: area, address: location, dateTime: time, image: image, linkDetail: fullLink, productId: productId))
                    }
                } else {
                    postData.append(Post(title: title, price: price, area: area, address: location, dateTime: time, image: UIImage(named: "noImg")!, linkDetail: fullLink, productId: productId))
                }

            }
            
        completion(true)
            
        } catch {
            print("Error parsing HTML: \(error)")
            completion(false)
        }
        
    }
}
