//
//  ImageViewArrayEx.swift
//  MovieApplication
//
//  Created by thanpd on 23/05/2023.
//

import Foundation
import UIKit

extension Array where Element: UIImageView {
    func setRatingStar(rate: Double) {
        let rating = Double().convertToRatingStar(number: rate)

        var index = 0
        for i in 0 ..< Int(rating) {
            self[i].image = UIImage(named: "star_fill")?.withTintColor(.label)
            index += 1
        }
        if Double(index) < rating {
            self[index].image = UIImage(named: "star_half")?.withTintColor(.label)
            index += 1
        }
        for i in index ..< 5 {
            self[i].image = UIImage(named: "star_outline")?.withTintColor(.label)
        }
    }
}
