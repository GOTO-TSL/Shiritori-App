//
//  MiddleButtonView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/10.
//

import UIKit

class HomeButtonView: UIView {
    
    let playButton: SelectButton = {
        let button = SelectButton()
        button.setTitle(Const.ButtonText.play, for: .normal)
        return button
    }()
    
    let wordButton: SelectButton = {
        let button = SelectButton()
        button.setTitle(Const.ButtonText.word, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [playButton, wordButton])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 30
        
        addSubview(stack)
        
        stack.center(inView: self)
        stack.anchor(width: 140)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
