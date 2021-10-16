//
//  HPView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/14.
//

import UIKit

class HPView: UIView {
    
    let hpImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Const.Image.hpFrame)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let hpBar: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = .green
        return progressView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        hpBar.progress = 1
        
        addSubview(hpImageView)
        addSubview(hpBar)
        bringSubviewToFront(hpImageView)
        
        hpImageView.addConstraintsToFillView(self)
        hpBar.centerY(inView: hpImageView)
        hpBar.anchor(left: hpImageView.leftAnchor, right: hpImageView.rightAnchor, height: 15)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
