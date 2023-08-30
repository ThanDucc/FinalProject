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
    
    @IBOutlet weak var btnSaved: UIButton!
    var saved = false
    
    var url = URL(string: "")
    
    var imageList: [UIImage] = []
    
    var index = 0
    
    var haveVideo = false
    
    var productId = ""
    
    var post: Post?
    
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnMess: UIButton!
    @IBOutlet weak var btnReport: UIButton!
    
    @IBOutlet weak var lnRemove: UILabel!
    @IBOutlet weak var lbEdit: UILabel!
    
    var check = true
    
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
        
        if saved {
            btnSaved.setBackgroundImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            btnSaved.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        
        if let url = self.url {
            check = true
            DispatchQueue.global().async {
                PostDetailData.shared.getDataDetail(url: url) { result in
                    if result {
                        DispatchQueue.main.async { [self] in
                            collectionImages.delegate = self
                            collectionImages.dataSource = self
                            collectionImages.reloadData()
                            
                            indicator.stopAnimating()
                            indicator.isHidden = true
                            
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
                            lbPhoneNumber.text = PostDetailData.shared.contactInfor?.phone_number
                            lbGmail.text = PostDetailData.shared.contactInfor?.email
                            
                            viewDetail.isHidden = false
                        }
                    }
                }
            }
        } else {
            check = false
            
            collectionImages.delegate = self
            collectionImages.dataSource = self
            collectionImages.reloadData()
            
            indicator.stopAnimating()
            indicator.isHidden = true
            
            titleDetail.text = post?.title
            priceDetail.text = post?.price
            areaDetail.text = post?.area

            addressDetail.text = post?.address
            descriptionDetail.text = post?.linkDetail
            
            let year = post?.dateTime.components(separatedBy: "-")[0] ?? ""
            let month = post?.dateTime.components(separatedBy: "-")[1] ?? ""
            let day = post?.dateTime.components(separatedBy: "-")[2] ?? ""
            
            let dateTime = day + "/" + month + "/" + year
            
            expirationDate.text = dateTime
            postDate.text = expirationDate.text
            
            getInfor()
            
            viewDetail.isHidden = false
            
            btnCall.isHidden = true
            btnMess.setImage(UIImage(systemName: "highlighter"), for: .normal)
            lbEdit.isHidden = false
            
            btnReport.setImage(UIImage(systemName: "trash"), for: .normal)
            lnRemove.isHidden = false
        }
        
    }
    
    func getInfor() {
        let requestURL = URL(string: "http://192.168.1.106/final_project/getUserInfor.php")!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"

        let data = "userId=\(Constant.userId)"
        
        request.httpBody = data.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.uploadTask(with: request, from: request.httpBody!) { data, response, error in
            DispatchQueue.main.async { [self] in
                if let response = String(data: data ?? Data(), encoding: .utf8) {
                    switch response {
                    case "Error":
                        print("Lỗi kết nối, vui lòng kiểm tra lại!")
                        
                    default:
                        guard let data = data else { return }
                        guard let infor = try? JSONDecoder().decode([UserInfor].self, from: data) else { return }
                        
                        DispatchQueue.main.async {
                            if !infor.isEmpty {
                                if let name = infor[0].name {
                                    if name.isEmpty {
                                        lbName.text = "Name"
                                    } else {
                                        lbName.text = name
                                    }
                                }
                                if let gmail = infor[0].email {
                                    if gmail.isEmpty {
                                        lbGmail.text = "Gmail"
                                    } else {
                                        lbGmail.text = gmail
                                    }
                                }
                                if let phone_number = infor[0].phone_number {
                                    if phone_number.isEmpty {
                                        lbPhoneNumber.text = ""
                                    } else {
                                        lbPhoneNumber.text = phone_number
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        }
        task.resume()
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
            haveVideo = true
        } else {
            imagePlay.isHidden = true
            haveVideo = false
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
    
    
    @IBAction func btnSavedClicked(_ sender: Any) {
        saved = !saved
        if saved {
            updateSaved(productId: productId, status: .insert) { [self] result in
                if result {
                    btnSaved.setBackgroundImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                } else {
                    print("Error")
                }
            }
        } else {
            updateSaved(productId: productId, status: .remove) { [self] result in
                if result {
                    btnSaved.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
                } else {
                    print("Error")
                }
            }
        }
    }
    
    func updateSaved(productId: String, status save: Saved, completion: @escaping (Bool) -> Void) {
        var requestURL = URL(string: "")
        
        btnSaved.isHidden = true
        
        switch save {
        case .insert:
            requestURL = URL(string: "http://192.168.1.106/final_project/insertSaved.php")!
        case .remove:
            requestURL = URL(string: "http://192.168.1.106/final_project/removeSaved.php")!
        }
        
        guard let requestURL = requestURL else {
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"

        let currentDate = Date()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: currentDate)
        
        let data = "userId=\(Constant.userId)&&productId=\(productId)&&dateTime=\(formattedDate)"
        
        request.httpBody = data.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.uploadTask(with: request, from: request.httpBody!) { data, response, error in
                if let response = String(data: data ?? Data(), encoding: .utf8) {
                    DispatchQueue.main.async { [self] in
                        switch response {
                        case "Successful":
                            completion(true)
                            
                            btnSaved.isHidden = false
                        default:
                            completion(false)
                            
                            btnSaved.isHidden = false
                        }
                    }
                }
            
        }
        task.resume()
    }
    
    
    @IBAction func btnCallClicked(_ sender: Any) {
        let phoneNumber = PostDetailData.shared.contactInfor?.phone_number
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber ?? "")") {
            if UIApplication.shared.canOpenURL(phoneCallURL) {
                UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func btnMessageClicked(_ sender: Any) {
        if check {
            let phoneNumber = PostDetailData.shared.contactInfor?.phone_number
            
            if let url = URL(string: "sms:\(phoneNumber ?? "")") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    print("Không thể mở ứng dụng Messages.")
                }
            }
        } else {
            let storyboard = UIStoryboard(name: "PostScreen", bundle: nil)
            let updatePost = storyboard.instantiateViewController(withIdentifier: "PostScreen") as? PostScreen ?? PostScreen()
            updatePost.edit = true
            updatePost.post = self.post
            self.navigationController?.pushViewController(updatePost, animated: true)
        }
        
    }
    
    @IBAction func btnRemoveClicked(_ sender: Any) {
        if check {
            print("Report")
        } else {
            let alert = UIAlertController(title: "Cảnh báo", message: "Bạn có chắc muốn xoá bài đăng này không?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đồng ý", style: .destructive, handler: { _ in
                self.removePost()
            }))
            alert.addAction(UIAlertAction(title: "Huỷ bỏ", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func removePost() {
        let requestURL = URL(string: "http://192.168.1.106/final_project/removeMyPost.php")
        
        guard let requestURL = requestURL else {
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"

        let data = "productId=\(post!.productId)"
        
        request.httpBody = data.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.uploadTask(with: request, from: request.httpBody!) { data, response, error in
                if let response = String(data: data ?? Data(), encoding: .utf8) {
                    DispatchQueue.main.async { [self] in
                        switch response {
                        case "Successful":
                            self.navigationController?.popViewController(animated: true)
                        default:
                            print("Error")
                        }
                    }
                }
            
        }
        task.resume()
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
            
            if haveVideo {
                if indexPath.row == 0 {
                    imagePlay.isHidden = false
                } else {
                    imagePlay.isHidden = true
                }
            }
            
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
