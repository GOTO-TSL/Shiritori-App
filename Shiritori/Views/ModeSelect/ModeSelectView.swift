//
//  ModeSelectView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/12.
//

import UIKit

class ModeSelectView: UIView {
    // MARK: - Properties
    let modeButtons: ModeButtonView = {
        let buttons = ModeButtonView()
        return buttons
    }()
    
    let backButton: BackButton = {
        let button = BackButton()
        button.setImage(UIImage(named: Const.Image.backB), for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        // タイトル
        let titleLabel = UILabel()
        titleLabel.text = Const.TitleText.mode
        titleLabel.font = UIFont(name: Const.font, size: 45)
        titleLabel.textAlignment = .center
        
        // 背景画像の設定
        let background = Background(frame: frame)
        
        // 上下のスペース
        let topSpace = UIView()
        let bottomSpace = UIView()
        
        // メインのスタック
        let mainStack = UIStackView(arrangedSubviews: [topSpace, titleLabel, modeButtons, bottomSpace])
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.distribution = .fill
        
        addSubview(background)
        addSubview(mainStack)
        addSubview(backButton)
         
        // 制約
        background.addConstraintsToFillView(self)
        backButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 50, paddingLeft: 30)
        mainStack.addConstraintsToFillView(self)
        topSpace.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/6.5).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/6).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
