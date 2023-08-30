//
//  Post.swift
//  FinalProject
//
//  Created by ThanDuc on 08/07/2023.
//

import Foundation
import UIKit

class Post: Codable {
    
    internal init(title: String, price: String, area: String, address: String, dateTime: String, linkImageCover: String? = nil, linkDetail: String, productId: String, userId: String, saved: Bool = false) {
        self.title = title
        self.price = price
        self.area = area
        self.address = address
        self.dateTime = dateTime
        self.linkImageCover = linkImageCover
        self.linkDetail = linkDetail
        self.productId = productId
        self.userId = userId
        self.saved = saved
    }
    
    var title: String
    var price: String
    var area: String
    var address: String
    var dateTime: String
    var linkImageCover: String? = nil
    var linkDetail: String
    var productId: String
    var userId: String
    
    var saved = false
    
    enum CodingKeys: String, CodingKey {
        case title, price, area, address, dateTime, linkImageCover, linkDetail, productId, userId, saved
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        price = try container.decode(String.self, forKey: .price)
        area = try container.decode(String.self, forKey: .area)
        address = try container.decode(String.self, forKey: .address)
        dateTime = try container.decode(String.self, forKey: .dateTime)
        linkImageCover = try container.decodeIfPresent(String.self, forKey: .linkImageCover)
        linkDetail = try container.decode(String.self, forKey: .linkDetail)
        productId = try container.decode(String.self, forKey: .productId)
        userId = try container.decode(String.self, forKey: .userId)
        saved = try container.decodeIfPresent(Bool.self, forKey: .saved) ?? false
    }
    
}

class POST: Codable {
    
    internal init(title: String, price: String, area: String, address: String, dateTime: String, linkImageCover: String = "", linkDetail: String, productId: String, userId: String) {
        self.title = title
        self.price = price
        self.area = area
        self.address = address
        self.dateTime = dateTime
        self.linkImageCover = linkImageCover
        self.linkDetail = linkDetail
        self.productId = productId
        self.userId = userId
    }
    
    var title: String
    var price: String
    var area: String
    var address: String
    var dateTime: String
    var linkImageCover: String = ""
    var linkDetail: String
    var productId: String
    var userId: String
    
}
