//
//  InputView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/14.
//

import UIKit

class InputView: UIView {
    
    let answerTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "入力してね"
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        textField.layer.borderColor = UIColor.black.cgColor
        return textField
    }()
    
    let answerButton: UIButton = {
        let button = UIButton()
        button.setTitle("ATK", for: .normal)
        button.backgroundColor = .red
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [answerTextField, answerButton])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 10
        
        addSubview(stack)
        
        stack.centerX(inView: self)
        stack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 30, paddingRight: 30)
        answerButton.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 1/8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
