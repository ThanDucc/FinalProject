//
//  PostDetailScreen.swift
//  FinalProject
//
//  Created by ThanDuc on 09/07/2023.
//

import UIKit

class PostDetailScreen: UIViewController {

    @IBOutlet weak var imagePlay: UIImageView!
    @IBOutlet weak var largeImage: UIImageView!
    @IBOutlet weak var collectionImages: UICollectionView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var viewDetail: UIView!
    @IBOutlet weak var titleDetail: UILabel!
    @IBOutlet weak var priceDetail: UILabel!
    @IBOutlet weak var areaDetail: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var expirationDate: UILabel!
    @IBOutlet weak var addressDetail: UILabel!
    @IBOutlet weak var descriptionDetail: UILabel!
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPhoneNumber: UILabel!
    @IBOutlet weak var lbGmail: UILabel!
    
    var url = URL(string: "")
    
    var imageList: [UIImage] = []
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionImages.register(UINib(nibName: "RoomImageCell", bundle: nil), forCellWithReuseIdentifier: "RoomImageCell")
        collectionImages.delegate = nil
        collectionImages.dataSource = nil
        
        imagePlay.isHidden = true
        
        largeImage.image = UIImage()
        indicator.startAnimating()
        indicator.isHidden = false
        viewDetail.isHidden = true
        
        titleDetail.font = UIFont.boldSystemFont(ofSize: titleDetail.font.pointSize)
        
        if let url = self.url {
            DispatchQueue.global().async {
                PostDetailData.shared.getDataDetail(url: url) { result in
                    if result {
                        DispatchQueue.main.async { [self] in
                            collectionImages.delegate = self
                            collectionImages.dataSource = self
                            collectionImages.reloadData()
                            
                            PostDetailData.shared.getImage(urls: PostDetailData.shared.postDetailData?.linkImagesDetail ?? []) { result in
                                if result {
                                    DispatchQueue.main.async {
                                        self.imageList = PostDetailData.shared.listImage
                                        self.loadLargeImage()
                                        self.collectionImages.reloadData()
                                    }
                                }
                            }
                            
                            titleDetail.text = PostDetailData.shared.postDetailData?.titleDetail
                            priceDetail.text = PostDetailData.shared.postDetailData?.priceDetail
                            areaDetail.text = PostDetailData.shared.postDetailData?.areaDetail
                            postDate.text = PostDetailData.shared.postDetailData?.postDate
                            expirationDate.text = PostDetailData.shared.postDetailData?.expirationDate
                            addressDetail.text = PostDetailData.shared.postDetailData?.addressDetail
                            descriptionDetail.text = PostDetailData.shared.postDetailData?.descriptionDetail
                            
                            lbName.text = PostDetailData.shared.contactInfor?.name
                            lbPhoneNumber.text = PostDetailData.shared.contactInfor?.phoneNumber
                            lbGmail.text = PostDetailData.shared.contactInfor?.email
                            
                            viewDetail.isHidden = false
                        }
                    }
                }
            }
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.title = "Chi tiết phòng"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: nil)
        
        MainScreen.tabbar?.tabBar.isHidden = true
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadLargeImage() {
        largeImage.image = imageList[0]
        largeImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLargeImage)))
        if PostDetailData.shared.urlVideo != "" && index == 0 {
            imagePlay.isHidden = false
        } else {
            imagePlay.isHidden = true
        }
    }
    
    @objc func tapLargeImage() {
        let storyboard = UIStoryboard(name: "ZoomImageScreen", bundle: nil)
        let zoomImageScreen = storyboard.instantiateViewController(withIdentifier: "ZoomImageScreen") as! ZoomImageScreen
        zoomImageScreen.modalPresentationStyle = .overFullScreen
        zoomImageScreen.imageList = self.imageList
        zoomImageScreen.index = self.index
        self.present(zoomImageScreen, animated: true, completion: nil)
    }
    
    
    @IBAction func btnCallClicked(_ sender: Any) {
        let phoneNumber = PostDetailData.shared.contactInfor?.phoneNumber
        
        if let phoneCallURL = URL(string: "tel://\(String(describing: phoneNumber))") {
            if UIApplication.shared.canOpenURL(phoneCallURL) {
                UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
}

extension PostDetailScreen: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomImageCell", for: indexPath) as? RoomImageCell {

            cell.roomImage.layer.borderWidth = 0

            indicator.stopAnimating()
            indicator.isHidden = true
            
            cell.roomImage.image = imageList[indexPath.row]
            
            if self.index == indexPath.row {
                cell.roomImage.layer.borderWidth = 4
                cell.roomImage.layer.borderColor = UIColor.systemTeal.cgColor
            }
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let newCell = collectionView.cellForItem(at: indexPath) as? RoomImageCell {
            largeImage.image = newCell.roomImage.image
            
            newCell.roomImage.layer.borderWidth = 4
            newCell.roomImage.layer.borderColor = UIColor.systemTeal.cgColor
            
            if index >= 0 && index != indexPath.row {
                let oldIndex = IndexPath(item: self.index, section: 0)
                if collectionView.indexPathsForVisibleItems.contains(oldIndex) {
                    let oldCell = collectionView.cellForItem(at: IndexPath(item: self.index, section: 0)) as! RoomImageCell
                    oldCell.roomImage.layer.borderWidth = 0
                } else {
                    collectionView.reloadItems(at: [IndexPath(item: self.index, section: 0)])
                }
            }
            
            if self.index != indexPath.row {
                self.index = indexPath.row
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 110)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -4
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
