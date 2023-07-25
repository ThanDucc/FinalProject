//
//  DoubleEx.swift
//  MovieApplication
//
//  Created by thanpd on 23/05/2023.
//

import Foundation

extension Double {
    func convertToRatingStar(number: Double) -> Double {
        if number < 0.5 {
            return 0
        }
        var start = 0.5, end = 1.4, result = 0.5
        while(start < 9.5) {
            if start <= number && number <= end {
                return result
            }
            start += 1; end += 1; result += 0.5
        }
        if number >= 9.5 {
            return 5
        }
        return 0
    }
}
