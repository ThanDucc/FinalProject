//
//  Post.swift
//  FinalProject
//
//  Created by ThanDuc on 08/07/2023.
//

import Foundation
import UIKit

class Post {
    
    internal init(title: String, price: String, area: String, address: String, dateTime: String, image: UIImage, linkDetail: String, productId: String) {
        self.title = title
        self.price = price
        self.area = area
        self.address = address
        self.dateTime = dateTime
        self.image = image
        self.linkDetail = linkDetail
        self.productId = productId
    }
    
    
    var title: String
    var price: String
    var area: String
    var address: String
    var dateTime: String
    var image: UIImage
    var linkDetail: String
    var productId: String
    
}
