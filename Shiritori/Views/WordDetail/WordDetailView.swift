//
//  WordDetailView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/17.
//

import UIKit

class WordDetailView: UIView {
    
    let headerView: HeaderView = {
        let headerView = HeaderView()
        return headerView
    }()
    
    let wordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Const.font, size: 35)
        label.text = "Word"
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let bodyView: BodyScrollView = {
        let bodyView = BodyScrollView()
        return bodyView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        headerView.titleLabel.text = Const.TitleText.detail
        
        let stack = UIStackView(arrangedSubviews: [headerView, wordLabel, bodyView])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        
        addSubview(stack)
        
        stack.addConstraintsToFillView(self)
        stack.divide(by: [1, 1, 6.5], baseHeight: heightAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
