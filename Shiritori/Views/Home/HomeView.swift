//
//  HomeView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/10.
//

import UIKit

class HomeView: UIView {
    // MARK: - Properties
    let middleButtons: HomeButtonView = {
        let buttons = HomeButtonView()
        return buttons
    }()
    
    let bottomButtons: BottomButtonView = {
        let buttons = BottomButtonView()
        return buttons
    }()
    
    let tutorialButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Const.Image.tutorial), for: .normal)
        return button
    }()
    
    let titleView: HomeTitleView = {
        let view = HomeTitleView()
        return view
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 背景画像の設定
        let background = Background(frame: frame)
        
        let mainStack = UIStackView(arrangedSubviews: [titleView, middleButtons, bottomButtons])
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.distribution = .fill
        
        addSubview(background)
        addSubview(mainStack)
        addSubview(tutorialButton)
        
        // 制約
        background.addConstraintsToFillView(self)
        mainStack.addConstraintsToFillView(self)
        mainStack.divide(by: [3, 3, 1], baseHeight: heightAnchor)
        tutorialButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 30, paddingLeft: 30)
        tutorialButton.setAspectRatio(ratio: 1)
        tutorialButton.anchor(width: 40)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
