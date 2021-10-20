//
//  ViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/03.
//

import AVFoundation
import GRDB
import UIKit

class PlayViewController: UIViewController {
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var timeBar: UIProgressView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var enemyImage: UIImageView!
    @IBOutlet weak var modeView: UIView!
    @IBOutlet weak var hitPointBar: UIProgressView!
    @IBOutlet weak var damageView: UIView!
    @IBOutlet weak var damageLabel: UILabel!
    
    var currentMode: String?
    var gameLogic = PreGameLogic()
    var imageManager = ImageManager()
    var timerManager = TimerManager()
    var wordSource = WordSource()
    var dataManager = DataManager()
    var actionPlayer = SoundPlayer()
    var bgmPlayer = SoundPlayer()
    var dbQueue = DatabaseQueue()
    let defaults = UserDefaults.standard
    var isMute: Bool = false
    var enemy = Enemy("")
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let mode = currentMode else { return }
        enemy = Enemy(mode)
        
        let ismute = defaults.bool(forKey: Constant.UserDefaultKeys.isMute)
        isMute = ismute
        // スコアの初期設定
        defaults.set("aaaa", forKey: Constant.UserDefaultKeys.currentWord)
        
        // ダメージを隠す
        damageLabel.isHidden = true
        
        // 戦闘BGMを再生
        bgmPlayer.playSound(name: "battle", isMute: isMute, loop: -1)
        
        modeView.layer.cornerRadius = 5.0
        // モードによってviewやlabelなどを変更
        changeModeLabel(mode: mode)
        enemyImage.image = Constant.Images.enemy[mode]
        
        wordSource.createDatabase()
        
        // delegateの宣言
        gameLogic.delegate = self
        timerManager.delegate = self
        wordSource.delegate = self
        textField.delegate = self
        
        if let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let path = dir.appending(Constant.DataBase.path)
            do {
                dbQueue = try DatabaseQueue(path: path)
            } catch {
                print("Error \(error)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // navigationBarを非表示
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // ゲーム開始のタイマースタート
        timerManager.gameTimer()
        // キーボードを自動的に表示
        textField.keyboardType = .alphabet
        textField.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        textField.resignFirstResponder()
    }

    /// ボタンが押されたときに実行される処理，ユーザーの入力にしりとりのルールを適用させる
    @IBAction func answerPressed(_ sender: UIButton) {
        guard let userInput = textField.text else { return }
        gameLogic.applyRule(for: userInput)
    }

    /// QUITボタンが押されたときの処理: 使用した単語のリセット，前のVCに戻る，タイマーと音楽を止める
    @IBAction func quitPressed(_ sender: UIButton) {
        dataManager.loadWords()
        guard let appDel = appDelegate else { return }
        guard let words = dataManager.words else { fatalError() }
        for word in words {
            dataManager.delete(word: word)
        }
        textField.resignFirstResponder()
        bgmPlayer.stopSound()
        appDel.opPlayer.playSound(name: Constant.Sounds.opening, isMute: isMute, loop: -1)
        timerManager.stopTimer()
    }

    /// 左上のモードViewのテキストと色を変更
    /// - Parameter mode: 選択中のモード
    func changeModeLabel(mode: String) {
        modeLabel.text = mode
        modeLabel.backgroundColor = Constant.modeColor[mode]
        modeView.backgroundColor = Constant.modeColor[mode]
    }
}

// MARK: - UITextFieldDelegate

extension PlayViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            textField.endEditing(true)
            return true
        } else {
            textField.endEditing(false)
            return true
        }
    }
}

// MARK: - WordSourceDelegate

