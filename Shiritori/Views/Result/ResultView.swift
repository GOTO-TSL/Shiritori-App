//
//  ResultView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/15.
//

import UIKit

class ResultView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let background = Background(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [ResultTitleView(), ResultImageView(), MiddleButtonView(frame: frame, upperName: Const.ButtonText.word, lowerName: Const.ButtonText.home)])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        
        addSubview(background)
        addSubview(stack)
        
        background.addConstraintsToFillView(self)
        stack.addConstraintsToFillView(self)
        stack.divide(by: [32, 23, 73], baseHeight: heightAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
