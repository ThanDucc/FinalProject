//
//  PeopleScreenController.swift
//  MovieApplication
//
//  Created by thanpd on 08/05/2023.
//

import UIKit
import SwiftSoup

class PostScreen: UIViewController {
        
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tvTitle: UITextView!
    @IBOutlet weak var lbArea: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var tfArea: UITextField!
    @IBOutlet weak var tfExpirationDate: UITextField!
    
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var imgAddPhoto: UIImageView!
        
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var viewStatus: UIView!
    
    @IBOutlet weak var switchStatus: UISwitch!
    
    var edit = false
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: Notification.Name("HadAccount"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: Notification.Name("HadNotAccount"), object: nil)
        
        lbArea.text = "m\u{00B2}"
        
        setAttributeTextView(view: tvTitle)
        setAttributeTextView(view: tvDescription)
        setAttributeTextView(view: tfArea)
        setAttributeTextView(view: tfPrice)
        setAttributeTextView(view: tfExpirationDate)
        setAttributeTextView(view: tfAddress)
        
        tfArea.delegate = self
        tfPrice.delegate = self
        tfAddress.delegate = self
        tfExpirationDate.delegate = self
        
        tvTitle.delegate = self
        tvDescription.delegate = self
        
        imgAddPhoto.layer.cornerRadius = 8
        imgAddPhoto.layer.borderWidth = 1
        imgAddPhoto.layer.borderColor = UIColor(red: 0.09, green: 0.45, blue: 1, alpha: 1).cgColor
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        
        tfExpirationDate.inputView = datePicker
        
        if edit {
            tvTitle.text = post?.title
            tfAddress.text = post?.address
            tfPrice.text = post?.price.components(separatedBy: " ")[0]
            tfArea.text = post?.area.components(separatedBy: " ")[0]
            
            let year = post?.dateTime.components(separatedBy: "-")[0] ?? ""
            let month = post?.dateTime.components(separatedBy: "-")[1] ?? ""
            let day = post?.dateTime.components(separatedBy: "-")[2] ?? ""
            
            let dateTime = day + "/" + month + "/" + year
            
            tfExpirationDate.text = dateTime
            tvDescription.text = post?.linkDetail
            
            lbTitle.text = "Chỉnh sửa bài viết"
            viewStatus.isHidden = false

            switchStatus.isOn = ((post?.status ?? "") == "0") ? false : true
        }
    }
    
    @objc func dateChange(datePicker: UIDatePicker) {
        tfExpirationDate.endEditing(true)
        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd/MM/YYYY"
        tfExpirationDate.text = formatDate.string(from: datePicker.date)
    }
    
    func setAttributeTextView(view: UIView) {
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.8154367805, green: 0.796557188, blue: 0.8166362047, alpha: 1)
    }
    
    @objc func handleNotification() {
        scrollView.isHidden = !MainScreen.hasAccount
        
        reset()
    }
    
    func reset() {
        tfArea.text = ""
        tfPrice.text = ""
        tfAddress.text = ""
        tfExpirationDate.text = ""
        tvTitle.text = ""
        tvDescription.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if MainScreen.hasAccount {
            scrollView.isHidden = false
        } else {
            scrollView.isHidden = true
            let alert = UIAlertController(title: "Đăng nhập", message: "Đăng nhập tài khoản của bạn để đăng bài", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { _ in
                let storyboard = UIStoryboard(name: "LoginView", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginView")
                loginVC.modalPresentationStyle = .overFullScreen
                loginVC.modalTransitionStyle = .crossDissolve
                self.parent!.present(loginVC, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Huỷ bỏ", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnCompleteClicked(_ sender: Any) {
        if tfAddress.text?.isEmpty ?? false || tfArea.text?.isEmpty ?? false || tfPrice.text?.isEmpty ?? false || tvTitle.text?.isEmpty ?? false || tfExpirationDate.text?.isEmpty ?? false || tvDescription.text?.isEmpty ?? false {
            showStatus(message: "Bạn nhập thiếu thông tin!", lackInfor: true)
        } else {
            
            let message = (!edit) ? "Bạn có chắc muốn đăng bài viết này không?" : "Bạn có chắc đã chỉnh sửa hoàn tất?"
        
            let alert = UIAlertController(title: "Xác nhận", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { [self] _ in
                insertPost()
            }))
            alert.addAction(UIAlertAction(title: "Huỷ bỏ", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func insertPost() {
        var requestURL = URL(string: "")
        
        if !edit {
            requestURL = URL(string: Constant.domain + "final_project/insertPost.php")!
        } else {
            requestURL = URL(string: Constant.domain + "final_project/updateMyPost.php")!
        }
        
        guard let requestURL = requestURL else { return }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let userId = (Int)(Constant.userId) ?? 0
        let area = (tfArea.text ?? "") + " m\u{00B2}"
        let price = (tfPrice.text ?? "") + " triệu/tháng"
        let address = tfAddress.text ?? ""
        var dateTime = tfExpirationDate.text ?? ""
        let title = tvTitle.text ?? ""
        let linkDetail = tvDescription.text ?? ""
        
        let day = dateTime.components(separatedBy: "/")[0]
        let month = dateTime.components(separatedBy: "/")[1]
        let year = dateTime.components(separatedBy: "/")[2]
        
        dateTime = year + "-" + month + "-" + day
        
        var data = ""
        
        var status = "1"
        
        if switchStatus.isOn {
            status = "1"
        } else {
            status = "0"
        }
        
        if edit {
            data = "userId=\(userId)&&address=\(address)&&area=\(area)&&price=\(price)&&dateTime=\(dateTime)&&title=\(title)&&linkDetail=\(linkDetail)&&productId=\(post!.productId)&&status=\(status)"
        } else {
            data = "userId=\(userId)&&address=\(address)&&area=\(area)&&price=\(price)&&dateTime=\(dateTime)&&title=\(title)&&linkDetail=\(linkDetail)"
        }
        
        request.httpBody = data.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.uploadTask(with: request, from: request.httpBody!) { data, response, error in
            DispatchQueue.main.async { [self] in
                if let response = String(data: data ?? Data(), encoding: .utf8) {
                    switch response {
                    case "Error", "Connection Error":
                        print("Lỗi kết nối, vui lòng kiểm tra lại!")
                        
                    default:
                        if !edit {
                            showStatus(message: "Đăng bài viết thành công!", lackInfor: false)
                        } else {
                            showStatus(message: "Chỉnh sửa bài viết thành công!", lackInfor: false)
                        }
                        
                    }
                }
            }
            
        }
        task.resume()
    }
    
    func showStatus(message: String, lackInfor: Bool) {
        let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đồng ý", style: .cancel, handler: { _ in
            if self.edit {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                if !lackInfor {
                    self.reset()
                }
                
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension PostScreen: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension PostScreen: UITextViewDelegate {
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}
