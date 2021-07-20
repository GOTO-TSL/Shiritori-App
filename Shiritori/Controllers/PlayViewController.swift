//
//  ViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/03.
//

import UIKit
import GRDB
import CoreData
import AVFoundation

class PlayViewController: UIViewController {

    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var WordLabel: UILabel!
    @IBOutlet weak var TimeBar: UIProgressView!
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var FaceImage: UIImageView!
    @IBOutlet weak var modeView: UIView!
    @IBOutlet weak var HitPointBar: UIProgressView!
    @IBOutlet weak var damageView: UIView!
    @IBOutlet weak var damageLabel: UILabel!
    
    var wordArray = [Word]()
    var gameLogic = GameLogic()
    var imageManager = ImageManager()
    var timerManager = TimerManager()
    var wordSource = WordSource()
    var dbQueue = DatabaseQueue()
    var actionPlayer = SoundPlayer()
    var bgmPlayer = SoundPlayer()
    let defaults = UserDefaults.standard
    var MODE = ""
    var isMute = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let mode = defaults.string(forKey: K.UserDefaultKeys.mode) else { return }
        MODE = mode
        let ismute = defaults.bool(forKey: K.UserDefaultKeys.isMute)
        isMute = ismute
        //スコアの初期設定
        defaults.set(0, forKey: K.UserDefaultKeys.score)
        defaults.set("aaaa", forKey: K.UserDefaultKeys.currentWord)
        
        //ダメージを隠す
        damageView.isHidden = true
        
        //戦闘BGMを再生
        bgmPlayer.playSound(name: "battle", isMute: isMute, loop: -1)
        
        modeView.layer.cornerRadius = 5.0
        //モードによってviewやlabelなどを変更
        changeModeLabel(mode: mode)
        FaceImage.image = K.Images.enemy[mode]
        
        //delegateの宣言
        gameLogic.delegate = self
        timerManager.delegate = self
        wordSource.delegate = self
        TextField.delegate = self
        
        //データベースのパスを取得し，データベースキューを設定
        if let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let path = dir.appending(K.DataBase.path)
            do {
                dbQueue = try DatabaseQueue(path: path)
            } catch {
                print("Error \(error)")
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationBarを非表示
        navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //ゲーム開始のタイマースタート
        timerManager.gameTimer()
        //キーボードを自動的に表示
        self.TextField.keyboardType = .alphabet
        self.TextField.becomeFirstResponder()
            
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.TextField.resignFirstResponder()
    }

    //ボタンが押されたときに実行される処理，ユーザーの入力にしりとりのルールを適用させる
    @IBAction func AnswerPressed(_ sender: UIButton) {
        guard let userInput = TextField.text else { return }
        gameLogic.applyRule(for: userInput)
    }
    //QUITボタンが押されたときの処理，前のVCに戻り，タイマーと音楽を止める
    @IBAction func QuitPressed(_ sender: UIButton) {
        self.TextField.resignFirstResponder()
        bgmPlayer.stopSound()
        appDelegate.opPlayer.playSound(name: K.Sounds.op, isMute: isMute, loop: -1)
        timerManager.stopTimer()
    }
    //左上のモードViewのテキストと色を変更
    func changeModeLabel(mode: String) {
        modeLabel.text = mode
        modeLabel.backgroundColor = K.modeColor[mode]
        modeView.backgroundColor = K.modeColor[mode]
    }

    //単語を保存
    func saveWord(word: String) {
        let newWord = Word(context: context)
        newWord.word = word
        newWord.like = false
        wordArray.append(newWord)
        
        do {
            try context.save()
            
        } catch {
            print("Error saving word array, \(error)")
            
        }
    }
}
//MARK: - UITextFieldDelegate
extension PlayViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        TextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            TextField.endEditing(true)
            return true
        } else {
            TextField.endEditing(false)
            return true
        }
    }
    
}

