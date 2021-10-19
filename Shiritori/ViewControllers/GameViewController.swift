//
//  GameViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/17.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: - Properties
    private var gameView: GameView!
    private var backButton: UIButton!
    private var attackButton: UIButton!
    private var wordLabel: UILabel!
    private var timeLimit: UILabel!
    
    var presenter: GameViewPresenter!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        presenter = GameViewPresenter(view: self)
        presenter.gameViewDidLoad()

    }
    
    private func configureUI() {
        gameView = GameView()
        backButton = gameView.backButton
        attackButton = gameView.userInputView.attackButton
        wordLabel = gameView.enemyView.wordLabel
        timeLimit = gameView.enemyView.timeLimit
        
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
// MARK: - GameViewProtocol Methods
extension GameViewController: GameViewProtocol {
    
    func showCount(_ gameViewPresenter: GameViewPresenter, text: String) {
        DispatchQueue.main.async {
            self.wordLabel.text = text
        }
    }
    
    func showTimeLimit(_ gameViewPresenter: GameViewPresenter, text: String) {
        DispatchQueue.main.async {
            self.timeLimit.text = "TIME:\(text)"
        }
    }
    
    func showStart(_ gameViewPresenter: GameViewPresenter, text: String) {
        DispatchQueue.main.async {
            self.wordLabel.text = text
        }
        presenter.willGameStart()
        // TODO: 英単語を取ってくる処理
    }
    
    func goToNextView(_ gameViewPresenter: GameViewPresenter, text: String) {
        DispatchQueue.main.async {
            self.wordLabel.text = text
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let resultVC = ResultViewController()
            resultVC.modalPresentationStyle = .fullScreen
            self.addTransition(duration: 0.5, type: .fade, subType: .fromRight)
            self.present(resultVC, animated: false, completion: nil)
        }
    }
}
