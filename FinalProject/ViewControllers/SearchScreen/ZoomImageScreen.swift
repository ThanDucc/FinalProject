//
//  ZoomImageScreen.swift
//  FinalProject
//
//  Created by ThanDuc on 11/07/2023.
//

import UIKit
import WebKit

class ZoomImageScreen: UIViewController {
    
    @IBOutlet weak var collectionZoomImage: UICollectionView!
    
    @IBOutlet weak var imgExit: UIImageView!
        
    var imageList: [UIImage] = []
    
    var index = 0
    
    var haveVideo = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionZoomImage.register(UINib(nibName: "ZoomImageCell", bundle: nil), forCellWithReuseIdentifier: "ZoomImageCell")
        collectionZoomImage.register(UINib(nibName: "WebViewCell", bundle: nil), forCellWithReuseIdentifier: "WebViewCell")

        collectionZoomImage.delegate = self
        collectionZoomImage.dataSource = self
        
        imgExit.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(exit)))
        imgExit.isUserInteractionEnabled = true
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeftGesture.direction = .left
        collectionZoomImage.addGestureRecognizer(swipeLeftGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRightGesture.direction = .right
        collectionZoomImage.addGestureRecognizer(swipeRightGesture)
        
        if PostDetailData.shared.urlVideo != "" {
            haveVideo = true
        }
        
    }

    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            index -= 1
            if index < 0 {
                index = 0
            }
        } else if gesture.direction == .left {
            index += 1
            if index > imageList.count - 1 {
                index = imageList.count - 1
            }
        }
        
        collectionZoomImage.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionZoomImage.isHidden = true
    }
    
    @objc func exit() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionZoomImage.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
        
        collectionZoomImage.isHidden = false
    }
    
}

extension ZoomImageScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if haveVideo {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WebViewCell", for: indexPath) as! WebViewCell
                
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZoomImageCell", for: indexPath) as? ZoomImageCell
                cell?.largeImage.image = imageList[indexPath.row]
    
                return cell ?? UICollectionViewCell()
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZoomImageCell", for: indexPath) as? ZoomImageCell
            cell?.largeImage.image = imageList[indexPath.row]

            return cell ?? UICollectionViewCell()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 3, height: collectionView.frame.height)
    }
    
}

