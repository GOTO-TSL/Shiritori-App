//
//  BackButton.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/14.
//

import UIKit

class BackButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitle(Const.ButtonText.back, for: .normal)
        titleLabel?.font = UIFont(name: Const.font, size: 20)
        
        imageView?.anchor(width: 30)
        imageView?.setAspectRatio(ratio: 1)
        imageView?.anchor(top: topAnchor, left: leftAnchor)
        
        setDimensions(width: 75, height: 30)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
