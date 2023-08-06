//
//  PeopleScreenController.swift
//  MovieApplication
//
//  Created by thanpd on 08/05/2023.
//

import UIKit

class PostScreen: UIViewController {
        
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tvTitle: UITextView!
    @IBOutlet weak var lbArea: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var tfArea: UITextField!
    @IBOutlet weak var tfExpirationDate: UITextField!
    
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var imgAddPhoto: UIImageView!
    
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
        setAttributeTextView(view: tfEmail)
        setAttributeTextView(view: tfPhoneNumber)
        
        tfArea.delegate = self
        tfEmail.delegate = self
        tfPrice.delegate = self
        tfPhoneNumber.delegate = self
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
        
    }
    
    @objc func dateChange(datePicker: UIDatePicker) {
        tfExpirationDate.endEditing(true)
        let formatDate = DateFormatter()
        formatDate.dateFormat = " dd/MM/YYYY"
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
        tfEmail.text = ""
        tfPrice.text = ""
        tfPhoneNumber.text = ""
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
        let alert = UIAlertController(title: "Cảnh báo", message: "Bạn có chắc đã muốn đăng bài viết này không?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { _ in
            self.reset()
        }))
        alert.addAction(UIAlertAction(title: "Huỷ bỏ", style: .default, handler: nil))
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
