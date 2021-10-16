//
//  Background.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/14.
//

import UIKit

class Background: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        image = UIImage(named: Const.Image.background)
        contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
