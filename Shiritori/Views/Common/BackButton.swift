//
//  BackButton.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/14.
//

import UIKit

class BackButton: UIButton {
    
    init(frame: CGRect, isBlack: Bool = true) {
        super.init(frame: frame)
        
        setTitle(Const.ButtonText.back, for: .normal)
        titleLabel?.font = UIFont(name: Const.font, size: 20)
        
        if isBlack {
            setImage(UIImage(named: Const.Image.backB), for: .normal)
            setTitleColor(.black, for: .normal)
        } else {
            setImage(UIImage(named: Const.Image.backW), for: .normal)
            setTitleColor(.white, for: .normal)
        }
        
        imageView?.widthAnchor.constraint(equalTo: titleLabel!.widthAnchor, multiplier: 1/2).isActive = true
        imageView?.setAspectRatio(ratio: 1)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
