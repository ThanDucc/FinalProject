//
//  UpdateInformationScreen.swift
//  FinalProject
//
//  Created by ThanDuc on 06/08/2023.
//

import UIKit

class UpdateInformationView: UIViewController {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfBirthOfDate: UITextField!
    @IBOutlet weak var tfCareer: UITextField!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfMinPrice: UITextField!
    @IBOutlet weak var tfMaxPrice: UITextField!
    @IBOutlet weak var tfMinArea: UITextField!
    @IBOutlet weak var tfMaxArea: UITextField!
    @IBOutlet weak var imgAddPhoto: UIImageView!
    
    @IBOutlet weak var lbArea: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tabBarController = MainScreen.tabbar
        if tabBarController!.overrideUserInterfaceStyle == .dark {
            self.overrideUserInterfaceStyle = .dark
        } else if tabBarController?.overrideUserInterfaceStyle == .light {
            self.overrideUserInterfaceStyle = .light
        }
        
        lbArea.text = "m\u{00B2}"
        
        imgAddPhoto.layer.cornerRadius = 8
        imgAddPhoto.layer.borderWidth = 1
        imgAddPhoto.layer.borderColor = UIColor(red: 0.09, green: 0.45, blue: 1, alpha: 1).cgColor
        
        setAttributeTextView(view: tfName)
        setAttributeTextView(view: tfBirthOfDate)
        setAttributeTextView(view: tfCareer)
        setAttributeTextView(view: tfPhoneNumber)
        setAttributeTextView(view: tfEmail)
        setAttributeTextView(view: tfAddress)
        setAttributeTextView(view: tfMinPrice)
        setAttributeTextView(view: tfMaxPrice)
        setAttributeTextView(view: tfMinArea)
        setAttributeTextView(view: tfMaxArea)
        
        tfName.delegate = self
        tfBirthOfDate.delegate = self
        tfCareer.delegate = self
        tfPhoneNumber.delegate = self
        tfEmail.delegate = self
        tfAddress.delegate = self
        tfMinPrice.delegate = self
        tfMaxPrice.delegate = self
        tfMinArea.delegate = self
        tfMaxArea.delegate = self
        
    }
    
    func setAttributeTextView(view: UIView) {
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.8154367805, green: 0.796557188, blue: 0.8166362047, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        MainScreen.tabbar?.tabBar.isHidden = true
    }
    
}

extension UpdateInformationView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
