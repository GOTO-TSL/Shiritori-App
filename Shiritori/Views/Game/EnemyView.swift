//
//  EnemyView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/12/19.
//

import UIKit

class EnemyView: UIView {
    // MARK: - Properties
    let enemyImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let damageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Const.font, size: 20)
        label.alpha = 0.0
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame) 
        
        let mode: Mode = UserDefaults.standard.getEnum(forKey: Const.UDKeys.currentMode)!
        enemyImageView.image = UIImage(named: "\(mode)/move0")
        
        addSubview(enemyImageView)
        addSubview(damageLabel)
        
        enemyImageView.addConstraintsToFillView(self)
        enemyImageView.setAspectRatio(ratio: 1)
        damageLabel.anchor(top: enemyImageView.topAnchor, left: enemyImageView.leftAnchor, paddingLeft: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
