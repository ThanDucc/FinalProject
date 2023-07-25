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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lbTitle.font = UIFont.boldSystemFont(ofSize: lbTitle.font.pointSize)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
