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
    private var textField: UITextField!
    
    var presenter: GameViewPresenter!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        presenter = GameViewPresenter(view: self)
        presenter.gameViewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        // キーボードが自動で表示される設定
        textField.becomeFirstResponder()
    }
    // MARK: - Helpers
    private func configureUI() {
        gameView = GameView()
        backButton = gameView.backButton
        attackButton = gameView.userInputView.attackButton
        wordLabel = gameView.enemyView.wordLabel
        timeLimit = gameView.enemyView.timeLimit
        textField = gameView.userInputView.textField
        // 自動で大文字になる設定, 自動で変換する設定を解除
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        
        // 配置＆制約の追加
        view.addSubview(gameView)
        gameView.addConstraintsToFillView(view)
        
        // ボタンにアクションを追加
        backButton.addTarget(self, action: #selector(backPressed(_ :)), for: .touchUpInside)
        attackButton.addTarget(self, action: #selector(attackPressed(_:)), for: .touchUpInside)
        
        // delegateの設定
        textField.delegate = self
    }
    
    @objc private func backPressed(_ sender: UIButton) {
        addTransition(duration: 0.3, type: .fade, subType: .fromLeft)
        dismiss(animated: false, completion: nil)
    }
    
    @objc private func attackPressed(_ sender: UIButton) {
        // 単語が入力されたことをpresenterに通知
        guard let word = textField.text else { fatalError() }
        presenter.didInputWord(word: word)
        textField.text = ""
    }
}
// MARK: - GameViewProtocol Methods
extension GameViewController: GameViewProtocol {
    
    func showText(_ gameViewPresenter: GameViewPresenter, text: String, state: TextState) {
        DispatchQueue.main.async {
            self.wordLabel.text = text
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            switch state {
            case .error:
                // エラー分表示の1秒後に現在の単語を再度表示
                guard let currentWord = UserDefaults.standard.string(forKey: Const.UDKeys.currentWord) else { return }
                self.wordLabel.text = currentWord
                
            case .start:
                // ゲームの開始をpresenterに通知
                self.presenter.willGameStart()
                
            case .end:
                // リザルト画面へ遷移
                let resultVC = ResultViewController()
                resultVC.modalPresentationStyle = .fullScreen
                self.addTransition(duration: 0.5, type: .fade, subType: .fromRight)
                self.present(resultVC, animated: false, completion: nil)
                
            default: break
            }
        }
    }
    
    func showTimeLimit(_ gameViewPresenter: GameViewPresenter, text: String) {
        DispatchQueue.main.async {
            self.timeLimit.text = "TIME:\(text)"
        }
    }
}
// MARK: - UITextFieldDelegate Methods
extension GameViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let word = textField.text else { fatalError() }
        presenter.didInputWord(word: word)
        textField.text = ""
        return true
    }
}
