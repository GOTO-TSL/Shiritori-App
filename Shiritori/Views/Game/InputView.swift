//
//  InputView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/14.
//

import UIKit

class InputView: UIView {
    // MARK: - Properties
    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Const.placeholder
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        textField.layer.borderColor = UIColor.black.cgColor
        // 自動で大文字になる設定, 自動で変換する設定を解除
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    let attackButton: UIButton = {
        let button = UIButton()
        button.setTitle(Const.ButtonText.atk, for: .normal)
        button.titleLabel?.font = UIFont(name: Const.font, size: 20)
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = .red
        return button
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [textField, attackButton])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 10
        
        addSubview(stack)
        
        stack.centerX(inView: self)
        stack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 30, paddingRight: 30)
        attackButton.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 1/8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
