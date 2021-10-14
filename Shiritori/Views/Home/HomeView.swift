//
//  HomeView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/10.
//

import UIKit

class HomeView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let background = Background(frame: frame)
        
        let mainStack = UIStackView(arrangedSubviews: [TopTitleView(), MiddleButtonView(), BottomButtonView()])
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.distribution = .fill
        
        addSubview(background)
        addSubview(mainStack)
        
        background.addConstraintsToFillView(self)
        mainStack.addConstraintsToFillView(self)
        mainStack.divide(by: [3, 3, 1], baseHeight: heightAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
