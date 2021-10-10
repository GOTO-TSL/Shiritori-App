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
        button.setImage(UIImage(named: "sound_icon16"), for: .normal)
        return button
    }()
    
    let helpButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "help_icon16"), for: .normal)
        return button
    }()
    
    let rankingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ranking_icon16"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [soundButton, helpButton, rankingButton])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        
        addSubview(stack)
        
        stack.addConstraintsToFillView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
