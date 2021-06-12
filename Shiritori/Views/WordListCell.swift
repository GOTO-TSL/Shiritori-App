//
//  WordListCell.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/06/11.
//

import UIKit

class WordListCell: UITableViewCell {

    @IBOutlet weak var WordLabel: UILabel!
    @IBOutlet weak var StarImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
