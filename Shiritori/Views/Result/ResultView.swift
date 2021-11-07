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
    init(frame: CGRect, isWin: Bool, mode: Mode) {
        super.init(frame: frame)
        
        // 背景画像の設定
        let background = Background(frame: frame)
        
        configureResultUI(isWin: isWin, mode: mode)
        
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
    
    private func configureResultUI(isWin: Bool, mode: Mode) {
        // ゲームの結果に応じて画像を変更
        if isWin {
            titleView.title.text = Const.TitleText.resultWin
            imageView.resultImageView.animation(mode: mode, action: "result_win", duration: 0.7)
        } else {
            titleView.title.text = Const.TitleText.resultLose
            imageView.resultImageView.animation(mode: mode, action: "result", duration: 0.7)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
