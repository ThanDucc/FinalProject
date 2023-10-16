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
        
        RecommendPost.getRecommend(address: User.user.address ?? "")
        
        setupUI()
        
        collection.register(UINib(nibName: "PostCollectionCell", bundle: nil), forCellWithReuseIdentifier: "PostCollectionCell")
        collection.delegate = self
        collection.dataSource = self
        
        indicator.startAnimating()
        indicator.isHidden = false
        
        NotificationCenter.default.addObserver(forName: Notification.Name("load recommend successfully"), object: nil, queue: nil) { _ in
            DispatchQueue.main.async { [self] in
                collection.reloadData()
                indicator.stopAnimating()
                indicator.isHidden = true
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("reload"), object: nil, queue: nil) { _ in
            User.getUserInfor {
                RecommendPost.countInteraction { count in
                    if count > 5 {
                        if User.user.price == nil || User.user.address == nil || User.user.area == nil {
                            CollaborativeFilter.getRecommend(number: 12, completion: {
                                // Recommend.collaborativePost
                                NotificationCenter.default.post(name: Notification.Name("load collaborative done"), object: nil)
                            })
                            print("collaborative")
                        } else {
                            // have information
                            GetAllPost.getAllPost(completion: {
                                ContentBasedFilter.getRecommend(numberOfRecommend: 6, completion: {
                                    NotificationCenter.default.post(name: Notification.Name("load done"), object: nil)
                                })
                            })
                
                            CollaborativeFilter.getRecommend(number: 10, completion: {
                                NotificationCenter.default.post(name: Notification.Name("load done"), object: nil)
                            })
                            print("hybrid")
                        }
                    } else {  // less than 5
                        if User.user.price == nil || User.user.address == nil || User.user.area == nil {
                            // less than 5 + no information
                            RecommendPost.getRandomRecommend { postList in
                                RecommendPost.recomendPost = postList
                                NotificationCenter.default.post(name: Notification.Name("load random post done"), object: nil)
                                print("random")
                            }
                        } else {
                            // less than 5 + have information
                            GetAllPost.getAllPost(completion: {
                                ContentBasedFilter.getRecommend(numberOfRecommend: 8, completion: {
                                    // Recommend.contentBasedpost
                                    NotificationCenter.default.post(name: Notification.Name("load content based done"), object: nil)
                                    print("content based")
                                })
                            })
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        MainScreen.tabbar?.tabBar.isHidden = false
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
        return RecommendPost.recomendPost.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionCell", for: indexPath) as? PostCollectionCell {
            cell.lbTitle.text = RecommendPost.recomendPost[indexPath.row].title
            cell.lbArea.text = RecommendPost.recomendPost[indexPath.row].area
            cell.lbPrice.text = RecommendPost.recomendPost[indexPath.row].price
            cell.lbAddress.text = RecommendPost.recomendPost[indexPath.row].address
            
            let year = RecommendPost.recomendPost[indexPath.row].dateTime.components(separatedBy: "-")[0]
            let month = RecommendPost.recomendPost[indexPath.row].dateTime.components(separatedBy: "-")[1]
            let day = RecommendPost.recomendPost[indexPath.row].dateTime.components(separatedBy: "-")[2]
            
            let dateTime = day + "/" + month + "/" + year
            
            cell.lbDateTime.text = dateTime
            
            cell.img.image = UIImage(named: "noImg") ?? UIImage()
                        
            DispatchQueue.global().async { 
                if let url = URL(string: RecommendPost.recomendPost[indexPath.row].linkImageCover ?? ""), let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        cell.img.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        cell.img.image = UIImage(named: "noImg") ?? UIImage()
                    }
                }
            }
            
            checkSaved(productId: RecommendPost.recomendPost[indexPath.row].productId) { saved in
                RecommendPost.recomendPost[indexPath.row].saved = saved
                cell.saved = RecommendPost.recomendPost[indexPath.row].saved
            }

            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 45)/2, height: (UIScreen.main.bounds.width - 45)/2/1.25 + 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        GetUserInteraction.getUserInteraction(productId: RecommendPost.recomendPost[indexPath.row].productId, completion: { u in
            if let userInteraction = u {
                let number_of_click = (Int(userInteraction.number_of_click) ?? 0) + 1
                userInteraction.number_of_click = String(number_of_click)
                let rating = GetUserInteraction.calculateRating(numberOfClick: Double(number_of_click), saved: Double(userInteraction.saved) ?? 0, contacted: Double(userInteraction.contacted) ?? 0)
                userInteraction.rating = String(rating)
                
                // updateDatabase
                GetUserInteraction.updateUserInteraction(userInter: userInteraction)
            } else {
                let rating = GetUserInteraction.calculateRating(numberOfClick: 1, saved: 0, contacted: 0)
                let userInteraction = UserInteraction(userId: Constant.userId, productId: RecommendPost.recomendPost[indexPath.row].productId, number_of_click: "1", saved: "0", contacted: "0", rating: String(rating))
                
                // add to database
                GetUserInteraction.insertUserInteraction(userInter: userInteraction)
            }
            
        })
        
        let storyboard = UIStoryboard(name: "PostDetailScreen", bundle: nil)
        let detailScreen = storyboard.instantiateViewController(withIdentifier: "PostDetailScreen") as! PostDetailScreen
        detailScreen.url = URL(string: RecommendPost.recomendPost[indexPath.row].linkDetail)
        detailScreen.saved = RecommendPost.recomendPost[indexPath.row].saved
        detailScreen.productId = RecommendPost.recomendPost[indexPath.row].productId
        self.navigationController?.pushViewController(detailScreen, animated: true)
    }
    
    
    func checkSaved(productId: String, completion: @escaping (Bool) -> Void) {
        let requestURL = URL(string: Constant.domain + "final_project/checkSaved.php")!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let data = "userId=\(Constant.userId)&&productId=\(productId)"
        
        request.httpBody = data.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.uploadTask(with: request, from: request.httpBody!) { data, response, error in
                if let response = String(data: data ?? Data(), encoding: .utf8) {
                    DispatchQueue.main.async {
                        switch response {
                        case "true":
                            completion(true)
                        default:
                            completion(false)
                        }
                    }
                }
            
        }
        task.resume()
    }
    
}
