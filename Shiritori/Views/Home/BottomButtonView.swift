//
//  BottomButtonView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/10.
//

import UIKit

class BottomButtonView: UIView {
    // MARK: - Properties
    let soundButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setImage(UIImage(named: "sound_icon16"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    let helpButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "help_icon16"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    let rankingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ranking_icon16"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [soundButton, helpButton, rankingButton])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 80
        
        addSubview(stack)
        
        stack.center(inView: self)
        stack.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 30, paddingLeft: 60, paddingBottom: 30, paddingRight: 60)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
