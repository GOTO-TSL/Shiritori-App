//
//  BodyScrollView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/17.
//

import UIKit

class BodyScrollView: UIView {
    // MARK: - Properties
    // 本文のラベル
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Const.font, size: 20)
        label.text = Const.BodyText.text
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 本文のView
        let bodyView = UIView()
        bodyView.addSubview(bodyLabel)
        
        // ScrollViewに本文を追加し配置
        let scrollView = UIScrollView()
        scrollView.addSubview(bodyView)
        
        addSubview(scrollView)
        
        // 制約をつける
        bodyLabel.anchor(top: bodyView.topAnchor, left: bodyView.leftAnchor, right: bodyView.rightAnchor, paddingTop: 30, paddingLeft: 30, paddingRight: 30)
        bodyView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor)
        bodyView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        bodyView.heightAnchor.constraint(equalTo: bodyLabel.heightAnchor).isActive = true
        scrollView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 20, paddingRight: 20)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
