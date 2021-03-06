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
        button.setImage(UIImage(named: Const.Image.sound), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    let helpButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Const.Image.help), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    let rankingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Const.Image.ranking), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [soundButton, helpButton, rankingButton])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 80
        
        addSubview(stack)
        
        stack.center(inView: self)
        stack.anchor(height: 50)
        [soundButton, helpButton, rankingButton].forEach { $0.setAspectRatio(ratio: 1) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
