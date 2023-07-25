//
//  LibraryScreenController.swift
//  MovieApplication
//
//  Created by thanpd on 11/05/2023.
//

import UIKit

class SavedScreen: UIViewController {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var tbMovieLibrary: UITableView!
    @IBOutlet weak var tfSearchLibrary: UITextField!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var imgAccount: UIImageView!
    
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
        tfSearchLibrary.attributedPlaceholder = NSAttributedString(string: "Search in library", attributes: attributes)
        
        tbMovieLibrary.delegate = self
        tbMovieLibrary.dataSource = self
        
        let LibraryMovieNib = UINib(nibName: "LibraryMovieCell", bundle: nil)
        tbMovieLibrary.register(LibraryMovieNib, forCellReuseIdentifier: "LibraryMovieCell")
        tbMovieLibrary.separatorColor = #colorLiteral(red: 0.437958967, green: 0.4267292499, blue: 0.4491886841, alpha: 1)
        
        imgAccount.image = UIImage(named: "person_fill")?.withTintColor(.label)
        
        btnMenu.setBackgroundImage(UIImage(named: "menu")?.withTintColor(.label), for: .normal)
        
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

extension SavedScreen: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
