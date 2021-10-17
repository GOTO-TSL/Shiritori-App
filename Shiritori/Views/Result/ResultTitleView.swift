//
//  ResultTitleView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/15.
//

import UIKit

class ResultTitleView: UIView {
    // MARK: - Properties
    let title: UILabel = {
        let label = UILabel()
        label.text = Const.TitleText.resultWin
        label.font = UIFont(name: Const.font, size: 45)
        label.textAlignment = .center
        return label
    }()
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(title)
        
        title.centerX(inView: self)
        title.anchor(bottom: bottomAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
