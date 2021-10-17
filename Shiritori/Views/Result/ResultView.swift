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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let background = Background(frame: frame)
        
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
