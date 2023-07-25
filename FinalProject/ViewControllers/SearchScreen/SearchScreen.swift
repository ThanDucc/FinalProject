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
                return
            case 1:
                return
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
                        let full = i.p + " " + i.name
                        fullWards.append(full)
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
        
        if indexWard != 0 {
            tfSearchMovie.text = fullWards[indexWard]
            getDataFromURL(string: fullWards[indexWard].convertToURLString())
        } else {
            if indexDistric != 0 {
                tfSearchMovie.text = Constant.fullDistrics[indexCity][indexDistric]
                getDataFromURL(string: Constant.fullDistrics[indexCity][indexDistric].convertToURLString())
            } else {
                if indexCity != 0 {
                    tfSearchMovie.text = Constant.fullCities[indexCity]
                    getDataFromURL(string: Constant.fullCities[indexCity].convertToURLString())
                }
            }
        }
        
    }

    @IBAction func tfEnterringToSearch(_ sender: Any) {
        tbLayout.isHidden = true
        label.text = "Nhập tên tỉnh, thành phố, quận, huyện hoặc xã, phường, thị trấn"
    }
    
    func getDataFromURL(string: String) {
        // case certainly have data
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        
        let url = URL(string: Constant.originURL + string)
        
        if let url = url {
            DispatchQueue.global().async {
                PostData.shared.fetchDataFromWebsite(url: url) { result in
                    if result {
                        DispatchQueue.main.async { [self] in
                            loadingIndicator.isHidden = true
                            loadingIndicator.stopAnimating()
                            tbLayout.isHidden = false
                            tbLayout.reloadData()
                        }
                    }
                }
            }
        } else {
            print("Wrong url!")
        }
        
    }
    
}

extension SearchScreen: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if tfSearchMovie.text != "" {
            for i in GetFullAddress.fullWardToCheck {
                if i.lowercased().contains(tfSearchMovie.text?.lowercased() ?? "") {
                    getDataFromURL(string: i.convertToURLString())
                    textField.resignFirstResponder()
                    return true
                }
            }
            
            for i in Constant.fullDistrics {
                for j in i {
                    if j.lowercased().contains(tfSearchMovie.text?.lowercased() ?? "") {
                        getDataFromURL(string: j.convertToURLString())
                        textField.resignFirstResponder()
                        return true
                    }
                }
            }
            
            for i in Constant.fullCities {
                if i.lowercased().contains(tfSearchMovie.text?.lowercased() ?? "") {
                    getDataFromURL(string: i.convertToURLString())
                    textField.resignFirstResponder()
                    return true
                }
            }
            
            label.text = "Không tìm thấy kết quả"
        }
        
        textField.resignFirstResponder()
        return true
    }
}

extension SearchScreen: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostData.shared.postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            cell.lbTitle.text = PostData.shared.postData[indexPath.row].title
            cell.lbArea.text = PostData.shared.postData[indexPath.row].area
            cell.lbPrice.text = PostData.shared.postData[indexPath.row].price
            cell.lbAddress.text = PostData.shared.postData[indexPath.row].address
            cell.lbDateTime.text = PostData.shared.postData[indexPath.row].dateTime
            cell.img.image = PostData.shared.postData[indexPath.row].image
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "PostDetailScreen", bundle: nil)
        let detailScreen = storyboard.instantiateViewController(withIdentifier: "PostDetailScreen") as! PostDetailScreen
        detailScreen.url = URL(string: PostData.shared.postData[indexPath.row].linkDetail)
        self.navigationController?.pushViewController(detailScreen, animated: true)
    }
    
}
