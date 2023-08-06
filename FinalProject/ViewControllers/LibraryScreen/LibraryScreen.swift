//
//  LibraryScreenController.swift
//  MovieApplication
//
//  Created by thanpd on 11/05/2023.
//

import UIKit

class LibraryScreen: UIViewController {

    @IBOutlet weak var tbMyPost: UITableView!
    
    @IBOutlet weak var clMyPost: UICollectionView!
    
    @IBOutlet weak var heightConstraintCollection: NSLayoutConstraint!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        MainScreen.tabbar?.tabBar.isHidden = false
    }
    
    private func setupUI() {
        
        heightConstraintCollection.constant = (UIScreen.main.bounds.width - 45)/2/1.25 + 150

        tbMyPost.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        tbMyPost.delegate = self
        tbMyPost.dataSource = self
        
        clMyPost.register(UINib(nibName: "PostCollectionCell", bundle: nil), forCellWithReuseIdentifier: "PostCollectionCell")
        clMyPost.delegate = self
        clMyPost.dataSource = self
        
    }

}

extension LibraryScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
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

extension LibraryScreen: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            cell.lbTitle.text = PostData.shared.newestData[indexPath.row].title
            cell.lbArea.text = PostData.shared.newestData[indexPath.row].area
            cell.lbPrice.text = PostData.shared.newestData[indexPath.row].price
            cell.lbAddress.text = PostData.shared.newestData[indexPath.row].address
            cell.lbDateTime.text = PostData.shared.newestData[indexPath.row].dateTime
            cell.img.image = PostData.shared.newestData[indexPath.row].image
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "PostDetailScreen", bundle: nil)
        let detailScreen = storyboard.instantiateViewController(withIdentifier: "PostDetailScreen") as! PostDetailScreen
        detailScreen.url = URL(string: PostData.shared.newestData[indexPath.row].linkDetail)
        self.navigationController?.pushViewController(detailScreen, animated: true)
    }
    
}
