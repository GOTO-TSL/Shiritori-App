//
//  RuleView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/16.
//

import UIKit

class RuleView: UIView {
    // MARK: - Properties
    let headerView: HeaderView = {
        let headerView = HeaderView()
        return headerView
    }()
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let bodyView = BodyScrollView()
        bodyView.bodyLabel.text = Const.BodyText.rule
        
        headerView.titleLabel.text = Const.TitleText.rule
        
        let stack = UIStackView(arrangedSubviews: [headerView, bodyView])
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
