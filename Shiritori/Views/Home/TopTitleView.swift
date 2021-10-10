//
//  TopTitleView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/10.
//

import UIKit

class TopTitleView: UIView {
    // MARK: - Properties
    let mainTitle: UILabel = {
        let label = UILabel()
        label.text = Constant.Texts.mainTitle
        return label
    }()
    
    let subTitle: UILabel = {
        let label = UILabel()
        label.text = Constant.Texts.subTitle
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [mainTitle, subTitle])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        
        addSubview(stack)
        
        stack.addConstraintsToFillView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
