//
//  MovieScreenController.swift
//  MovieApplication
//
//  Created by thanpd on 26/04/2023.
//

import UIKit

class HomeScreen: UIViewController {

    @IBOutlet weak var tfSearchMovie: UITextField!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var imgAccount: UIImageView!
    
    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        collection.register(UINib(nibName: "PostCollectionCell", bundle: nil), forCellWithReuseIdentifier: "PostCollectionCell")
        collection.delegate = self
        collection.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: Notification.Name("load newest successful"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        MainScreen.tabbar?.tabBar.isHidden = false
    }
    
    @objc func handleNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo, let myBoolValue = userInfo["MyBoolValue"] as? Bool {
            if myBoolValue {
                collection.reloadData()
                indicator.stopAnimating()
            }
        }
    }
    
    private func setupUI() {
        let attributes = [
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.0862745098, green: 0.4509803922, blue: 1, alpha: 1),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)
        ]
        tfSearchMovie.attributedPlaceholder = NSAttributedString(string: "ROOM FINDER", attributes: attributes)

        btnMenu.setBackgroundImage(UIImage(named: "menu")?.withTintColor(.label), for: .normal)
        imgAccount.image = UIImage(named: "person")?.withTintColor(.label)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showManagerAccountDialog(_:)))
        imgAccount.addGestureRecognizer(tapGesture)
        imgAccount.isUserInteractionEnabled = true
        
    }
    
    @objc private func showManagerAccountDialog(_ sender: UITapGestureRecognizer) {
        if MainScreen.hasAccount {
            let storyboard = UIStoryboard(name: "AccountSettingView", bundle: nil)
            let accSettingVC = storyboard.instantiateViewController(withIdentifier: "AccountSettingView")
            accSettingVC.modalPresentationStyle = .overFullScreen
            accSettingVC.modalTransitionStyle = .crossDissolve
            self.parent!.present(accSettingVC, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "LoginView", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginView")
            loginVC.modalPresentationStyle = .overFullScreen
            loginVC.modalTransitionStyle = .crossDissolve
            self.parent!.present(loginVC, animated: true)
        }
        
    }
    
}

extension HomeScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PostData.shared.newestData.count > 10 ? 10 : PostData.shared.newestData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionCell", for: indexPath) as? PostCollectionCell {
            cell.lbTitle.text = PostData.shared.newestData[indexPath.row].title
            cell.lbArea.text = PostData.shared.newestData[indexPath.row].area
            cell.lbPrice.text = PostData.shared.newestData[indexPath.row].price
            cell.lbAddress.text = PostData.shared.newestData[indexPath.row].address
            cell.lbDateTime.text = PostData.shared.newestData[indexPath.row].dateTime
            cell.img.image = PostData.shared.newestData[indexPath.row].image
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 45)/2, height: (UIScreen.main.bounds.width - 45)/2/1.25 + 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "PostDetailScreen", bundle: nil)
        let detailScreen = storyboard.instantiateViewController(withIdentifier: "PostDetailScreen") as! PostDetailScreen
        detailScreen.url = URL(string: PostData.shared.newestData[indexPath.row].linkDetail)
        self.navigationController?.pushViewController(detailScreen, animated: true)
    }
    
}
