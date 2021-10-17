//
//  TableHeaderView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/16.
//

import UIKit

class HeaderView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Const.font, size: 30)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        
        let backButton = BackButton(frame: frame, isBlack: false)
        
        addSubview(backButton)
        addSubview(titleLabel)
        
        backButton.centerY(inView: self, constant: 10)
        backButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/5).isActive = true
        backButton.anchor(left: leftAnchor)
        titleLabel.centerX(inView: self)
        titleLabel.centerY(inView: self, constant: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}