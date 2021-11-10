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
    private var damageLabel: UILabel!
    private var resultView: ResultView?
    
    private var gameViewPresenter: GameViewPresenter!
    private var resultViewPresenter: ResultViewPresenter!
    
    var mode: Mode?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureGameUI()
        gameViewPresenter = GameViewPresenter(view: self, mode: mode!)
        resultViewPresenter = ResultViewPresenter(view: self)
        gameViewPresenter.gameViewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        // キーボードが自動で表示される設定
        textField.becomeFirstResponder()
    }
    
    // MARK: - Helpers
    private func configureGameUI() {
        let gameView = GameView()
        backButton = gameView.backButton
        attackButton = gameView.userInputView.attackButton
        wordLabel = gameView.enemyView.wordLabel
        timeLimit = gameView.enemyView.timeLimit
        textField = gameView.userInputView.textField
        hpBar = gameView.enemyView.hpView.hpBar
        enemyImageView = gameView.enemyView.enemyImageView
        damageLabel = gameView.enemyView.damageLabel
        
        // 敵の画像を設定
        enemyImageView.image = UIImage(named: "\(mode!)/move0")
        
        // 配置＆制約の追加
        view.addSubview(gameView)
        gameView.addConstraintsToFillView(view)
        
        // ボタンにアクションを追加
        backButton.addTarget(self, action: #selector(backPressed(_ :)), for: .touchUpInside)
        attackButton.addTarget(self, action: #selector(attackPressed(_:)), for: .touchUpInside)
        
        // delegateの設定
        textField.delegate = self
    }
    
    private func configureResultUI(isWin: Bool, mode: Mode) {
        resultViewPresenter.resultViewDidLoad(isWin: isWin, mode: mode)
        // リザルト画面を表示
        resultView = ResultView(frame: view.frame, isWin: isWin, mode: mode)
        view.addSubview(resultView!)
        resultView?.addConstraintsToFillView(view)
        
        resultView?.buttons.homeButton.addTarget(self, action: #selector(homePressed(_ :)), for: .touchUpInside)
        resultView?.buttons.wordButton.addTarget(self, action: #selector(wordPressed(_ :)), for: .touchUpInside)
    }
    // チュートリアルを表示
    private func showTutorial() {
        var positions: [CGPoint] = []
        let views: [UIView] = [wordLabel, textField, attackButton, hpBar, timeLimit]
        views.forEach { view in
            // 座標系を変換し，配列に代入
            let center = view.convert(CGPoint(x: view.frame.width/2, y: view.frame.height/2), to: self.view)
            positions.append(center)
        }
        
        if UserDefaults.standard.integer(forKey: Const.UDKeys.first) == 0 {
            UserDefaults.standard.set(1, forKey: Const.UDKeys.first)
            let gameTutorialVC = GameAnnotationViewController(positions: positions)
            present(gameTutorialVC, animated: true, completion: nil)
        }
    }
    
    // 戻るボタンが押されたときの処理
    @objc private func backPressed(_ sender: UIButton) {
        opening(operation: .play)
        gameViewPresenter.backPressed()
        addTransition(duration: 0.3, type: .fade, subType: .fromLeft)
        dismiss(animated: false, completion: nil)
    }
    
    // アタックボタンが押されたときの処理
    @objc private func attackPressed(_ sender: UIButton) {
        // 単語が入力されたことをpresenterに通知
        guard let word = textField.text else { fatalError() }
        gameViewPresenter.didInputWord(word: word)
        textField.text = ""
    }
    // ホームボタンが押されたときの処理
    @objc private func homePressed(_ sender: UIButton) {
        resultViewPresenter.didPressedHome()
    }
    
    // wordボタンが押されたときの処理
    @objc private func wordPressed(_ sender: UIButton) {
        resultViewPresenter.didPressedWord()
        // 使用した単語一覧画面に遷移
        let usedWordVC = UsedWordViewController()
        usedWordVC.modalPresentationStyle = .fullScreen
        addTransition(duration: 0.3, type: .moveIn, subType: .fromBottom)
        present(usedWordVC, animated: false, completion: nil)
    }
}
// MARK: - GameViewProtocol Methods
extension GameViewController: GameViewProtocol {
    // ダメージラベルの更新
    func updateDamageLabel(_ gameViewPresenter: GameViewPresenter, damage: Int) {
        if damage < 100 {
            damageLabel.textColor = .black
            damageLabel.font = UIFont(name: Const.font, size: 20)
        } else {
            damageLabel.textColor = .red
            damageLabel.font = UIFont(name: Const.font, size: 35)
        }
        damageLabel.text = "\(damage)"
        damageLabel.alpha = 1.0
        UIView.animate(withDuration: 1.0) {
            self.damageLabel.center.y -= 30
            self.damageLabel.alpha = 0.0
        }
    }
    
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
                self.showTutorial()
                // ゲームの開始をpresenterに通知
                self.gameViewPresenter.willGameStart()
                self.enemyImageView.animation(mode: self.mode!, action: "move", duration: 1.0)
                
            case .end:
                self.configureResultUI(isWin: false, mode: self.mode!)
            case .lose:
                self.configureResultUI(isWin: true, mode: self.mode!)
                
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
        gameViewPresenter.didInputWord(word: word)
        textField.text = ""
        return true
    }
}

// MARK: - ResultViewProtocol Methods
extension GameViewController: ResultViewProtocol {
    func goHomeView(_ resultViewPresenter: ResultViewPresenter) {
        opening(operation: .play)
        // viewを閉じる
        addTransition(duration: 0.5, type: .fade, subType: .fromRight)
        dismiss(animated: false, completion: nil)
    }
}
