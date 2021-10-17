//
//  ModeButtonView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/13.
//

import UIKit

class ModeButtonView: UIView {
    // MARK: - Properties
    let easyButton: ModeButton = {
        let button = ModeButton()
        button.setTitle(Const.ButtonText.easy, for: .normal)
        button.setImage(UIImage(named: Const.Image.easy), for: .normal)
        return button
    }()
    
    let normalButton: ModeButton = {
        let button = ModeButton()
        button.setTitle(Const.ButtonText.normal, for: .normal)
        button.setImage(UIImage(named: Const.Image.normal), for: .normal)
        return button
    }()
    
    let hardButton: ModeButton = {
        let button = ModeButton()
        button.setTitle(Const.ButtonText.hard, for: .normal)
        button.setImage(UIImage(named: Const.Image.hard), for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [easyButton, normalButton, hardButton])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 15
        
        addSubview(stack)
        
        stack.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 30, paddingBottom: 10, paddingRight: 30)
        easyButton.setAspectRatio(ratio: 12/5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
