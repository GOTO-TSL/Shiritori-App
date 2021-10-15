//
//  ResultImageView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/15.
//

import UIKit

class ResultImageView: UIView {
    
    let resultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "result1-1")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(resultImageView)
        
        resultImageView.centerX(inView: self)
        resultImageView.anchor(bottom: bottomAnchor)
        resultImageView.setAspectRatio(ratio: 1)
        resultImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/3).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
