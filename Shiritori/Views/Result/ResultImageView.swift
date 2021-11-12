//
//  ResultImageView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/15.
//

import UIKit

class ResultImageView: UIView {
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let isWin = UserDefaults.standard.bool(forKey: Const.UDKeys.isWin)
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        if isWin {
            imageView.animation(action: "reward", duration: 0.5)
        } else {
            imageView.animation(action: "result", duration: 0.7)
        }
        
        addSubview(imageView)
        
        imageView.centerX(inView: self)
        imageView.anchor(bottom: bottomAnchor)
        imageView.setAspectRatio(ratio: 1)
        imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/3).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
