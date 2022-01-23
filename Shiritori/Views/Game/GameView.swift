//
//  GameView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/12/19.
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
    
    let timeLimit: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: Const.font, size: 20)
        label.text = "TIME:\(Const.GameParam.timeLimit)"
        return label
    }()
    
    let speechView: SpeechView = {
        let view = SpeechView()
        return view
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
        
        // 上半分のviewの配置
        let topView = UIView()
        topView.addSubview(enemyView)
        topView.addSubview(speechView)
        topView.addSubview(timeLimit)
        
        // 制約を追加
        enemyView.anchor(bottom: topView.bottomAnchor, right: topView.rightAnchor, paddingRight: 10)
        enemyView.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 1/3).isActive = true
        speechView.anchor(left: topView.leftAnchor, bottom: topView.bottomAnchor, right: enemyView.leftAnchor, paddingLeft: 10, paddingBottom: 10)
        speechView.heightAnchor.constraint(equalTo: enemyView.heightAnchor).isActive = true
        timeLimit.anchor(top: topView.topAnchor, left: topView.leftAnchor, bottom: speechView.topAnchor, paddingLeft: 30, paddingBottom: 10)
        
        // 下半分のviewの配置
        let bottomView = UIView()
        bottomView.addSubview(userInputView)
        userInputView.addConstraintsToFillView(bottomView)
        
        // メインのstackView
        let mainStack = UIStackView(arrangedSubviews: [UIView(), topView, bottomView])
        mainStack.alignment = .fill
        mainStack.distribution = .fill
        mainStack.axis = .vertical
        
        addSubview(background)
        addSubview(mainStack)
        addSubview(backButton)
        
        background.addConstraintsToFillView(self)
        mainStack.addConstraintsToFillView(self)
        mainStack.divide(by: [20, 35, 73], baseHeight: heightAnchor)
        backButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 50, paddingLeft: 30)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
