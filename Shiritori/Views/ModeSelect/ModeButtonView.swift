//
//  ModeButtonView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/13.
//

import UIKit

class ModeButtonView: UIView {
    // MARK: - Properties
    let buttons: [UIButton] = {
        var buttons = [UIButton]()
        for btnTitle in Const.ButtonText.btnTitles {
            let button = ModeButton()
            button.setTitle(btnTitle, for: .normal)
            buttons.append(button)
        }
        return buttons
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureModeButton()
        
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 15
        
        addSubview(stack)
        
        stack.addConstraintsToFillView(self)
        buttons[0].setAspectRatio(ratio: 18/6)
    }
    // 勝利状況に応じてボタンにラベルを付与
    private func configureModeButton() {
        let defaults = UserDefaults.standard
        let isWinEasy = defaults.bool(forKey: Const.UDKeys.isWinEasy)
        let isWinNormal = defaults.bool(forKey: Const.UDKeys.isWinNormal)
        let isWinHard = defaults.bool(forKey: Const.UDKeys.isWinHard)
        // TODO: ネストが深くなってる＋可読性が悪いのでなんとかしたい
        if isWinEasy {
            addClearLabel(for: buttons[0])
            if isWinNormal {
                addClearLabel(for: buttons[1])
                if isWinHard {
                    addClearLabel(for: buttons[2])
                }
            } else {
                addModeLockView(for: buttons[2])
            }
        } else {
            addModeLockView(for: buttons[1])
            addModeLockView(for: buttons[2])
        }
    }
    // クリアしていないモードを選択できないようにするためのView
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
