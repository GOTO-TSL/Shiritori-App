//
//  RuleBodyView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/17.
//

import UIKit

class RuleBodyView: UIView {
    
    let body: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Const.font, size: 20)
        label.text = Const.BodyText.rule
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(body)
        
        body.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 30, paddingLeft: 30, paddingRight: 30)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
