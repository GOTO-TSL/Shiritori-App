//
//  ModeSelectViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/17.
//

import UIKit

class ModeSelectViewController: UIViewController {
    
    // MARK: - Properties
    var modeSelectView: ModeSelectView!
    var backButton: UIButton!
    var easyButton: UIButton!
    var normalButton: UIButton!
    var hardButton: UIButton!
    
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
        
        // 配置＆制約の追加
        view.addSubview(modeSelectView)
        modeSelectView.addConstraintsToFillView(view)
        
        // 各ボタンにアクションを追加
        backButton.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)
        easyButton.addTarget(self, action: #selector(modeSelected(_:)), for: .touchUpInside)
        normalButton.addTarget(self, action: #selector(modeSelected(_:)), for: .touchUpInside)
        hardButton.addTarget(self, action: #selector(modeSelected(_:)), for: .touchUpInside)
    }
    
    @objc private func backPressed(_ sender: UIButton) {
        addTransition(duration: 0.3, type: .fade, subType: .fromRight)
        dismiss(animated: false, completion: nil)
    }
    
    @objc private func modeSelected(_ sender: UIButton) {
        // ゲーム画面へ遷移
        let gameVC = GameViewController()
        // 押したボタンに対応するモードオブジェクトを渡す
        guard let btnTitle = sender.currentTitle else { return }
        gameVC.mode = convertToMode(btnTitle)
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
