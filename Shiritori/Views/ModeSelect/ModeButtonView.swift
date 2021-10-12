//
//  ModeButtonView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/13.
//

import UIKit

class ModeButtonView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let easyButton = ModeButton(frame: frame, mode: "EASY0")
        let normalButton = ModeButton(frame: frame, mode: "NORMAL0")
        let hardButton = ModeButton(frame: frame, mode: "HARD0")
        
        let stack = UIStackView(arrangedSubviews: [easyButton, normalButton, hardButton])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 15
        
        addSubview(stack)
        
        stack.addConstraintsToFillView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