extension PlayViewController: WordSourceDelegate {
    /// 辞書にない単語が入力されたときの処理
    func invalidWord(_ wordSource: WordSource) {
        DispatchQueue.main.async {
            self.imageManager.imageAnimation(for: self.enemyImage,
                                             mode: self.enemy.mode,
                                             action: Constant.AnimationAction.heal,
                                             duration: 0.5)
            self.actionPlayer.playSound(name: Constant.Sounds.heal, isMute: self.isMute)
            self.wordLabel.text = Constant.Comments.invalid
            self.gameLogic.subGamePoint(enemy: self.enemy)
            self.textField.text = ""
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.imageManager.imageAnimation(for: self.enemyImage,
                                             mode: self.enemy.mode,
                                             action: "",
                                             duration: 1.0)
            guard let current = self.defaults.string(forKey: Constant.UserDefaultKeys.currentWord) else { return }
            self.wordLabel.text = current
        }
    }

    /// プレイヤーの入力した単語を保存
    func addPlayerWord(_ wordSource: WordSource) {
        DispatchQueue.main.async {
            if let word = self.textField.text {
                self.dataManager.save(word: word)
            }
        }
    }

    /// はじめの１単語目を表示，保存
    /// - Parameters:
    ///   - word: ゲームが始まって最初に出てくる単語
    func updateFirst(_ wordSource: WordSource, word: String) {
        DispatchQueue.main.async {
            self.dataManager.save(word: word)
            self.wordLabel.text = word
            self.defaults.set(word, forKey: Constant.UserDefaultKeys.currentWord)
        }
    }

    /// 敵の単語を更新し，単語を保存
    /// - Parameters:
    func updateWord(_ wordSource: WordSource, word: String) {
        guard let text = textField.text else { return }
        DispatchQueue.main.async {
            self.dataManager.save(word: word)
            self.wordLabel.text = word
            self.defaults.set(word, forKey: Constant.UserDefaultKeys.currentWord)
            self.gameLogic.addGamePoint(enemy: self.enemy, userWord: text)
            self.textField.text = ""
        }
    }
}

// MARK: - GameLogicDelegate

extension PlayViewController: PreGameLogicDelegate {
    
    /// ダメージラベルの更新
    /// - Parameters:
    ///   - gameLogic: gameLogic Model
    ///   - damage: ダメージ（入力した単語の文字数）
    func updateDamage(_ gameLogic: PreGameLogic, damage: Int) {
        DispatchQueue.main.async {
            self.damageLabel.isHidden = false
            if damage < 100 {
                self.damageLabel.textColor = .black
                self.damageLabel.text = String(damage)
            } else {
                self.damageLabel.textColor = .red
                self.damageLabel.text = String(damage)
            }
            self.imageManager.damageAnimation(for: self.damageView)
        }
    }
    
    /// HPゲージの更新
    /// - Parameters:
    ///   - gameLogic: gameLogic Model
    ///   - hitpoint: 敵の現在のHPの値
    ///   - scoreLimit: 敵のHP満タン時の値
    func updateHitPoint(_ gameLogic: PreGameLogic, hitpoint: Int, scoreLimit: Int) {
        DispatchQueue.main.async {
            let progress = Float(hitpoint) / Float(scoreLimit)
            self.hitPointBar.progress = progress
            switch self.hitPointBar.progress {
            case 0.6 ... 1.0:
                self.hitPointBar.progressTintColor = .green
            case 0.26 ..< 0.6:
                self.hitPointBar.progressTintColor = .systemYellow
            case 0.0 ..< 0.26:
                self.hitPointBar.progressTintColor = .systemRed
            default:
                self.hitPointBar.progressTintColor = .green
            }
        }
    }

    /// しりとりのルールに当てはまった場合の処理
    func shiritoriSucessed(_ gameLogic: PreGameLogic) {
        DispatchQueue.main.async {
            // ダメージを受ける効果音を再生
            self.actionPlayer.playSound(name: Constant.Sounds.damage, isMute: self.isMute)
            // ダメージを受けるアニメーション
            self.imageManager.imageAnimation(for: self.enemyImage,
                                             mode: self.enemy.mode,
                                             action: Constant.AnimationAction.damage,
                                             duration: 0.2)
            
            guard let text = self.textField.text else { return }
            self.wordSource.featchWord(dbq: self.dbQueue, inputWord: text)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // メインアニメーションの再開
            self.imageManager.imageAnimation(for: self.enemyImage,
                                             mode: self.enemy.mode,
                                             action: Constant.AnimationAction.main,
                                             duration: 1.0)
        }
    }
    