//MARK: - WordSourceDelegate
extension PlayViewController: WordSourceDelegate {
    //辞書にない単語が入力されたときの処理
    func invalidWord() {
        DispatchQueue.main.async {
            self.imageManager.imageAnimation(for: self.FaceImage,
                                             mode: self.MODE, action: K.animationAction.heal,
                                             duration: 0.5)
            self.actionPlayer.playSound(name: K.Sounds.heal, isMute: self.isMute)
            self.WordLabel.text = K.Comments.invalid
            self.gameLogic.subGamePoint()
            self.TextField.text = ""
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.imageManager.imageAnimation(for: self.FaceImage,
                                             mode: self.MODE,
                                             action: "",
                                             duration: 1.0)
            guard let current = self.defaults.string(forKey: K.UserDefaultKeys.currentWord) else { return }
            self.WordLabel.text = current
        }
    }
    //プレイヤーの入力した単語を保存
    func addPlayerWord() {
        DispatchQueue.main.async {
            if let word = self.TextField.text {
                self.saveWord(word: word)
            }
        }

    }
    //はじめの１単語目を表示，保存
    func updateFirst(word: String) {
        DispatchQueue.main.async {
            self.saveWord(word: word)
            self.WordLabel.text = word
            self.defaults.set(word, forKey: K.UserDefaultKeys.currentWord)
        }
    }
    //敵の単語を更新し，単語を保存
    func updateWord(word: String) {
        guard let text = TextField.text else { return }
        DispatchQueue.main.async {
            self.saveWord(word: word)
            self.WordLabel.text = word
            self.defaults.set(word, forKey: K.UserDefaultKeys.currentWord)
            self.gameLogic.addGamePoint(userWord: text)
            self.TextField.text = ""
        }
    }
}
//MARK: - GameLogicDelegate
extension PlayViewController: GameLogicDelegate {
    //ダメージラベルの更新
    func updateDamage(damage: Int) {
        DispatchQueue.main.async {
            self.damageView.isHidden = false
            if damage >= 100 {
                self.damageLabel.textColor = .red
                self.damageLabel.text = String(damage)
            } else {
                self.damageLabel.textColor = .black
                self.damageLabel.text = String(damage)
            }
            self.imageManager.damageAnimation(for: self.damageView)
        }
    }
    //HPゲージの更新
    func updateHitPoint(score: Int, scoreLimit: Int) {
        DispatchQueue.main.async {
            let progress = 1.0 - Float(score) / Float(scoreLimit)
            self.HitPointBar.progress = progress
            switch self.HitPointBar.progress {
            case 0.6...1.0:
                self.HitPointBar.progressTintColor = .green
            case 0.26..<0.6:
                self.HitPointBar.progressTintColor = .systemYellow
            case 0.0..<0.26:
                self.HitPointBar.progressTintColor = .systemRed
            default:
                self.HitPointBar.progressTintColor = .green
            }
        }
    }
    //しりとりのルールに当てはまった場合の処理
    func shiritoriSucessed() {
        DispatchQueue.main.async {
            //ダメージを受ける効果音を再生
            self.actionPlayer.playSound(name: K.Sounds.damage, isMute: self.isMute)
            //ダメージを受けるアニメーション
            self.imageManager.imageAnimation(for: self.FaceImage,
                                             mode: self.MODE,
                                             action: K.animationAction.damage,
                                             duration: 0.2)
            
            guard let text = self.TextField.text else { return }
            self.wordSource.featchWord(dbqueue: self.dbQueue, inputWord: text)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            //メインアニメーションの再開
            self.imageManager.imageAnimation(for: self.FaceImage,
                                             mode: self.MODE,
                                             action: K.animationAction.main,
                                             duration: 1.0)
        }
    }
    //しりとりのルールに当てはまらなかった場合の処理
    func shiritoriFailed(comment: String) {
        DispatchQueue.main.async {
            //回復する効果音を再生
            self.actionPlayer.playSound(name: K.Sounds.heal, isMute: self.isMute)
            //回復するアニメーション
            self.imageManager.imageAnimation(for: self.FaceImage,
                                             mode: self.MODE,
                                             action: K.animationAction.heal,
                                             duration: 0.5)
            
            self.gameLogic.subGamePoint()
            self.WordLabel.text = comment
            self.TextField.text = ""
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            //メインアニメーションの再開
            self.imageManager.imageAnimation(for: self.FaceImage,
                                             mode: self.MODE,
                                             action: K.animationAction.main,
                                             duration: 1.0)
            
            guard let current = self.defaults.string(forKey: K.UserDefaultKeys.currentWord) else { return }
            self.WordLabel.text = current
        }
    }
    
    //敵を倒したときに呼ばれる処理
    func gotoResultView() {
        DispatchQueue.main.async {
            self.imageManager.imageAnimation(for: self.FaceImage,
                                             mode: self.MODE,
                                             action: K.animationAction.down,
                                             duration: 1.0)
            self.WordLabel.text = K.Comments.lose
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.performSegue(withIdentifier: K.SegueID.toresult, sender: nil)
            self.bgmPlayer.stopSound()
            self.timerManager.mainTimer.invalidate()
        }
    }
}
//MARK: - TimerManagerDelegate
extension PlayViewController: TimerManagerDelegate {
    //時間に関するコメントを表示する
    func didUpdateComment(comment: String) {
        DispatchQueue.main.async {
            self.WordLabel.text = comment
        }
    }
    //タイマーのゲージを更新
    func didUpdateTimeBar(timeNow: Float) {
        DispatchQueue.main.async {
            self.TimeBar.progress = timeNow
        }
    }
    //ゲームスタート時に呼ばれる処理
    func gameStart() {
        DispatchQueue.main.async {
            self.wordSource.featchFirstWord(dbqueue: self.dbQueue)
            self.imageManager.imageAnimation(for: self.FaceImage,
                                             mode: self.MODE,
                                             action: K.animationAction.main,
                                             duration: 1.0)
        }
    }
    //制限時間に達したときに呼ばれる処理
    func gotoNextView() {
        DispatchQueue.main.async {
            self.bgmPlayer.stopSound()
            self.performSegue(withIdentifier: K.SegueID.toresult, sender: nil)
        }
    }
}

