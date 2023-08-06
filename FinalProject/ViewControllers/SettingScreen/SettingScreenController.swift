//
//  SettingScreenController.swift
//  MovieApplication
//
//  Created by thanpd on 11/05/2023.
//

import UIKit

class SettingScreenController: UIViewController {

    @IBOutlet weak var enableNotiCheckbox: UIButton!
    @IBOutlet weak var lbChooseTheme: UILabel!
    @IBOutlet weak var settingTheme: UIView!
    @IBOutlet weak var lbTheme: UILabel!
    
    @IBOutlet weak var viewAccount: UIView!
    @IBOutlet weak var heightConstraintAccountSetting: NSLayoutConstraint!
    
    private var enableNoti = false {
        didSet {
            if enableNoti {
                enableNotiCheckbox.setBackgroundImage(UIImage(named: "checkbox_checked")?.withTintColor(.label), for: .normal)
            } else {
                enableNotiCheckbox.setBackgroundImage(UIImage(named: "checkbox_unchecked")?.withTintColor(.label), for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbVersionGetJsonData.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getData)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: Notification.Name("HadAccount"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: Notification.Name("HadNotAccount"), object: nil)

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        MainScreen.tabbar?.tabBar.isHidden = false
    }
    
    @objc func handleNotification() {
        check()
    }
    
    private func setupUI() {
        
        check()
    
        settingTheme.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseThemeClicked(_:))))
        settingTheme.isUserInteractionEnabled = true
                
        NotificationCenter.default.addObserver(self, selector: #selector(notificationThemeChange), name: Notification.Name("Theme Changed"), object: nil)
        
        enableNotiCheckbox.setBackgroundImage(UIImage(named: "checkbox_unchecked")?.withTintColor(.label), for: .normal)
        
        changeTheme()
    }
    
    func check() {
        if MainScreen.hasAccount {
            heightConstraintAccountSetting.constant = 175
            viewAccount.isHidden = false
        } else {
            heightConstraintAccountSetting.constant = 0
            viewAccount.isHidden = true
        }
        view.layoutIfNeeded()
    }
    
    func changeTheme() {
        switch UserDefaults.standard.string(forKey: "ThemeApp") {
        case "dark":
            lbTheme.text = "Tối"
            break
        default:
            lbTheme.text = "Sáng"
            break
        }
    }
    
    @objc func notificationThemeChange() {
        changeTheme()
    }
    
    @objc func chooseThemeClicked(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "SettingThemeView", bundle: nil)
        let settingThemeVC = storyboard.instantiateViewController(withIdentifier: "SettingThemeView") as! SettingThemeView
        settingThemeVC.modalPresentationStyle = .overFullScreen
        settingThemeVC.modalTransitionStyle = .crossDissolve
        self.parent!.present(settingThemeVC, animated: true)
    }

    @IBAction func btnEnableNotiClicked(_ sender: Any) {
        enableNoti = !enableNoti
    }
    
    @IBAction func btnUpdateInforClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UpdateInformationView", bundle: nil)
        let updateScreen = storyboard.instantiateViewController(withIdentifier: "UpdateInformationView")
        self.navigationController?.pushViewController(updateScreen, animated: true)
    }
    
    
    @IBOutlet weak var lbVersionGetJsonData: UILabel!
    public static var fullWardInHanoi: [String] = []
}

extension SettingScreenController {
    
    @objc func getData() {
        getFullWardInHanoi()
        
        for i in SettingScreenController.fullWardInHanoi {
            getDataFromURL(string: i.convertToURLString(), minPrice: 0, maxPrice: 1000, minArea: 1, maxArea: 1000)
        }
        
        let desktopPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = desktopPath.appendingPathComponent("postList.json")

        let posts: [POST] = PostData.shared.postdata

        writePostsToJSON(posts: posts, filePath: filePath)
    }
    
    func getFullWardInHanoi() {
        for j in 0..<GetFullAddress.fullAddress![1].districts.count {
            for k in 0..<GetFullAddress.fullAddress![1].districts[j].wards.count {
                SettingScreenController.fullWardInHanoi.append(GetFullAddress.fullAddress![1].districts[j].wards[k].p + " " + GetFullAddress.fullAddress![1].districts[j].wards[k].name)
            }
        }
    }
    
    func getDataFromURL(string: String, minPrice: Double, maxPrice: Double, minArea: Double, maxArea: Double) {
        
        let url = URL(string: Constant.originURL + string)
        let url2 = URL(string: Constant.originURL + string + "/p2")
        
        if let url = url, let url2 = url2 {
            PostData.shared.fetchDataFromWebsite(url: url, url2: url2, minPrice: minPrice, maxPrice: maxPrice, minArea: minArea, maxArea: maxArea) { _ in
            }
        } else {
            print("Wrong url!")
        }
        
    }
    
    func writePostsToJSON(posts: [POST], filePath: URL) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let jsonData = try encoder.encode(posts)
            try jsonData.write(to: filePath)
            print("JSON file saved successfully.")
        } catch {
            print("Error while writing JSON file: \(error)")
        }
    }

}
