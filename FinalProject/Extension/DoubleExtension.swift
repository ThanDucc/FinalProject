//
//  DoubleExtension.swift
//  FinalProject
//
//  Created by ThanDuc on 26/07/2023.
//

import Foundation

extension String {
    
    func convertStringToDouble() -> Double {
        // Thay thế dấu phẩy bằng dấu chấm
        let cleanedString = self.replacingOccurrences(of: ",", with: ".")

        // Xoá bỏ các ký tự không phải số và dấu chấm
        let numericString = cleanedString.components(separatedBy: CharacterSet(charactersIn: "0123456789.").inverted).joined()

        // Chuyển đổi thành số Double
        if let doubleValue = Double(numericString) {
            // doubleValue sẽ là số 2.5
            return doubleValue
        } else {
            return -1
        }
    }
}
