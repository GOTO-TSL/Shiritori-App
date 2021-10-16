//
//  GameView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/14.
//

import UIKit

class GameView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 背景画像の設定
        let background = Background(frame: frame)
        // 戻るボタン
        let backButton = BackButton(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [UIView(), EnemyView(), InputView()])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        
        addSubview(background)
        addSubview(backButton)
        addSubview(stack)
        
        // 制約の追加
        background.addConstraintsToFillView(self)
        backButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 50, paddingLeft: 30)
        stack.addConstraintsToFillView(self)
        stack.divide(by: [20, 35, 73], baseHeight: heightAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
