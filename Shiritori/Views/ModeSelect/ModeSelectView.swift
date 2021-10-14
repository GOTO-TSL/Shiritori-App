//
//  ModeSelectView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/12.
//

import UIKit

class ModeSelectView: UIView {
    // 戻るボタン
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back_icon"), for: .normal)
        button.setTitle("back", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: Const.font, size: 20)
        return button
    }()
    // タイトル
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Const.Title.mode
        label.font = UIFont(name: Const.font, size: 45)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 背景画像の設定
        let backgroundImage = UIImage(named: "background128")
        let bgImageView = UIImageView(image: backgroundImage)
        bgImageView.contentMode = .scaleAspectFill
        
        // 上下のスペース
        let topSpace = UIView()
        let bottomSpace = UIView()
        
        // メインのスタック
        let mainStack = UIStackView(arrangedSubviews: [topSpace, titleLabel, ModeButtonView(), bottomSpace])
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.distribution = .fill
        
        addSubview(bgImageView)
        addSubview(backButton)
        addSubview(mainStack)
         
        // 制約
        bgImageView.addConstraintsToFillView(self)
        backButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 50, paddingLeft: 30)
        mainStack.addConstraintsToFillView(self)
        topSpace.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/6.5).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/6).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
