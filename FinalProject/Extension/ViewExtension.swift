//
//  UiTextFieldEx.swift
//  MovieApplication
//
//  Created by thanpd on 29/05/2023.
//

import Foundation
import UIKit

extension UIView {
    func setBackground(tabbar: UITabBarController) {
        if tabbar.overrideUserInterfaceStyle == .dark {
            self.backgroundColor = #colorLiteral(red: 0.1921705902, green: 0.192317754, blue: 0.2003935575, alpha: 1)
        } else if tabbar.overrideUserInterfaceStyle == .light {
            self.backgroundColor = #colorLiteral(red: 0.9489255548, green: 0.9414457679, blue: 0.9535239339, alpha: 1)
        }
    }
}
