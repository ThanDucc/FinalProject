//
//  WebViewCell.swift
//  FinalProject
//
//  Created by ThanDuc on 16/07/2023.
//

import UIKit
import WebKit

class WebViewCell: UICollectionViewCell {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var webView: WKWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        webView.isHidden = true
        indicator.startAnimating()
        indicator.isHidden = false
        
        DispatchQueue.global().async {
            if let urlRequest = URL(string: PostDetailData.shared.urlVideo) {
                let request = URLRequest(url: urlRequest)
                DispatchQueue.main.async { [self] in
                    self.webView.load(request)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        indicator.stopAnimating()
                        indicator.isHidden = true
                        webView.isHidden = false
                    })
                }
            }
        }

    }

}
