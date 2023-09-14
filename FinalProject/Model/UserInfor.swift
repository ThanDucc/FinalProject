//
//  ContactInfor.swift
//  FinalProject
//
//  Created by ThanDuc on 11/07/2023.
//

import Foundation

class UserInfor: Codable {
    
    internal init(name: String? = nil, phone_number: String? = nil, email: String? = nil, userId: String? = nil, date_of_birth: String? = nil, career: String? = nil, address: String? = nil, price: String? = nil, area: String? = nil) {
        self.name = name
        self.phone_number = phone_number
        self.email = email
        self.userId = userId
        self.date_of_birth = date_of_birth
        self.career = career
        self.address = address
        self.price = price
        self.area = area
    }

    var name: String?
    var phone_number: String?
    var email: String?
    var userId: String?
    var date_of_birth: String?
    var career: String?
    var address: String?
    var price: String?
    var area: String?

}
