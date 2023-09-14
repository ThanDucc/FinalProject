//
//  TelevisionScreenController.swift
//  MovieApplication
//
//  Created by thanpd on 04/05/2023.
//

import UIKit

class SearchScreen: UIViewController {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var tfSearchMovie: UITextField!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var tbLayout: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filter: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    var buttonDone = UIButton()

    var fullWards: [String] = ["Chọn xã, phường"]
    
    var menu = MenuDropdown()
    
    var indexCity = 0
    var indexDistric = 0
    var indexWard = 0
    
    var indexPriceFilter = -1
    
    var indexAreaFilter = -1
    
    var minPrice = 0
    var maxPrice = 1000
    var minArea = 0
    var maxArea = 1000
    
    var arrayOfTuples: [(min: Double, max: Double)] = [(0, 1), (1, 3), (3, 5), (5, 10), (10, 1000)]
    
    var postData: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        tbLayout.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        tbLayout.delegate = self
        tbLayout.dataSource = self
    
        filter.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showManagerAccountDialog(_:))))
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationThemeChange), name: Notification.Name("Theme Changed"), object: nil)
        
        tfSearchMovie.delegate = self
        
        setupUI()
        
        loadingIndicator.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        MainScreen.tabbar?.tabBar.isHidden = false
        
        tbLayout.reloadData()
    }

    
    func setupUI() {
        firstView.layer.cornerRadius = 15
        firstView.setBackground(tabbar: self.tabBarController!)
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.label,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light)
        ]
        tfSearchMovie.attributedPlaceholder = NSAttributedString(string: "Tìm kiếm...", attributes: attributes)
        
        btnMenu.setBackgroundImage(UIImage(named: "menu")?.withTintColor(.label), for: .normal)
        
        filter.image = UIImage(named: "filter")?.withTintColor(.label)
        filter.isUserInteractionEnabled = true
        
        tbLayout.isHidden = true
        
    }
    
    @objc func notificationThemeChange() {
        firstView.setBackground(tabbar: self.tabBarController!)
    }
    
    @objc private func showManagerAccountDialog(_ sender: UITapGestureRecognizer) {
        
        let menu = menuDropdown(Constant.defaultFilterMenu, sourceView: filter, status: true, type: .filt)
        openMenu(menu: menu) { index in
            switch index {
            case 0:
                let priceFilterView = Bundle.main.loadNibNamed("PriceFilterView", owner: self, options: nil)?.first as? PriceFilterView ?? PriceFilterView()
                            
                priceFilterView.frame = CGRect(x: menu.rect.minX - 75, y: menu.rect.minY, width: 250, height: 275)
                
                priceFilterView.index = self.indexPriceFilter
                
                priceFilterView.chooseFilter = { [self] tupple in
                    switch tupple.min {
                    case 0: indexPriceFilter = 0
                    case 1: indexPriceFilter = 1
                    case 3: indexPriceFilter = 2
                    case 5: indexPriceFilter = 3
                    default: indexPriceFilter = 4
                    }
                    
                    minPrice = tupple.min
                    maxPrice = tupple.max
                    
                    if tfSearchMovie.text != "" {
                        getInfor()
                    }
                }
                
                priceFilterView.cancel = { [self] in
                    minPrice = 0
                    maxPrice = 1000
                    
                    indexPriceFilter = -1
                    
                    getInfor()
                }
                self.view.addSubview(priceFilterView)
                
            case 1:
                let areaFilterView = Bundle.main.loadNibNamed("AreaFilterView", owner: self, options: nil)?.first as? AreaFilterView ?? AreaFilterView()
                            
                areaFilterView.frame = CGRect(x: menu.rect.minX - 75, y: menu.rect.minY, width: 250, height: 275)
                
                areaFilterView.index = self.indexAreaFilter
                
                areaFilterView.chooseFilter = { [self] tupple in
                    switch tupple.min {
                    case 0: indexAreaFilter = 0
                    case 20: indexAreaFilter = 1
                    case 30: indexAreaFilter = 2
                    case 40: indexAreaFilter = 3
                    default: indexAreaFilter = 4
                    }
                    
                    minArea = tupple.min
                    maxArea = tupple.max
                    
                    if tfSearchMovie.text != "" {
                        getInfor()
                    }
                }
                
                areaFilterView.cancel = { [self] in
                    minArea = 0
                    maxArea = 1000
                    
                    indexAreaFilter = -1
                    
                    getInfor()
                }
                
                self.view.addSubview(areaFilterView)
            default:
                menu.close(true)
            }
            menu.close(true)
        }
    }
    
    @IBAction func btnMenuClicked(_ sender: Any) {
        menu = menuDropdown(Constant.defaultSearchMenu, sourceView: btnMenu, status: true, type: .search)
        
        setAttributeButton(rect: CGRect(x: 50 + menu.rect.minX, y: menu.rect.maxY + 20, width: 60, height: 30))
        
        tbLayout.isHidden = true
        
        menu.buttons[0].setTitle(Constant.fullCities[indexCity], for: .normal)
        menu.buttons[1].setTitle(Constant.fullDistrics[indexCity][indexDistric], for: .normal)
        menu.buttons[2].setTitle(fullWards[indexWard], for: .normal)
        
        openMenu(menu: menu) { [self] index in
            switch index {
            case 0: // city
                let subMenu = self.menuDropdown(Constant.fullCities, sourceView: menu.buttons[0], status: false, type: .search)
                self.openMenu(menu: subMenu) { [self] subIndex in
                    // if change city, update districts and wards
                    if subIndex != indexCity {
                        indexDistric = 0
                        menu.buttons[1].setTitle("Chọn quận, huyện", for: .normal)
                        
                        indexWard = 0
                        menu.buttons[2].setTitle("Chọn xã, phường", for: .normal)
                    }
                    
                    menu.buttons[0].setTitle(Constant.fullCities[subIndex], for: .normal)
                    indexCity = subIndex
                    subMenu.close(true)
                }
               
            case 1: // districts
                if indexCity != 0 {
                    let subMenu = self.menuDropdown(Constant.fullDistrics[indexCity], sourceView: menu.buttons[1], status: false, type: .search)
                    self.openMenu(menu: subMenu) { [self] subIndex in
                        // if change district, update wards
                        if subIndex != indexDistric {
                            indexWard = 0
                            menu.buttons[2].setTitle("Chọn xã, phường", for: .normal)
                        }
                        
                        menu.buttons[1].setTitle(Constant.fullDistrics[indexCity][subIndex], for: .normal)
                        indexDistric = subIndex
                        subMenu.close(true)
                    }
                }
                
            case 2: // wards
                if indexDistric != 0 {
                    fullWards = ["Chọn xã, phường"]
                    
                    for i in GetFullAddress.fullAddress?[indexCity-1].districts[indexDistric-1].wards ?? [] {
                        fullWards.append(i.name)
                    }
                    
                    let subMenu = self.menuDropdown(fullWards, sourceView: menu.buttons[2], status: false, type: .search)
                    self.openMenu(menu: subMenu) { [self] subIndex in
                        menu.buttons[2].setTitle(fullWards[subIndex], for: .normal)
                        indexWard = subIndex
                        subMenu.close(true)
                    }
                }
            default: return
                
            }
        }

    }

    func setAttributeButton(rect: CGRect) {
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 15, weight: .bold), .foregroundColor: UIColor.white]
        
        buttonDone = UIButton(frame: rect)
        buttonDone.backgroundColor = .systemCyan
        buttonDone.setAttributedTitle(NSAttributedString(string: "Done", attributes: attributes), for: .normal)
        buttonDone.layer.cornerRadius = 10
        
        buttonDone.addTarget(self, action: #selector(closeMenuAndSearch), for: .touchUpInside)
        view.addSubview(buttonDone)
    }
    
    @objc func closeMenuAndSearch() {
        menu.close(true)
        buttonDone.removeFromSuperview()
        
        indexPriceFilter = -1
        
        if indexWard != 0 {
            tfSearchMovie.text = fullWards[indexWard]
        } else {
            if indexDistric != 0 {
                tfSearchMovie.text = Constant.fullDistrics[indexCity][indexDistric]
            } else {
                if indexCity != 0 {
                    tfSearchMovie.text = Constant.fullCities[indexCity]
                }
            }
        }
        
        getInfor()
        
    }
    
    func getInfor() {
        tbLayout.isHidden = true
        // case certainly have data
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        
        
        let requestURL = URL(string: Constant.domain + "final_project/getPostData.php")!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let address = tfSearchMovie.text ?? ""
        
        let data = "address=\(address)&&min_price=\(minPrice)&&max_price=\(maxPrice)&&min_area=\(minArea)&&max_area=\(maxArea)"
        
        request.httpBody = data.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.uploadTask(with: request, from: request.httpBody!) { data, response, error in
                if let response = String(data: data ?? Data(), encoding: .utf8) {
                    switch response {
                    case "Error":
                        print("Lỗi kết nối, vui lòng kiểm tra lại!")
                        
                    default:
                        let post = try? JSONDecoder().decode([Post].self, from: data ?? Data())
                        DispatchQueue.main.async { [self] in
                            postData = post ?? []
                            
                            if post?.isEmpty ?? false {
                                loadingIndicator.isHidden = true
                                loadingIndicator.stopAnimating()
                                self.label.text = "Không tìm thấy kết quả"
                                tbLayout.isHidden = true
                            } else {
                                loadingIndicator.isHidden = true
                                loadingIndicator.stopAnimating()
                                tbLayout.isHidden = false
                                tbLayout.reloadData()
                            }
                        }
                    }
                }
            
        }
        task.resume()
    }

    @IBAction func tfEnterringToSearch(_ sender: Any) {
        tbLayout.isHidden = true
        label.text = "Nhập địa chỉ tìm kiếm"
        
    }
    
}

