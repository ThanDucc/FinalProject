//
//  PeopleScreenController.swift
//  MovieApplication
//
//  Created by thanpd on 08/05/2023.
//

import UIKit
//import UPCarouselFlowLayout

class MessageScreen: UIViewController {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var tfSearchPeople: UITextField!
    @IBOutlet weak var clPeopleAvatar: UICollectionView!
    @IBOutlet weak var clPeopleNameTag: UICollectionView!
    @IBOutlet weak var clPeopleImage: UICollectionView!
    @IBOutlet weak var heightConstraintClPeopleImage: NSLayoutConstraint!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var imgAccount: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbBirthday: UILabel!
    @IBOutlet weak var lbDepartment: UILabel!
    @IBOutlet weak var lbPlaceOfBirth: UILabel!
    @IBOutlet weak var lbDescription: UILabel!

    var index = -1
    var reload = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        firstView.layer.cornerRadius = 15
        firstView.setBackground(tabbar: self.tabBarController!)
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.label,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light)
        ]
        tfSearchPeople.attributedPlaceholder = NSAttributedString(string: "Search people", attributes: attributes)
        
        let PeopleNib = UINib(nibName: "PeopleCell", bundle: nil)
        clPeopleAvatar.register(PeopleNib, forCellWithReuseIdentifier: "PeopleCell")
        
        let PeopleNameTagNib = UINib(nibName: "PeopleNameTagCell", bundle: nil)
        clPeopleNameTag.register(PeopleNameTagNib, forCellWithReuseIdentifier: "PeopleNameTagCell")
        
        let PeopleImageNib = UINib(nibName: "PeopleImageCell", bundle: nil)
        clPeopleImage.register(PeopleImageNib, forCellWithReuseIdentifier: "PeopleImageCell")
//        setupFlowLayoutForClPeopleImage()
        
        imgAccount.image = UIImage(named: "logo")
        btnMenu.setBackgroundImage(UIImage(named: "menu")?.withTintColor(.label), for: .normal)
        
//        detailView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationThemeChange), name: Notification.Name("Theme Changed"), object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showManagerAccountDialog(_:)))
        imgAccount.addGestureRecognizer(tapGesture)
        imgAccount.isUserInteractionEnabled = true
        
    }
    
    @objc private func showManagerAccountDialog(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "AccountSettingView", bundle: nil)
        let accSettingVC = storyboard.instantiateViewController(withIdentifier: "AccountSettingView") as! AccountSettingView
        accSettingVC.modalPresentationStyle = .overFullScreen
        accSettingVC.modalTransitionStyle = .crossDissolve
        self.parent!.present(accSettingVC, animated: true)
    }
    
    @objc func notificationThemeChange() {
        firstView.setBackground(tabbar: self.tabBarController!)
    }

}
