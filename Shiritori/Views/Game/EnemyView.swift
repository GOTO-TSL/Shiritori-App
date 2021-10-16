//
//  WordView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/14.
//

import UIKit

class EnemyView: UIView {
    
    let enemyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "slime2-1")
        return imageView
    }()
    
    let speechBalloon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "speechballoon2")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let wordLabel: UILabel = {
        let label = UILabel()
        label.text = "hello!"
        label.textColor = .white
        label.font = UIFont(name: Const.font, size: 20)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let hpView = HPView()
        
        addSubview(hpView)
        addSubview(enemyImageView)
        addSubview(speechBalloon)
        addSubview(wordLabel)
        
        enemyImageView.anchor(bottom: bottomAnchor, right: rightAnchor, paddingRight: 10)
        enemyImageView.setAspectRatio(ratio: 1)
        enemyImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/3).isActive = true
        speechBalloon.anchor(left: leftAnchor, bottom: bottomAnchor, right: enemyImageView.leftAnchor, paddingLeft: 10, paddingBottom: 10)
        speechBalloon.heightAnchor.constraint(equalTo: enemyImageView.heightAnchor).isActive = true
        wordLabel.center(inView: speechBalloon)
        hpView.anchor(top: topAnchor, left: speechBalloon.rightAnchor, bottom: enemyImageView.topAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: -20, paddingRight: 10)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}