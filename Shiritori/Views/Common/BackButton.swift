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
        
        imageView?.widthAnchor.constraint(equalTo: titleLabel!.widthAnchor, multiplier: 1/2).isActive = true
        imageView?.setAspectRatio(ratio: 1)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
