//
//  ModeButtonView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/13.
//

import UIKit

class ModeButtonView: UIView {
    // MARK: - Properties
    let easyButton: ModeButton = {
        let button = ModeButton()
        button.setTitle(Const.ButtonText.easy, for: .normal)
        button.setImage(UIImage(named: Const.Image.easy), for: .normal)
        return button
    }()
    
    let normalButton: ModeButton = {
        let button = ModeButton()
        button.setTitle(Const.ButtonText.normal, for: .normal)
        button.setImage(UIImage(named: Const.Image.normal), for: .normal)
        return button
    }()
    
    let hardButton: ModeButton = {
        let button = ModeButton()
        button.setTitle(Const.ButtonText.hard, for: .normal)
        button.setImage(UIImage(named: Const.Image.hard), for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureModeButton()
        
        let stack = UIStackView(arrangedSubviews: [easyButton, normalButton, hardButton])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 15
        
        addSubview(stack)
        
//        stack.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 30, paddingBottom: 10, paddingRight: 30)
        stack.addConstraintsToFillView(self)
        easyButton.setAspectRatio(ratio: 12/5)
    }
    
    private func configureModeButton() {
        let defaults = UserDefaults.standard
        let isWinEasy = defaults.bool(forKey: Const.UDKeys.isWinEasy)
        let isWinNormal = defaults.bool(forKey: Const.UDKeys.isWinNormal)
        let isWinHard = defaults.bool(forKey: Const.UDKeys.isWinHard)
        
        if isWinEasy {
            addClearLabel(for: easyButton)
            if isWinNormal {
                addClearLabel(for: normalButton)
                if isWinHard {
                    addClearLabel(for: hardButton)
                }
            } else {
                addModeLockView(for: hardButton)
            }
        } else {
            addModeLockView(for: normalButton)
            addModeLockView(for: hardButton)
        }
    }
    
    private func addModeLockView(for button: UIButton) {
        let lockView = UIView()
        lockView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.6)
        button.addSubview(lockView)
        lockView.addConstraintsToFillView(button)
    }
    
    private func addClearLabel(for button: UIButton) {
        let clearLabel = UILabel()
        clearLabel.text = "CLEAR!"
        clearLabel.font = UIFont(name: Const.font, size: 20)
        clearLabel.textColor = .white
        button.addSubview(clearLabel)
        clearLabel.anchor(top: button.topAnchor, left: button.leftAnchor, paddingTop: 10, paddingLeft: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
