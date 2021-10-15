//
//  MiddleButtonView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/10.
//

import UIKit

class MiddleButtonView: UIView {
    
    init(frame: CGRect, upperName: String, lowerName: String) {
        super.init(frame: frame)
        
        let playButton = SelectButton()
        playButton.setTitle(upperName, for: .normal)
        
        let wordButton = SelectButton()
        wordButton.setTitle(lowerName, for: .normal)
        
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
