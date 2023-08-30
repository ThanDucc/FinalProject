//
//  LibraryScreenController.swift
//  MovieApplication
//
//  Created by thanpd on 11/05/2023.
//

import UIKit

class LibraryScreen: UIViewController {

    @IBOutlet weak var tbPostSaved: UITableView!
    
    @IBOutlet weak var clMyPost: UICollectionView!
    
    var postSaved: [Post] = []
    
    var myPost: [Post] = []
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var heightConstraintCollection: NSLayoutConstraint!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        MainScreen.tabbar?.tabBar.isHidden = false
        
        getPostSaved()
        
        getMyPost()
    }
    
    private func setupUI() {
        
        heightConstraintCollection.constant = (UIScreen.main.bounds.width - 45)/2/1.25 + 131

        tbPostSaved.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        tbPostSaved.delegate = self
        tbPostSaved.dataSource = self
        
        clMyPost.register(UINib(nibName: "PostCollectionCell", bundle: nil), forCellWithReuseIdentifier: "PostCollectionCell")
        clMyPost.delegate = self
        clMyPost.dataSource = self
        
    }
    
    func getPostSaved() {
        let requestURL = URL(string: "http://192.168.1.106/final_project/getPostSaved.php")!
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
                        let post = try? JSONDecoder().decode([Post].self, from: data ?? Data())
                        DispatchQueue.main.async { [self] in
                            postSaved = post ?? []
                            if postSaved.isEmpty {
                                tbPostSaved.isHidden = true
                            } else {
                                tbPostSaved.isHidden = false
                                tbPostSaved.reloadData()
                            }
                        }
                    }
                }
            }
            
        }
        task.resume()
    }
    
    func getMyPost() {
        let requestURL = URL(string: "http://192.168.1.106/final_project/getMyPost.php")!
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
                        let post = try? JSONDecoder().decode([Post].self, from: data ?? Data())
                        DispatchQueue.main.async { [self] in
                            myPost = post ?? []
                            
                            if myPost.isEmpty {
                                clMyPost.isHidden = true
                                heightConstraint.constant = 30
                                view.layoutIfNeeded()
                            } else {
                                clMyPost.isHidden = false
                                clMyPost.reloadData()
                                heightConstraint.constant = (UIScreen.main.bounds.width - 45)/2/1.25 + 112
                                view.layoutIfNeeded()
                            }
                        }
                    }
                }
            }
            
        }
        task.resume()
    }

}

extension LibraryScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPost.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionCell", for: indexPath) as? PostCollectionCell {
            cell.lbTitle.text = myPost[indexPath.row].title
            cell.lbArea.text = myPost[indexPath.row].area
            cell.lbPrice.text = myPost[indexPath.row].price
            cell.lbAddress.text = myPost[indexPath.row].address
            
            let year = myPost[indexPath.row].dateTime.components(separatedBy: "-")[0]
            let month = myPost[indexPath.row].dateTime.components(separatedBy: "-")[1]
            let day = myPost[indexPath.row].dateTime.components(separatedBy: "-")[2]
            
            let dateTime = day + "/" + month + "/" + year
            
            cell.lbDateTime.text = dateTime
            
            cell.img.image = UIImage(named: "noImg") ?? UIImage()
                        
            DispatchQueue.global().async { [self] in
                if let url = URL(string: myPost[indexPath.row].linkImageCover ?? ""), let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        cell.img.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        cell.img.image = UIImage(named: "noImg") ?? UIImage()
                    }
                }
            }
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 45)/2, height: (UIScreen.main.bounds.width - 45)/2/1.25 + 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "PostDetailScreen", bundle: nil)
        let detailScreen = storyboard.instantiateViewController(withIdentifier: "PostDetailScreen") as? PostDetailScreen ?? PostDetailScreen()
        detailScreen.post = myPost[indexPath.row]
        self.navigationController?.pushViewController(detailScreen, animated: true)
    }
    
    
}

extension LibraryScreen: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postSaved.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            cell.lbTitle.text = postSaved[indexPath.row].title
            cell.lbArea.text = postSaved[indexPath.row].area
            cell.lbPrice.text = postSaved[indexPath.row].price
            cell.lbAddress.text = postSaved[indexPath.row].address
            
            let year = postSaved[indexPath.row].dateTime.components(separatedBy: "-")[0]
            let month = postSaved[indexPath.row].dateTime.components(separatedBy: "-")[1]
            let day = postSaved[indexPath.row].dateTime.components(separatedBy: "-")[2]
            
            let dateTime = day + "/" + month + "/" + year
            
            cell.lbDateTime.text = dateTime
            
            cell.img.image = UIImage(named: "noImg") ?? UIImage()
                        
            DispatchQueue.global().async { [self] in
                if let url = URL(string: postSaved[indexPath.row].linkImageCover ?? ""), let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        cell.img.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        cell.img.image = UIImage(named: "noImg") ?? UIImage()
                    }
                }
            }
            
            cell.btnSaved.setBackgroundImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            
            cell.saved = true
            cell.productId = postSaved[indexPath.row].productId
            cell.sourceViewController = self
            cell.screen = .LibraryScreen
            
            cell.savedClick = { [self] in
                getPostSaved()
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "PostDetailScreen", bundle: nil)
        let detailScreen = storyboard.instantiateViewController(withIdentifier: "PostDetailScreen") as? PostDetailScreen ?? PostDetailScreen()
        detailScreen.url = URL(string: postSaved[indexPath.row].linkDetail)
        detailScreen.saved = true
        detailScreen.productId = postSaved[indexPath.row].productId
        self.navigationController?.pushViewController(detailScreen, animated: true)
    }
    
}
