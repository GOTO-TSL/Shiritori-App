//
//  GameViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/17.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: - Properties
    private var backButton: UIButton!
    private var attackButton: UIButton!
    private var wordLabel: UILabel!
    private var timeLimit: UILabel!
    private var textField: UITextField!
    private var hpBar: UIProgressView!
    private var enemyImageView: UIImageView!
    
    private var presenter: GameViewPresenter!
    var mode: Mode?
    
    // MARK: - Lifecycle
    deinit {
        print("game deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        presenter = GameViewPresenter(view: self, mode: mode!)
        presenter.gameViewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        // キーボードが自動で表示される設定
        textField.becomeFirstResponder()
    }
    // MARK: - Helpers
    private func configureUI() {
        let gameView = GameView()
        backButton = gameView.backButton
        attackButton = gameView.userInputView.attackButton
        wordLabel = gameView.enemyView.wordLabel
        timeLimit = gameView.enemyView.timeLimit
        textField = gameView.userInputView.textField
        hpBar = gameView.enemyView.hpView.hpBar
        enemyImageView = gameView.enemyView.enemyImageView
        
        // 敵の画像を設定
        enemyImageView.image = UIImage(named: "\(mode!)/move0")
        // 自動で大文字になる設定, 自動で変換する設定を解除
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        // progressBarの端っこを四角に
        hpBar.progressViewStyle = .bar
        
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
        opening(operation: .play)
        presenter.backPressed()
        addTransition(duration: 0.3, type: .fade, subType: .fromLeft)
        let modeVC = ModeSelectViewController()
        self.navigationController?.pushViewController(modeVC, animated: false)
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
    // HPバーの更新
    func updateHPBar(_ gameViewPresenter: GameViewPresenter, progress: Float) {
        // 残りHPに応じて色を変更
        DispatchQueue.main.async {
            self.hpBar.progress = progress
            switch self.hpBar.progress {
            case 0.6 ... 1.0:
                self.hpBar.progressTintColor = .green
            case 0.26 ..< 0.6:
                self.hpBar.progressTintColor = .systemYellow
            case 0.0 ..< 0.26:
                self.hpBar.progressTintColor = .systemRed
            default:
                self.hpBar.progressTintColor = .green
            }
        }
    }

    func showText(_ gameViewPresenter: GameViewPresenter, text: String, state: TextState) {
        DispatchQueue.main.async {
            self.wordLabel.text = text
            switch state {
            case .word:
                self.enemyImageView.animation(mode: self.mode!, action: "damage", duration: 0.2)
            case .error:
                self.enemyImageView.animation(mode: self.mode!, action: "heal", duration: 0.4)
            case .lose:
                self.enemyImageView.animation(mode: self.mode!, action: "lose", duration: 0.9)
            default:
                self.enemyImageView.image = UIImage(named: "\(self.mode!)/move0")
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            switch state {
            case .word:
                self.enemyImageView.animation(mode: self.mode!, action: "move", duration: 1.0)
            case .error:
                // エラー分表示の1秒後に現在の単語を再度表示
                guard let currentWord = UserDefaults.standard.string(forKey: Const.UDKeys.currentWord) else { return }
                self.wordLabel.text = currentWord
                self.enemyImageView.animation(mode: self.mode!, action: "move", duration: 1.0)
                
            case .start:
                // ゲームの開始をpresenterに通知
                self.presenter.willGameStart()
                self.enemyImageView.animation(mode: self.mode!, action: "move", duration: 1.0)
                
            case .end:
                UserDefaults.standard.set(false, forKey: Const.UDKeys.isWin)
                UserDefaults.standard.setEnum(self.mode!, forKey: Const.UDKeys.currentMode)
                // リザルト画面へ遷移
                let resultVC = ResultViewController()
                resultVC.modalPresentationStyle = .fullScreen
                self.addTransition(duration: 0.5, type: .fade, subType: .fromRight)
                self.navigationController?.pushViewController(resultVC, animated: false)
                
            case .lose:
                UserDefaults.standard.set(true, forKey: Const.UDKeys.isWin)
                UserDefaults.standard.setEnum(self.mode!, forKey: Const.UDKeys.currentMode)
                // リザルト画面へ遷移
                let resultVC = ResultViewController()
                resultVC.modalPresentationStyle = .fullScreen
                self.addTransition(duration: 0.5, type: .fade, subType: .fromRight)
                self.navigationController?.pushViewController(resultVC, animated: false)
                
            default: break
            }
        }
    }
    
    func showTimeLimit(_ gameViewPresenter: GameViewPresenter, text: String) {
        // 制限時間を更新
        DispatchQueue.main.async {
            self.timeLimit.text = text
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
