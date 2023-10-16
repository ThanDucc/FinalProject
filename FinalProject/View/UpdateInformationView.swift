//
//  UpdateInformationScreen.swift
//  FinalProject
//
//  Created by ThanDuc on 06/08/2023.
//

import UIKit

class UpdateInformationView: UIViewController {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfBirthOfDate: UITextField!
    @IBOutlet weak var tfCareer: UITextField!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfMaxPrice: UITextField!
    @IBOutlet weak var tfMinArea: UITextField!
    @IBOutlet weak var imgAddPhoto: UIImageView!
    
    @IBOutlet weak var lbArea: UILabel!
    
    @IBOutlet weak var label: UILabel!
    
    var userInfor: UserInfor?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tabBarController = MainScreen.tabbar
        if tabBarController!.overrideUserInterfaceStyle == .dark {
            self.overrideUserInterfaceStyle = .dark
        } else if tabBarController?.overrideUserInterfaceStyle == .light {
            self.overrideUserInterfaceStyle = .light
        }
        
        lbArea.text = "m\u{00B2}"
        
        imgAddPhoto.layer.cornerRadius = 8
        imgAddPhoto.layer.borderWidth = 1
        imgAddPhoto.layer.borderColor = UIColor(red: 0.09, green: 0.45, blue: 1, alpha: 1).cgColor
        
        setAttributeTextView(view: tfName)
        setAttributeTextView(view: tfBirthOfDate)
        setAttributeTextView(view: tfCareer)
        setAttributeTextView(view: tfPhoneNumber)
        setAttributeTextView(view: tfEmail)
        setAttributeTextView(view: tfAddress)
        setAttributeTextView(view: tfMaxPrice)
        setAttributeTextView(view: tfMinArea)
        
        tfName.delegate = self
        tfBirthOfDate.delegate = self
        tfCareer.delegate = self
        tfPhoneNumber.delegate = self
        tfEmail.delegate = self
        tfAddress.delegate = self
        tfMaxPrice.delegate = self
        tfMinArea.delegate = self
        
        getInfor()
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        
        tfBirthOfDate.inputView = datePicker
    
    }
    
    @objc func dateChange(datePicker: UIDatePicker) {
        tfBirthOfDate.endEditing(true)
        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd/MM/YYYY"
        tfBirthOfDate.text = formatDate.string(from: datePicker.date)
    }
    
    func setAttributeTextView(view: UIView) {
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.8154367805, green: 0.796557188, blue: 0.8166362047, alpha: 1)
    }
    
    func getInfor() {
        let requestURL = URL(string: Constant.domain + "final_project/getUserInfor.php")!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"

        let data = "userId=\(Constant.userId)"
        
        request.httpBody = data.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.uploadTask(with: request, from: request.httpBody!) { data, response, error in
            DispatchQueue.main.async { [self] in
                if let response = String(data: data ?? Data(), encoding: .utf8) {
                    switch response {
                    case "Error":
                        label.text = "Lỗi kết nối, vui lòng kiểm tra lại!"
                        
                    default:
                        guard let data = data else { return }
                        guard let infor = try? JSONDecoder().decode([UserInfor].self, from: data) else { return }
                        
                        DispatchQueue.main.async {
                            if !infor.isEmpty {
                                self.userInfor = infor[0]
                                tfName.text = userInfor?.name ?? ""
                                tfBirthOfDate.text = userInfor?.date_of_birth ?? ""
                                tfCareer.text = userInfor?.career ?? ""
                                tfPhoneNumber.text = userInfor?.phone_number ?? ""
                                tfEmail.text = userInfor?.email ?? ""
                                tfAddress.text = userInfor?.address ?? ""
                                tfMaxPrice.text = userInfor?.price ?? ""
                                tfMinArea.text = userInfor?.area ?? ""
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
        
        MainScreen.tabbar?.tabBar.isHidden = true
    }
    
    @IBAction func btnDone(_ sender: Any) {
        label.text = ""
        updateInfor()
    }
    
    func updateInfor() {
        let requestURL = URL(string: Constant.domain + "final_project/updateInfor.php")!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let name = tfName.text ?? ""
        let date_of_birth = tfBirthOfDate.text ?? ""
        let career = tfCareer.text ?? ""
        let phone_number = tfPhoneNumber.text ?? ""
        let email = tfEmail.text ?? ""
        let address = tfAddress.text ?? ""
        let maxPrice = tfMaxPrice.text ?? ""
        let area = tfMinArea.text ?? ""
          
        let data = "userId=\(Constant.userId)&&name=\(name)&&date_of_birth=\(date_of_birth)&&career=\(career)&&phone_number=\(phone_number)&&email=\(email)&&address=\(address)&&price=\(maxPrice)&&area=\(area)"
        
        request.httpBody = data.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.uploadTask(with: request, from: request.httpBody!) { data, response, error in
            DispatchQueue.main.async { [self] in
                if let response = String(data: data ?? Data(), encoding: .utf8) {
                    switch response {
                    case "Connection Error":
                        label.text = "Lỗi kết nối, vui lòng kiểm tra lại!"
                        
                    case "Failed to register":
                        label.text = "Cập nhật thông tin thất bại!"
                        
                    default:
                        label.text = "Cập nhật thông tin thành công!"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
            
        }
        task.resume()
    }
    
}

extension UpdateInformationView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
