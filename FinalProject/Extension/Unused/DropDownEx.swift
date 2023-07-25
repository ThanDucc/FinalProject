////
////  DropDownEx.swift
////  MovieApplication
////
////  Created by thanpd on 19/05/2023.
////
//
//import Foundation
//import DropDown
//
//extension DropDown {
//    func initProperties(view: UIView, tabbar: UITabBarController) -> DropDown {
//        let menuLabel = ["Add to the library", "Mark the movie as favourite"]
//        let menuImage = ["add_lib", "favourite"]
//        self.cornerRadius = 5
//        self.separatorColor = #colorLiteral(red: 0.4875, green: 0.475, blue: 0.5, alpha: 1)
//        self.anchorView = view
//        self.bottomOffset = CGPoint(x: 0, y: view.bounds.height)
//        self.cellNib = UINib(nibName: "MenuCell", bundle: nil)
//        self.dataSource = menuLabel
//        self.cellHeight = 52.5
//        self.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
//            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//            guard let cell = cell as? MenuCell else { return }
//            cell.lbMenu.font = UIFont.systemFont(ofSize: 13.5)
//            cell.imgMenu.image = UIImage(named: menuImage[Int(index)])?.withTintColor(.label)
//        }
//        self.textColor = .label
//        if tabbar.overrideUserInterfaceStyle == .dark {
//            self.backgroundColor = #colorLiteral(red: 0.1921705902, green: 0.192317754, blue: 0.2003935575, alpha: 1)
//            self.selectionBackgroundColor = .darkGray
//            self.overrideUserInterfaceStyle = .dark
//        } else if tabbar.overrideUserInterfaceStyle == .light {
//            self.overrideUserInterfaceStyle = .light
//            self.backgroundColor = #colorLiteral(red: 0.9020807243, green: 0.884843513, blue: 0.9193179356, alpha: 1)
//        }
//
//        return self
//    }
//}
