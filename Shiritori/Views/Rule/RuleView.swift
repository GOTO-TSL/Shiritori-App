//
//  RuleView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/16.
//

import UIKit

class RuleView: UIView {
    
    let headerView: TableHeaderView = {
        let headerView = TableHeaderView()
        return headerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        headerView.titleLabel.text = Const.TitleText.rule
        
        let stack = UIStackView(arrangedSubviews: [headerView, RuleBodyView()])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        
        addSubview(stack)
        
        stack.addConstraintsToFillView(self)
        stack.divide(by: [1, 7.5], baseHeight: heightAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
