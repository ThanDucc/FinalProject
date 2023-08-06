//
//  PriceFilterView.swift
//  FinalProject
//
//  Created by ThanDuc on 26/07/2023.
//

import UIKit

class PriceFilterView: UIView {
    
    @IBOutlet var buttonArray: [UIButton]!
    
    @IBOutlet weak var btnDone: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    private let shadow = UIView()
    private let blur = UIVisualEffectView()
    
    var index = -1 {
        didSet {
            if index != -1 {
                buttonArray[index].isSelected = true
            }
        }
    }
    
    var arrayOfTuples: [(min: Double, max: Double)] = [(0, 1), (1, 3), (3, 5), (5, 10), (10, 1000)]
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        shadow.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        shadow.layer.shadowPath = UIBezierPath(roundedRect: shadow.bounds, cornerRadius: 15).cgPath
        shadow.layer.shadowOffset = CGSize(width: 0, height: 10)
        shadow.layer.shadowOpacity = 0.2
        shadow.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        shadow.layer.shadowRadius = 20
        
        self.insertSubview(shadow, at: 0)
        
        blur.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        blur.effect = UIBlurEffect(style: .prominent)
        blur.layer.cornerRadius = 15
        blur.layer.masksToBounds = true
        
        self.insertSubview(blur, at: 1)
    }
    
    override func awakeFromNib() {
        for button in buttonArray {
            button.setBackgroundImage(UIImage(named: "radiobutton_unchecked")?.withTintColor(UIColor(red: 0.09, green: 0.45, blue: 1, alpha: 1)), for: .normal)
            button.setBackgroundImage(UIImage(named: "radiobutton_checked")?.withTintColor(UIColor(red: 0.09, green: 0.45, blue: 1, alpha: 1)), for: .selected)
        }
        
        setAttributeButton(button: btnDone, string: "Huỷ bỏ")
        setAttributeButton(button: btnCancel, string: "Lọc")

    }
    
    func setAttributeButton(button: UIButton, string: String) {
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 15, weight: .bold), .foregroundColor: UIColor.white]
        
        button.backgroundColor = .systemCyan
        button.setAttributedTitle(NSAttributedString(string: string, attributes: attributes), for: .normal)
        button.layer.cornerRadius = 10
    }

    @IBAction func radioClicked(_ sender: UIButton) {
        for i in 0..<buttonArray.count {
            if buttonArray[i] == sender {
                buttonArray[i].isSelected = true
                index = i
            } else {
                buttonArray[i].isSelected = false
            }
        }
    }
    
    var cancel: (() -> Void)?
    
    var chooseFilter: (((min: Double, max: Double)) -> Void)?
    
    @IBAction func btnDoneClicked(_ sender: Any) {
        cancel?()
        self.removeFromSuperview()
    }
    

    @IBAction func btnCancelClicked(_ sender: Any) {
        if index != -1 {
            chooseFilter?(arrayOfTuples[index])
        }
        self.removeFromSuperview()
    }
    
}
