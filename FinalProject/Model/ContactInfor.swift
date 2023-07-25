//
//  ContactInfor.swift
//  FinalProject
//
//  Created by ThanDuc on 11/07/2023.
//

import Foundation

class ContactInfor {
    
    internal init(name: String, phoneNumber: String, email: String, userId: String) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
        self.userId = userId
    }
    
    
    var name: String
    var phoneNumber: String
    var email: String
    var userId: String

}
