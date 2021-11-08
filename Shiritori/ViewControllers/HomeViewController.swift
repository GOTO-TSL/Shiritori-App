//
//  HomeViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/10.
//

import UIKit
import Gecco

class HomeViewController: UIViewController {
    // MARK: - Properties
    private var playButton: UIButton!
    private var wordButton: UIButton!
    private var helpButton: UIButton!
    private var rankingButton: UIButton!
    private var soundButton: UIButton!
    private var modeView: ModeSelectView?
    private var easyButton: UIButton!
    private var normalButton: UIButton!
    private var hardButton: UIButton!
    private var tutorialButton: UIButton!
    
    private var presenter: HomeViewPresenter!
    private let defaults = UserDefaults.standard
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        presenter = HomeViewPresenter()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let isMute = UserDefaults.standard.bool(forKey: Const.UDKeys.isMute)
        soundButton.imageView?.image = isMute ? UIImage(named: Const.Image.mute) : UIImage(named: Const.Image.sound)
        changeClearState()
        guard let modeSelectView = modeView else { return }
        modeSelectView.removeFromSuperview()
    }
    
    private func configureUI() {
        let homeView = HomeView()
        playButton = homeView.middleButtons.playButton
        wordButton = homeView.middleButtons.wordButton
        helpButton = homeView.bottomButtons.helpButton
        rankingButton = homeView.bottomButtons.rankingButton
        soundButton = homeView.bottomButtons.soundButton
        tutorialButton = homeView.tutorialButton
        
        // 配置＆制約
        view.addSubview(homeView)
        homeView.addConstraintsToFillView(view)
        
        // 各ボタンにアクションを追加
        playButton.addTarget(self, action: #selector(playPressed(_:)), for: .touchUpInside)
        wordButton.addTarget(self, action: #selector(wordPressed(_:)), for: .touchUpInside)
        helpButton.addTarget(self, action: #selector(helpPressed(_:)), for: .touchUpInside)
        rankingButton.addTarget(self, action: #selector(rankingPressed(_:)), for: .touchUpInside)
        soundButton.addTarget(self, action: #selector(soundPressed(_:)), for: .touchUpInside)
        tutorialButton.addTarget(self, action: #selector(showTutorial(_ :)), for: .touchUpInside)
    }
    // チュートリアルを表示
    @objc private func showTutorial(_ sender: UIButton) {
        var positions: [CGPoint] = []
        let buttons: [UIButton] = [playButton, wordButton, soundButton, helpButton, rankingButton]
        buttons.forEach { button in
            // 座標系を変換し，配列に代入
            let center = button.convert(CGPoint(x: button.frame.width/2, y: button.frame.height/2), to: view)
            positions.append(center)
        }
        
        let homeTutorialVC = HomeAnnotationViewController(positions: positions)
        present(homeTutorialVC, animated: true, completion: nil)
    }
    // クリア状況に応じて行う処理
    private func changeClearState() {
        let mode: Mode? = defaults.getEnum(forKey: Const.UDKeys.currentMode)
        let isWin = defaults.bool(forKey: Const.UDKeys.isWin)
        let isWinEasy = defaults.bool(forKey: Const.UDKeys.isWinEasy)
        let isWinNormal = defaults.bool(forKey: Const.UDKeys.isWinNormal)
        let isWinHard = defaults.bool(forKey: Const.UDKeys.isWinHard)
        
        if isWin {
            switch mode! {
            case .easy:
                if !isWinEasy {
                    showAlert(title: Const.AlertText.open, message: Const.AlertText.messageNormal)
                    defaults.set(true, forKey: Const.UDKeys.isWinEasy)
                }
            case .normal:
                if !isWinNormal {
                    showAlert(title: Const.AlertText.open, message: Const.AlertText.messageHard)
                    defaults.set(true, forKey: Const.UDKeys.isWinNormal)
                }
            case .hard:
                if !isWinHard {
                    showAlert(title: Const.AlertText.clear, message: Const.AlertText.messageClear)
                    defaults.set(true, forKey: Const.UDKeys.isWinHard)
                }
            }
        }
    }
    // アラートを表示
    private func showAlert(title: String, message: String) {
        let dialog = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(dialog, animated: true, completion: nil)
    }
    // playボタンが押されたときの処理　モード選択画面を表示する
    @objc private func playPressed(_ sender: UIButton) {
        presenter.didPushButton()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(modeViewTapped(_:)))
        view.addGestureRecognizer(tapGesture)
        
        configureModeView()
        
    }
    
    private func configureModeView() {
        modeView = ModeSelectView()
        modeView!.alpha = 0.0
        easyButton = modeView!.modeButtons.easyButton
        normalButton = modeView!.modeButtons.normalButton
        hardButton = modeView!.modeButtons.hardButton
        
        view.addSubview(modeView!)
        modeView!.addConstraintsToFillView(view)
        // アニメーションを追加
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseIn]) {
            self.modeView?.alpha = 1.0
        }

        easyButton.addTarget(self, action: #selector(modeSelected(_:)), for: .touchUpInside)
        normalButton.addTarget(self, action: #selector(modeSelected(_:)), for: .touchUpInside)
        hardButton.addTarget(self, action: #selector(modeSelected(_:)), for: .touchUpInside)
    }
    // モード選択でボタン以外の場所がタップされたときの処理
    @objc func modeViewTapped(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseIn]) {
            self.modeView?.alpha = 0.0
        } completion: { _ in
            self.modeView?.removeFromSuperview()
        }
    }
    
    @objc private func wordPressed(_ sender: UIButton) {
        presenter.didPushButton()
        // マイ単語帳画面に遷移
        let mywordVC = MyWordViewController()
        mywordVC.modalPresentationStyle = .fullScreen
        addTransition(duration: 0.3, type: .moveIn, subType: .fromBottom)
        present(mywordVC, animated: false, completion: nil)
    }
    
    @objc private func helpPressed(_ sender: UIButton) {
        presenter.didPushButton()
        // ルール画面に遷移
        let ruleVC = RuleViewController()
        ruleVC.modalPresentationStyle = .fullScreen
        addTransition(duration: 0.3, type: .fade, subType: .fromRight)
        present(ruleVC, animated: false, completion: nil)
    }
    
    @objc private func rankingPressed(_ sender: UIButton) {
        presenter.didPushButton()
        // ランキング画面に遷移
        let rankingVC = RankingViewController()
        rankingVC.modalPresentationStyle = .fullScreen
        addTransition(duration: 0.3, type: .fade, subType: .fromRight)
        present(rankingVC, animated: false, completion: nil)
    }
    
    @objc private func soundPressed(_ sender: UIButton) {
        let isMute = UserDefaults.standard.bool(forKey: Const.UDKeys.isMute)
        DispatchQueue.main.async {
            self.soundButton.imageView?.image = isMute ? UIImage(named: Const.Image.sound) : UIImage(named: Const.Image.mute)
        }
        UserDefaults.standard.set(!isMute, forKey: Const.UDKeys.isMute)
        opening(operation: .mute)
    }
    
    @objc private func modeSelected(_ sender: UIButton) {
        // オープニングを停止
        opening(operation: .stop)
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
