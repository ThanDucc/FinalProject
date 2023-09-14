//
//  PostCell.swift
//  FinalProject
//
//  Created by ThanDuc on 08/07/2023.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbArea: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbDateTime: UILabel!
    
    @IBOutlet weak var btnSaved: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var saved = false
    var productId = ""
    
    enum viewController {
        case SearchScreen
        case LibraryScreen
    }
    
    var sourceViewController: UIViewController?
    
    var screen: viewController = .SearchScreen
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lbTitle.font = UIFont.boldSystemFont(ofSize: lbTitle.font.pointSize)
        
        indicator.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var savedClick: (() -> Void)?
    
    @IBAction func btnSaved(_ sender: Any) {
        saved = !saved
        
        func remove(completion: @escaping() -> Void) {
            updateSaved(productId: productId, status: .remove) { [self] result in
                if result {
                    btnSaved.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
                } else {
                    print("Error")
                }
                completion()
            }
        }
        
        if saved {
            updateSaved(productId: productId, status: .insert) { [self] result in
                if result {
                    btnSaved.setBackgroundImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                } else {
                    print("Error")
                }
                self.savedClick?()
            }
        } else {
            if screen == .LibraryScreen {
                let alert = UIAlertController(title: "Xác nhận", message: "Bạn có chắc muốn xoá khỏi danh sách đã lưu không?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { _ in 
                    remove(completion: {
                        self.savedClick?()
                    })
                }))
                alert.addAction(UIAlertAction(title: "Huỷ bỏ", style: .default, handler: { _ in
                    self.saved = !self.saved
                }))
                sourceViewController?.present(alert, animated: true, completion: nil)
            } else {
                remove(completion: {
                    self.savedClick?()
                })
            }
        }
    
    }
    
    func updateSaved(productId: String, status save: Saved, completion: @escaping (Bool) -> Void) {
        var requestURL = URL(string: "")
        
        btnSaved.isHidden = true
        indicator.isHidden = false
        indicator.startAnimating()
        
        switch save {
        case .insert:
            requestURL = URL(string: Constant.domain + "final_project/insertSaved.php")!
        case .remove:
            requestURL = URL(string: Constant.domain + "final_project/removeSaved.php")!
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
                            indicator.stopAnimating()
                            indicator.isHidden = true
                        default:
                            completion(false)
                            
                            btnSaved.isHidden = false
                            indicator.stopAnimating()
                            indicator.isHidden = true
                        }
                    }
                }
            
        }
        task.resume()
    }
}


enum Saved {
    case insert
    case remove
}
