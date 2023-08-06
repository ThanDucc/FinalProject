//
//  PostCollectionCell.swift
//  FinalProject
//
//  Created by ThanDuc on 05/08/2023.
//

import UIKit

class PostCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var lbDateTime: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var lbArea: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lbPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lbTitle.font = UIFont.boldSystemFont(ofSize: lbTitle.font.pointSize)
        lbTitle.textColor = .label
    }

}
