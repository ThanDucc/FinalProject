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
    
    var post: [POST] = []
    
    func fetchDataFromWebsite(url: URL, url2: URL, minPrice: Double, maxPrice: Double, minArea: Double, maxArea: Double, completion: @escaping (Bool) -> Void) {
        postData.removeAll()
        
        let html = try! String(contentsOf: url)

        do {
            let doc: Document = try SwiftSoup.parse(html)

            if let string = try doc.select("div.re__srp-empty").first()?.text() {
                print(string)
                completion(false)
            } else {
                let elements = try doc.select("div.js__card.js__card-full-web")
                for element in elements {
                    let title = try element.select("span.pr-title.js__card-title[product-title]").first()?.text() ?? ""
                    let price = try element.select("span.re__card-config-price.js__card-config-item").first()?.text() ?? ""
                    let area = try element.select("span.re__card-config-area.js__card-config-item").first()?.text() ?? ""
                    let location = try element.select("div.re__card-location span").first()?.text() ?? ""
                    let link = try element.select(".js__product-link-for-product-id").first()?.attr("href") ?? ""
                    let fullLink = "https://batdongsan.com.vn" + link
                    let imageLink = try element.select(".re__card-image img").first()?.attr("data-img") ?? ""
                    let time = try element.select("span.re__card-published-info-published-at").first()?.attr("aria-label") ?? ""
                    let productId = try element.select("a.js__product-link-for-product-id").first()?.attr("data-product-id") ?? ""
                    let userId = try element.select("div[uid]").attr("uid")
                    
                    if price.convertStringToDouble() >= minPrice && price.convertStringToDouble() <= maxPrice && area.convertStringToDouble() >= minArea && area.convertStringToDouble() <= maxArea {
                        if let url = URL(string: imageLink) {
                            if let imageData = try? Data(contentsOf: url), let _ = UIImage(data: imageData) {
                                postData.append(Post(title: title, price: price, area: area, address: location, dateTime: time, linkDetail: fullLink, productId: productId, userId: userId))
                                post.append(POST(title: title, price: price, area: area, address: location, dateTime: time, linkImageCover: imageLink, linkDetail: fullLink, productId: productId, userId: userId))
                            }
                        } else {
                            postData.append(Post(title: title, price: price, area: area, address: location, dateTime: time, linkDetail: fullLink, productId: productId, userId: userId))
                            post.append(POST(title: title, price: price, area: area, address: location, dateTime: time, linkDetail: fullLink, productId: productId, userId: userId))
                        }
                    }

                }

            }

            let html = try! String(contentsOf: url2)

            do {
                let doc: Document = try SwiftSoup.parse(html)

                if (try doc.select("div.re__srp-empty").first()) != nil {
                    completion(false)
                } else {
                    let elements = try doc.select("div.js__card.js__card-full-web")
                    for element in elements {
                        let title = try element.select("span.pr-title.js__card-title[product-title]").first()?.text() ?? ""
                        let price = try element.select("span.re__card-config-price.js__card-config-item").first()?.text() ?? ""
                        let area = try element.select("span.re__card-config-area.js__card-config-item").first()?.text() ?? ""
                        let location = try element.select("div.re__card-location span").first()?.text() ?? ""
                        let link = try element.select(".js__product-link-for-product-id").first()?.attr("href") ?? ""
                        let fullLink = "https://batdongsan.com.vn" + link
                        let imageLink = try element.select(".re__card-image img").first()?.attr("data-img") ?? ""
                        let time = try element.select("span.re__card-published-info-published-at").first()?.attr("aria-label") ?? ""
                        let productId = try element.select("a.js__product-link-for-product-id").first()?.attr("data-product-id") ?? ""
                        let userId = try element.select("div[uid]").attr("uid")
                        
                        if price.convertStringToDouble() >= minPrice && price.convertStringToDouble() <= maxPrice && area.convertStringToDouble() >= minArea && area.convertStringToDouble() <= maxArea {
                            if let url = URL(string: imageLink) {
                                if let imageData = try? Data(contentsOf: url), let _ = UIImage(data: imageData) {
                                    postData.append(Post(title: title, price: price, area: area, address: location, dateTime: time, linkDetail: fullLink, productId: productId, userId: userId))
                                    post.append(POST(title: title, price: price, area: area, address: location, dateTime: time, linkImageCover: imageLink, linkDetail: fullLink, productId: productId, userId: userId))
                                }
                            } else {
                                postData.append(Post(title: title, price: price, area: area, address: location, dateTime: time, linkDetail: fullLink, productId: productId, userId: userId))
                                post.append(POST(title: title, price: price, area: area, address: location, dateTime: time, linkDetail: fullLink, productId: productId, userId: userId))
                            }
                        }
                    }
                }
            }

            completion(true)

        } catch {
            print("Error parsing HTML: \(error)")
            completion(false)
        }
        
    }
}
