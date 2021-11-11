//
//  ResultView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/15.
//

import UIKit

class ResultView: UIView {
    // MARK: - Properties
    let titleView: ResultTitleView = {
        let view = ResultTitleView()
        return view
    }()
    
    let imageView: ResultImageView = {
        let imageView = ResultImageView()
        return imageView
    }()
    
    let buttons: ResultButtonView = {
        let buttons = ResultButtonView()
        return buttons
    }()
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 背景画像の設定
        let background = Background(frame: frame)
        
        configureResultUI()
        
        let stack = UIStackView(arrangedSubviews: [titleView, imageView, buttons])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        
        addSubview(background)
        addSubview(stack)
        
        background.addConstraintsToFillView(self)
        stack.addConstraintsToFillView(self)
        stack.divide(by: [32, 23, 73], baseHeight: heightAnchor)
    }
    
    private func configureResultUI() {
        let isWin = UserDefaults.standard.bool(forKey: Const.UDKeys.isWin)
        // ゲームの結果に応じて画像を変更
        if isWin {
            titleView.title.text = Const.TitleText.resultWin
            imageView.resultImageView.animation(action: "reward", duration: 0.7)
        } else {
            titleView.title.text = Const.TitleText.resultLose
            imageView.resultImageView.animation(action: "result", duration: 0.7)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
