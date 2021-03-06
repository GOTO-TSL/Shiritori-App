//
//  GameView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/14.
//

import UIKit

class GameView: UIView {
    // MARK: - Properties
    let backButton: BackButton = {
        let button = BackButton()
        button.setImage(UIImage(named: Const.Image.backB), for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let enemyView: EnemyView = {
        let view = EnemyView()
        return view
    }()
    
    let userInputView: InputView = {
        let view = InputView()
        return view
    }()
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 背景画像の設定
        let background = Background(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [UIView(), enemyView, userInputView])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        
        addSubview(background)
        addSubview(stack)
        addSubview(backButton)
        
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
