//
//  ModeSelectViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/17.
//

import UIKit

class ModeSelectViewController: UIViewController {
    
    // MARK: - Properties
    private var modeSelectView: ModeSelectView!
    private var backButton: UIButton!
    private var easyButton: UIButton!
    private var normalButton: UIButton!
    private var hardButton: UIButton!
    
    private let defaults = UserDefaults.standard
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    private func configureUI() {
        modeSelectView = ModeSelectView()
        backButton = modeSelectView.backButton
        easyButton = modeSelectView.modeButtons.easyButton
        normalButton = modeSelectView.modeButtons.normalButton
        hardButton = modeSelectView.modeButtons.hardButton
        
        configureModeButton()
        
        // 配置＆制約の追加
        view.addSubview(modeSelectView)
        modeSelectView.addConstraintsToFillView(view)
        
        // 各ボタンにアクションを追加
        backButton.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)
        easyButton.addTarget(self, action: #selector(modeSelected(_:)), for: .touchUpInside)
        normalButton.addTarget(self, action: #selector(modeSelected(_:)), for: .touchUpInside)
        hardButton.addTarget(self, action: #selector(modeSelected(_:)), for: .touchUpInside)
    }
    
    private func configureModeButton() {
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
    
    @objc private func backPressed(_ sender: UIButton) {
        addTransition(duration: 0.3, type: .fade, subType: .fromRight)
        dismiss(animated: false, completion: nil)
    }
    
    @objc private func modeSelected(_ sender: UIButton) {
        // オープニングを停止
        opening(operation: .stop)
        // ゲーム画面へ遷移
        let gameVC = GameViewController()
        // 押したボタンに対応するモードオブジェクトを渡す
        guard let btnTitle = sender.currentTitle else { return }
        defaults.setEnum(convertToMode(btnTitle), forKey: Const.UDKeys.currentMode)
        gameVC.modalPresentationStyle = .fullScreen
        addTransition(duration: 1.0, type: .fade, subType: .fromRight)
        present(gameVC, animated: false, completion: nil)
    }
    // ボタンタイトルをモードオブジェクトに変換
    private func convertToMode(_ modeString: String) -> Mode {
        switch modeString {
        case Const.ButtonText.easy:
            return .easy
        case Const.ButtonText.normal:
            return .normal
        case Const.ButtonText.hard:
            return .hard
        default:
            return .easy
        }
    }
}
