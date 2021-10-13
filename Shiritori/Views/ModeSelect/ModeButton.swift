//
//  ModeButton.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/13.
//

import UIKit

class ModeButton: UIButton {
    
    init(frame: CGRect, mode: String) {
        super.init(frame: frame)
        
        setTitle(mode, for: .normal)
        setImage(UIImage(named: mode), for: .normal)
        setBackgroundImage(UIImage(named: "mode_frame"), for: .normal)
        titleLabel?.font = UIFont(name: Const.font, size: 50)
        
        imageView?.centerY(inView: self)
        imageView?.anchor(left: leftAnchor, paddingLeft: 20)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
