//
//  RewardButton.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/11/11.
//

import UIKit

class RewardButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setImage(UIImage(named: Const.Image.reward0), for: .normal)
        contentMode = .scaleAspectFit
        setAspectRatio(ratio: 1)
        addTarget(self, action: #selector(pressed(_ :)), for: .touchUpInside)
    }
    
    // リワードがタップされたときの処理
    @objc func pressed(_ sender: UIButton) {
        // タップの回数に応じて画像を変更し，色を変える
        switch sender.tag {
        case 0:
            sender.setImage(UIImage(named: Const.Image.reward1), for: .normal)
            sender.tag = 1
        case 1:
            sender.setImage(UIImage(named: Const.Image.reward2), for: .normal)
            sender.tag = 2
        case 2:
            sender.setImage(UIImage(named: Const.Image.reward0), for: .normal)
            sender.tag = 0
        default:
            sender.setImage(UIImage(named: Const.Image.reward1), for: .normal)
            sender.tag = 1
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
