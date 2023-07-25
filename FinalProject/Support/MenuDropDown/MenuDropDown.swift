//
//  MenuDropDown.swift
//  ResizeImage
//
//  Created by Nam Le on 6/20/21.
//

import UIKit

extension UIViewController {
    
    @discardableResult func menuDropdown(_ texts: [String], _ icons: [UIImage?] = [], sourceView: UIView, status: Bool, type: MenuType) -> MenuDropdown {
        let menu = MenuDropdown()
        menu.texts = texts
        menu.icons = icons
        menu.sourceView = sourceView
        menu.status = status
        menu.type = type
        view.addSubview(menu)
        menu.drawView(self)
        return menu
    }
    
    func openMenu(menu: MenuDropdown, completion: ((Int) -> Void)?) {
        menu.completion = completion
    }
    
}

enum MenuType {
    case def
    case search
    case filt
}

class MenuDropdown: UIView {

    var type = MenuType.def
    var texts: [String] = []
    var icons: [UIImage?] = []
    var sourceView = UIView()
    var completion: ((Int)->Void)?
    var status = false
    
    private let shadow = UIView()
    private let blur = UIVisualEffectView()
    private let scrollView = UIScrollView()
    var buttons: [UIButton] = []
    private var iconViews: [UIImageView] = []
    
    var rect = CGRect.zero
    private var safeArea = CGRect.zero
    private var sourceRect = CGRect.zero
    
    private let iconWidth: CGFloat = 20
    
    func drawView(_ vc: UIViewController) {
        safeArea = vc.view.bounds.inset(by: vc.view.safeAreaInsets).insetBy(dx: 10, dy: 10)
        
        drawView(safeArea)
    }
    
    func drawView(_ safeArea: CGRect) {
        guard let superview = superview else {return}
        sourceRect = sourceView.convert(sourceView.bounds, to: superview)
        
        var w: CGFloat = max(sourceRect.width, 180)
        
        for b in buttons {b.removeFromSuperview()}
        buttons.removeAll()
        for icon in iconViews {icon.removeFromSuperview()}
        iconViews.removeAll()
        
        let color = traitCollection.userInterfaceStyle == .light ? UIColor(white: 0.1, alpha: 1) : UIColor(white: 0.9, alpha: 1)
        
        for i in 0..<texts.count {
            let b = UIButton()
            b.setTitle(texts[i], for: .normal)
            b.setTitleColor(color, for: .normal)
            b.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            b.setTitleColor(UIColor(red: 0.09, green: 0.45, blue: 1, alpha: 1), for: .normal)
            b.contentHorizontalAlignment = .left
            if icons.count > 0 {
                b.contentEdgeInsets = UIEdgeInsets(top: 18, left: 50, bottom: 18, right: 20)
            } else {
                b.contentEdgeInsets = UIEdgeInsets(top: 18, left: 20, bottom: 18, right: 20)
            }
            buttons.append(b)
            w = max(w, b.intrinsicContentSize.width)
            
            b.addTarget(self, action: #selector(buttonTouched(_:)), for: .touchUpInside)
            
            guard icons.count > 0, i < icons.count else {continue}
            let icon = UIImageView(image: icons[i])
            icon.contentMode = .scaleAspectFit
            icon.tintColor = color
            iconViews.append(icon)
        }
        if icons.count > 0 {
            w += iconWidth
        }
        
        var t_y:CGFloat = 0
        for i in 0..<buttons.count {
            scrollView.addSubview(buttons[i])
            buttons[i].frame = CGRect(x: 0, y: t_y, width: w, height: buttons[i].intrinsicContentSize.height)
            var insets = buttons[i].contentEdgeInsets
            insets.right += icons.count > 0 ? iconWidth : 0
            buttons[i].contentEdgeInsets = insets
            t_y += buttons[i].intrinsicContentSize.height
            if i < buttons.count-1 {
                let line = UIView(frame: CGRect(x: 0, y: t_y, width: w, height: 1))
                line.backgroundColor = color.withAlphaComponent(0.1)
                scrollView.addSubview(line)
                t_y += 1
            }
            
            guard icons.count > 0, i < icons.count else {continue}
            iconViews[i].frame = CGRect(x: 20, y: buttons[i].frame.midY, width: iconWidth, height: 0).insetBy(dx: 0, dy: -iconWidth/2)
            scrollView.addSubview(iconViews[i])
        }
        
        let spaceTop = sourceRect.minY - safeArea.minY - 10
        let spaceBottom = safeArea.maxY - sourceRect.maxY - 10
        let space = max(spaceTop, spaceBottom)
        
        var h = 0.0
        if buttons.count > 6 {
            h = buttons[0].frame.height * 5.0 + 4.0
        } else {
            h = min(t_y, space)
        }
        var origin = CGPoint.zero
        
        if type == MenuType.search {
            if status {
                origin = CGPoint(x: sourceRect.minX - 20, y: sourceRect.maxY + 10)
            } else {
                origin = CGPoint(x: sourceRect.maxX + 5, y: sourceRect.minY)
            }
        } else if type == MenuType.filt {
            if status {
                origin = CGPoint(x: sourceRect.minX - 135, y: sourceRect.maxY + 10)
            }
        }
        

        rect = CGRect(origin: origin, size: CGSize(width: w, height: h))
        
        scrollView.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
        scrollView.contentSize = CGSize(width: w, height: t_y)
        scrollView.showsVerticalScrollIndicator = true
        
        blur.frame = rect
        blur.effect = UIBlurEffect(style: .prominent)
        blur.layer.cornerRadius = 15
        blur.layer.masksToBounds = true
        blur.contentView.addSubview(scrollView)
        
        shadow.frame = blur.frame
        shadow.layer.shadowPath = UIBezierPath(roundedRect: shadow.bounds, cornerRadius: 15).cgPath
        shadow.layer.shadowOffset = CGSize(width: 0, height: 10)
        shadow.layer.shadowOpacity = 0.2
        shadow.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        shadow.layer.shadowRadius = 20
        
        addSubview(shadow)
        addSubview(blur)
        
        disappear()
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.curveEaseOut], animations: {
            self.appear()
        }, completion: nil)
        
        frame = superview.bounds
    }
    
    
    @objc func buttonTouched(_ sender: UIButton) {
        if let c = completion {
            c(buttons.firstIndex(of: sender) ?? -1)
        }
    }
    
    func close(_ animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.curveEaseOut], animations: {
                self.disappear()
            }) { _ in
                self.removeFromSuperview()
            }
        } else {
            self.removeFromSuperview()
        }
    }
    
    func disappear() {
        let scaledown:CGFloat = 0.8
        let dx = -(blur.frame.width - blur.frame.width*scaledown)/2
        let dy = -(blur.frame.height - blur.frame.height*scaledown)/2

        blur.transform = CGAffineTransform(scaleX: scaledown, y: scaledown).concatenating(CGAffineTransform(translationX: dx, y: dy))
        blur.alpha = 0
        shadow.alpha = 0
    }
    
    func appear() {
        blur.alpha = 1
        blur.transform = .identity
        shadow.alpha = 1
    }

}
