//
//  GameViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/17.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: - Properties
    var gameView: GameView!
    var backButton: UIButton!
    var attackButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()

    }
    
    private func configureUI() {
        gameView = GameView()
        backButton = gameView.backButton
        attackButton = gameView.userInputView.attackButton
        
        // 配置＆制約の追加
        view.addSubview(gameView)
        gameView.addConstraintsToFillView(view)
        
        // ボタンにアクションを追加
        backButton.addTarget(self, action: #selector(backPressed(_ :)), for: .touchUpInside)
        attackButton.addTarget(self, action: #selector(attackPressed(_:)), for: .touchUpInside)
    }
    
    @objc private func backPressed(_ sender: UIButton) {
        addTransition(duration: 0.3, type: .fade, subType: .fromLeft)
        dismiss(animated: false, completion: nil)
    }
    
    @objc private func attackPressed(_ sender: UIButton) {
        // 現状仮でここからリザルト画面へ遷移している
        let resultVC = ResultViewController()
        resultVC.modalPresentationStyle = .fullScreen
        addTransition(duration: 0.5, type: .fade, subType: .fromRight)
        present(resultVC, animated: false, completion: nil)
    }
}
