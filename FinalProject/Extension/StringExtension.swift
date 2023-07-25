//
//  File.swift
//  FinalProject
//
//  Created by ThanDuc on 18/07/2023.
//

import Foundation

extension String {
    
    func convertToURLString() -> String {
        let allowedCharacters = CharacterSet(charactersIn: "-_").union(.alphanumerics)
        var lowercasedString = self.lowercased()
        
        lowercasedString = lowercasedString.replacingOccurrences(of: "đ", with: "d")
        
        var result = ""
        let wordArray = lowercasedString.components(separatedBy: .whitespaces)
        
        for (index, word) in wordArray.enumerated() {
            let filteredWord = word.components(separatedBy: allowedCharacters.inverted)
                .joined(separator: "")
            
            if !filteredWord.isEmpty {
                result += filteredWord
                if index != wordArray.count - 1 {
                    result += "-"
                }
            }
        }
        
        return removeDiacritics(result)
    }
    
    func removeDiacritics(_ string: String) -> String {
        let mutableString = NSMutableString(string: string)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripCombiningMarks, false)
        return String(mutableString)
    }

}
