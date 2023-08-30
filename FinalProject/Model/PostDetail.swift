//
//  PostDetail.swift
//  FinalProject
//
//  Created by ThanDuc on 09/07/2023.
//

import Foundation

class PostDetail {
    
    internal init(linkImagesDetail: [String] = [], titleDetail: String, addressDetail: String, priceDetail: String, areaDetail: String, descriptionDetail: String, postDate: String, expirationDate: String, productId: String) {
        self.linkImagesDetail = linkImagesDetail
        self.titleDetail = titleDetail
        self.addressDetail = addressDetail
        self.priceDetail = priceDetail
        self.areaDetail = areaDetail
        self.descriptionDetail = descriptionDetail
        self.postDate = postDate
        self.expirationDate = expirationDate
        self.productId = productId
    }
    
    var linkImagesDetail: [String] = []
    var titleDetail: String
    var addressDetail: String
    var priceDetail: String
    var areaDetail: String
    var descriptionDetail: String
    var postDate: String
    var expirationDate: String
    var productId: String
    
}
