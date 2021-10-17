//
//  ModeButton.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/13.
//

import UIKit

class ModeButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setBackgroundImage(UIImage(named: Const.Image.modeFrame), for: .normal)
        titleLabel?.font = UIFont(name: Const.font, size: 50)
        
        imageView?.centerY(inView: self)
        imageView?.anchor(left: leftAnchor, paddingLeft: 20)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