    /// しりとりが失敗したときの処理
    /// - Parameters:
    ///   - gameLogic: gameLogic Model
    ///   - comment: どのルールに当てはまらなかったのか知らせるコメント
    func shiritoriFailed(_ gameLogic: PreGameLogic, comment: String) {
        DispatchQueue.main.async {
            // 回復する効果音を再生
            self.actionPlayer.playSound(name: Constant.Sounds.heal, isMute: self.isMute)
            // 回復するアニメーション
            self.imageManager.imageAnimation(for: self.enemyImage,
                                             mode: self.enemy.mode,
                                             action: Constant.AnimationAction.heal,
                                             duration: 0.5)
            
            self.gameLogic.subGamePoint(enemy: self.enemy)
            self.wordLabel.text = comment
            self.textField.text = ""
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // メインアニメーションの再開
            self.imageManager.imageAnimation(for: self.enemyImage,
                                             mode: self.enemy.mode,
                                             action: Constant.AnimationAction.main,
                                             duration: 1.0)
            
            guard let current = self.defaults.string(forKey: Constant.UserDefaultKeys.currentWord) else { return }
            self.wordLabel.text = current
        }
    }
    
    /// 敵を倒したときに呼ばれる処理
    func gotoResultView(_ gameLogic: PreGameLogic) {
        DispatchQueue.main.async {
            self.imageManager.imageAnimation(for: self.enemyImage,
                                             mode: self.enemy.mode,
                                             action: Constant.AnimationAction.down,
                                             duration: 1.0)
            self.wordLabel.text = Constant.Comments.lose
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.defaults.set(self.enemy.hitpoint, forKey: Constant.UserDefaultKeys.hitpoint)
            self.defaults.set(self.enemy.mode, forKey: Constant.UserDefaultKeys.currentMode)
            self.performSegue(withIdentifier: Constant.SegueID.toresult, sender: nil)
            self.bgmPlayer.stopSound()
            self.timerManager.mainTimer.invalidate()
        }
    }
}

// MARK: - TimerManagerDelegate

extension PlayViewController: TimerManagerDelegate {
    
    /// 時間に関するコメントを表示
    /// - Parameters:
    ///   - timerManager: timerManager Model
    ///   - comment: 表示させるコメント
    func didUpdateComment(_ timerManager: TimerManager, comment: String) {
        DispatchQueue.main.async {
            self.wordLabel.text = comment
        }
    }
    
    /// タイマーゲージの更新
    /// - Parameters:
    ///   - timerManager: timerManager Model
    ///   - timeNow: 現在の経過時間
    func didUpdateTimeBar(_ timerManager: TimerManager, timeNow: Float) {
        DispatchQueue.main.async {
            self.timeBar.progress = timeNow
        }
    }
    
    /// ゲーム開始時に呼ばれる処理，単語を表示，アニメーションを開始
    func gameStart(_ timerManager: TimerManager) {
        DispatchQueue.main.async {
            self.wordSource.featchFirstWord(dbq: self.dbQueue)
            self.imageManager.imageAnimation(for: self.enemyImage,
                                             mode: self.enemy.mode,
                                             action: Constant.AnimationAction.main,
                                             duration: 1.0)
        }
    }

    /// 制限時間に達したときに呼ばれる処理, サウンドの停止，次の画面へ移動
    func gotoNextView(_ timerManager: TimerManager) {
        DispatchQueue.main.async {
            self.bgmPlayer.stopSound()
            self.defaults.set(self.enemy.hitpoint, forKey: Constant.UserDefaultKeys.hitpoint)
            self.defaults.set(self.enemy.mode, forKey: Constant.UserDefaultKeys.currentMode)
            self.performSegue(withIdentifier: Constant.SegueID.toresult, sender: nil)
        }
    }
}
