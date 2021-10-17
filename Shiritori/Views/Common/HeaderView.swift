//
//  TableHeaderView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/16.
//

import UIKit

class HeaderView: UIView {
    // MARK: - Properties
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Const.font, size: 30)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let backButton: BackButton = {
        let button = BackButton()
        button.setImage(UIImage(named: Const.Image.backW), for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        
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