extension SearchScreen: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        indexPriceFilter = -1
        
        if tfSearchMovie.text != "" {
            getInfor()
        }
        
        textField.resignFirstResponder()
        return true
    }
    
}

extension SearchScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if postData.count > 80 {
            return 80
        } else {
            return postData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            cell.lbTitle.text = postData[indexPath.row].title
            cell.lbArea.text = postData[indexPath.row].area
            cell.lbPrice.text = postData[indexPath.row].price
            cell.lbAddress.text = postData[indexPath.row].address
            
            let year = postData[indexPath.row].dateTime.components(separatedBy: "-")[0]
            let month = postData[indexPath.row].dateTime.components(separatedBy: "-")[1]
            let day = postData[indexPath.row].dateTime.components(separatedBy: "-")[2]
            
            let dateTime = day + "/" + month + "/" + year
            
            cell.lbDateTime.text = dateTime
            
            cell.img.image = UIImage(named: "noImg") ?? UIImage()
                        
            DispatchQueue.global().async { [self] in
                if let url = URL(string: postData[indexPath.row].linkImageCover ?? ""), let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        cell.img.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        cell.img.image = UIImage(named: "noImg") ?? UIImage()
                    }
                }
            }
            
            checkSaved(productId: postData[indexPath.row].productId) { [self] saved in
                postData[indexPath.row].saved = saved
                cell.saved = postData[indexPath.row].saved
                
                if saved {
                    cell.btnSaved.setBackgroundImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                } else {
                    cell.btnSaved.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
                }
            }
            
            cell.productId = postData[indexPath.row].productId
            cell.sourceViewController = self
            cell.screen = .SearchScreen
            
            cell.savedClick = { [self] in
                postData[indexPath.row].saved = !postData[indexPath.row].saved
                cell.saved = postData[indexPath.row].saved
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "PostDetailScreen", bundle: nil)
        let detailScreen = storyboard.instantiateViewController(withIdentifier: "PostDetailScreen") as! PostDetailScreen
        detailScreen.url = URL(string: postData[indexPath.row].linkDetail)
        detailScreen.saved = postData[indexPath.row].saved
        detailScreen.productId = postData[indexPath.row].productId
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
