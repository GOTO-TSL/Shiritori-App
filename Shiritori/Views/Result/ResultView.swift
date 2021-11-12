//
//  ResultView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/15.
//

import UIKit

class ResultView: UIView {
    // MARK: - Properties
    let buttons: ResultButtonView = {
        let buttons = ResultButtonView()
        return buttons
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 背景画像の設定
        let background = Background(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [ResultTitleView(), ResultImageView(), buttons])
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
