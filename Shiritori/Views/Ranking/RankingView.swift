//
//  RankingView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/17.
//

import UIKit

class RankingView: UIView {
    // MARK: - Properties
    let headerView: HeaderView = {
        let headerView = HeaderView()
        return headerView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Const.font, size: 30)
        label.textColor = .white
        label.text = Const.BodyText.cms
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // ヘッダーにタイトルを設定
        headerView.titleLabel.text = Const.TitleText.ranking
        
        let bodyView = UIView()
        bodyView.addSubview(label)
        
        let stack = UIStackView(arrangedSubviews: [headerView, bodyView])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        
        addSubview(stack)
        
        stack.addConstraintsToFillView(self)
        stack.divide(by: [1, 7.5], baseHeight: heightAnchor)
        label.center(inView: bodyView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
