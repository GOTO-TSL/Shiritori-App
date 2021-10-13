//
//  MiddleButtonView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/10.
//

import UIKit

class MiddleButtonView: UIView {
    // MARK: - Properties
    let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("play", for: .normal)
        button.titleLabel?.font = UIFont(name: "DotGothic16-Regular", size: 45)
        button.setBackgroundImage(UIImage(named: "button_frame"), for: .normal)
        return button
    }()
    
    let wordButton: UIButton = {
        let button = UIButton()
        button.setTitle("word", for: .normal)
        button.setBackgroundImage(UIImage(named: "button_frame"), for: .normal)
        button.titleLabel?.font = UIFont(name: "DotGothic16-Regular", size: 45)
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
        playButton.setAspectRatio(ratio: 16/7)
        wordButton.setAspectRatio(ratio: 16/7)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
