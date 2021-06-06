//
//  WordCell.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/06/04.
//

import UIKit

class WordCell: UITableViewCell {

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    var flg = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func likePressed(_ sender: UIButton) {
        flg ? likeButton.setImage(K.Images.Stars[0], for: .normal) : likeButton.setImage(K.Images.Stars[1], for: .normal)
        flg = flg ? false : true
    }
    
}
