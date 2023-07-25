//
//  LoadImage.swift
//  FinalProject
//
//  Created by ThanDuc on 08/07/2023.
//

import Foundation
import UIKit

import UIKit

class LoadImage {
    
    public static func loadImage(_ url: URL, completion: @escaping (UIImage) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data){
                completion(image)
            }
        }.resume()
        
    }
    
}

