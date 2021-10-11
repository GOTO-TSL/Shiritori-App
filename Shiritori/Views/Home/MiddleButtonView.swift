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
        button.titleLabel?.font = UIFont(name: "DotGothic16-Regular", size: 35)
        button.setBackgroundImage(UIImage(named: "frame16-7"), for: .normal)
        return button
    }()
    
    let wordButton: UIButton = {
        let button = UIButton()
        button.setTitle("word", for: .normal)
        button.titleLabel?.font = UIFont(name: "DotGothic16-Regular", size: 35)
        button.setBackgroundImage(UIImage(named: "frame16-7"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [playButton, wordButton])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        
        addSubview(stack)
        
        stack.centerX(inView: self, topAnchor: topAnchor, paddingTop: 80)
        playButton.setDimensions(width: 120, height: 120)
        wordButton.setDimensions(width: 120, height: 120)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
