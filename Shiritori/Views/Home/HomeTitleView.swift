//
//  TopTitleView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/10.
//

import UIKit

class HomeTitleView: UIView {
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // メインタイトルの設定
        let mainTitle = UILabel()
        mainTitle.font = UIFont(name: Const.font, size: 40)
        mainTitle.text = Const.TitleText.main
        mainTitle.textAlignment = .center
        
        // サブタイトルの設定
        let subTitle = UILabel()
        subTitle.font = UIFont(name: Const.font, size: 15)
        subTitle.text = Const.TitleText.sub
        subTitle.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [mainTitle, subTitle])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        
        addSubview(stack)
        
        stack.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
