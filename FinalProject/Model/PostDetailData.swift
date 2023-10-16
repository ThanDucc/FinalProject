//
//  PostDetailData.swift
//  FinalProject
//
//  Created by ThanDuc on 09/07/2023.
//

import Foundation
import SwiftSoup
import UIKit

class PostDetailData {
    
    public static var shared = PostDetailData()
    
    var postDetailData: PostDetail?
    var contactInfor: UserInfor?
    
    var listImage: [UIImage] = []
    
    var urlVideo = ""
    
    func getImage(urls: [String], completion: @escaping (Bool) -> Void) {
        self.listImage = []
        
        var count = 0
        for string in urls {
            if let url = URL(string: string) {
                LoadImage.loadImage(url) { image in
                    self.listImage.append(image)
                    
                    count += 1
                    if count == urls.count - 1 {
                        completion(true)
                    }
                }
            } else {
                completion(false)
            }
        }
    }
    
    func getDataDetail(url: URL, completion: @escaping (Bool) -> Void) {
        urlVideo = ""
    
        do {
            let html = try String(contentsOf: url)
            
            let doc = try SwiftSoup.parse(html)
            
            var imageArray: [String] = []
            
            let image = try doc.select(".re__media-thumbs .re__media-thumb-item img")
            for element in image {
                if let imageUrl = try? element.attr("data-src") {
                    imageArray.append(imageUrl.replacingOccurrences(of: "resize/200x200/", with: ""))
                }
            }
            
            let title = try doc.select(".re__pr-title").first()?.text() ?? ""
            let address = try doc.select(".re__pr-short-description").first()?.text() ?? ""
            let price = try doc.select(".re__pr-short-info .title:contains(Mức giá) + .value").first()?.text() ?? ""
            let area = try doc.select(".re__pr-short-info .title:contains(Diện tích) + .value").first()?.text() ?? ""

            let descriptionElement = try doc.select(".re__pr-description .re__section-body").first()
            try descriptionElement?.select("div, span").remove()
            let description = try descriptionElement?.html() ?? ""
            let descriptionDetail = description.replacingOccurrences(of: "<br>", with: "")
            
            let postDateElement = try doc.select(".re__pr-short-info .title:contains(Ngày đăng)").first()?.parent()?.select("span.value").first()?.text() ?? ""
            
            let expirationDate = try doc.select(".re__pr-short-info .title:contains(Ngày hết hạn)").first()?.parent()?.select("span.value").first()?.text() ?? ""

            let postCode = try doc.select(".re__pr-short-info .title:contains(Mã tin)").first()?.parent()?.select("span.value").first()?.text() ?? ""
            
            postDetailData = PostDetail(linkImagesDetail: imageArray, titleDetail: title, addressDetail: address, priceDetail: price, areaDetail: area, descriptionDetail: descriptionDetail, postDate: postDateElement, expirationDate: expirationDate, productId: postCode)
            
            let sellerInfor = extractSellerInfo(from: html)
            let nameSeller = sellerInfor.name
            let mobileSeller = sellerInfor.mobile
            let emailSeller = sellerInfor.email
            let userId = sellerInfor.userID

            contactInfor = UserInfor(name: nameSeller, phone_number: mobileSeller, email: emailSeller, userId: userId)
            
            let component = html.components(separatedBy: "<iframe class=\"lazyload\" id=\"video\" width=\"840\" height=\"473\" data-src=\"")
            
            if component.count > 1 {
                let url = component[1].components(separatedBy: "allow=\"autoplay; encrypted-media\"")
                if url.count > 1 {
                    let u = url[0].components(separatedBy: "?rel=0&showinfo=0&wmode=transparent&enablejsapi=1&version=3&playerapiid=ytplayer")
                    urlVideo = u[0] + "?vq=large"
                }
            }
        
            completion(true)
            
        } catch {
            print("Error parsing HTML: \(error)")
            completion(false)
        }
    }
    
    func extractSellerInfo(from javascript: String) -> (name: String, mobile: String, email: String, userID: String) {
        var name = "", mobile = "", email = "", userID = ""
        
        let namePattern = "nameSeller: '([^']*)'"
        let mobilePattern = "mobileSeller: '([^']*)'"
        let emailPattern = "emailSeller: '([^']*)'"
        let userIDPattern = "userId: (\\d+)"
        
        if let nameRange = javascript.range(of: namePattern, options: .regularExpression),
           let mobileRange = javascript.range(of: mobilePattern, options: .regularExpression),
           let emailRange = javascript.range(of: emailPattern, options: .regularExpression),
           let userIDRange = javascript.range(of: userIDPattern, options: .regularExpression) {
            
            name = String(javascript[nameRange].dropFirst(13).dropLast())
            mobile = String(javascript[mobileRange].dropFirst(15).dropLast())
            email = String(javascript[emailRange].dropFirst(14).dropLast())
            userID = String(javascript[userIDRange].dropFirst(8))
        }
        
        return (name, mobile, email, userID)
    }
    
    func getYoutubeUrl(html: String) {
        do {
            // Tìm kiếm đường dẫn YouTube trong đoạn mã HTML
            let pattern = #"data-src="([^"]+)"[^>]*></iframe>"#
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(location: 0, length: html.utf16.count)
            if let match = regex.firstMatch(in: html, options: [], range: range) {
                if let urlRange = Range(match.range(at: 1), in: html) {
                    let youtubeUrl = String(html[urlRange])
                    print(youtubeUrl)
                }
            }
        } catch {
            print("Lỗi khi tìm kiếm đường dẫn YouTube: \(error)")
        }
    }
    
}

