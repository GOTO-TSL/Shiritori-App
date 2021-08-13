//
//  StartViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/04.
//

import AVFoundation
import GRDB
import UIKit

class StartViewController: UIViewController {
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var easyReward: UIButton!
    @IBOutlet weak var normalReward: UIButton!
    @IBOutlet weak var hardReward: UIButton!
    
    var opPlayer = SoundPlayer()
    var pushPlayer = SoundPlayer()
    var figurePlayer = SoundPlayer()
    var wordSource = WordSource()
    var dataManager = DataManager()
    let defaults = UserDefaults.standard
    var dbQueue = DatabaseQueue()
    private var isMute = false
    
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初回起動時のみ実行する処理のための値をセット
        if defaults.bool(forKey: Constant.UserDefaultKeys.firstLaunch) {
            defaults.set(0, forKey: Constant.UserDefaultKeys.isClearEasy)
            defaults.set(0, forKey: Constant.UserDefaultKeys.isClearNormal)
            defaults.set(0, forKey: Constant.UserDefaultKeys.isClearHard)
            defaults.set(false, forKey: Constant.UserDefaultKeys.firstLaunch)
        }

        // タイトルを表示
        mainTitle.text = Constant.Texts.mainTitle
        subTitle.text = Constant.Texts.subTitle
        
        // BGMをミュートに切り替える処理
        let ismute = defaults.bool(forKey: Constant.UserDefaultKeys.isMute)
        isMute = ismute
        isMute ? soundButton.setImage(Constant.Images.sounds[1], for: .normal) : soundButton.setImage(Constant.Images.sounds[0], for: .normal)
        
        showReward()
        
        dataManager.loadWords()
        dataManager.loadMyWords()
        
        wordSource.createDatabase()
        
        playButton.layer.cornerRadius = 5.0
        
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
        // ナビゲーションバーを非表示
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showAlert()
        // 使用した単語リストのうち，お気に入り登録した単語をマイ単語リストへ移す処理
        guard let words = dataManager.words else { fatalError() }
        for word in words {
            if word.isLike {
                let newMyWord = MyWord()
                newMyWord.name = word.name
                newMyWord.mean = wordSource.featchMean(dbq: dbQueue, word: newMyWord.name)
                dataManager.save(model: newMyWord)
                dataManager.delete(word: word)
            } else {
                dataManager.delete(word: word)
            }
        }
    }

    /// おまけをタップすると音が出る処理
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let rewards = [easyReward, normalReward, hardReward]
        rewards.forEach { $0?.addTarget(self, action: #selector(didTouchDown(_:)), for: .touchDown) }
        rewards.forEach { $0?.addTarget(self, action: #selector(didTouchUpInside(_:)), for: .touchUpInside) }
    }
    
    @objc func didTouchDown(_ sender: UIButton) {
        guard let accessID = sender.accessibilityIdentifier else { print("error"); return }
        sender.setImage(Constant.Images.rewards[accessID]?[1], for: .normal)
        figurePlayer.playSound(name: accessID + "0")
    }
    
    @objc func didTouchUpInside(_ sender: UIButton) {
        guard let accessID = sender.accessibilityIdentifier else { print("error"); return }
        sender.setImage(Constant.Images.rewards[accessID]?[0], for: .normal)
        figurePlayer.playSound(name: accessID + "1")
    }

    /// ゲームクリアのおまけの表示/非表示
    func showReward() {
        let rewards = [easyReward, normalReward, hardReward]

        if defaults.bool(forKey: Constant.UserDefaultKeys.isClearHard) {
            rewards.forEach { $0?.isHidden = false }
        } else {
            rewards.forEach { $0?.isHidden = true }
        }
    }
    
    ///　アラートを表示
    func showAlert() {
        if defaults.integer(forKey: Constant.UserDefaultKeys.isClearHard) == 1 {
            let dialog = UIAlertController(title: "ゲームクリア", message: "おまけで遊んでね", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(dialog, animated: true, completion: nil)
            defaults.set(2, forKey: Constant.UserDefaultKeys.isClearHard)
            
        } else if defaults.integer(forKey: Constant.UserDefaultKeys.isClearNormal) == 1 {
            let dialog = UIAlertController(title: "モード開放", message: "HARDモードが開放されました", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(dialog, animated: true, completion: nil)
            defaults.set(2, forKey: Constant.UserDefaultKeys.isClearNormal)
            
        } else if defaults.integer(forKey: Constant.UserDefaultKeys.isClearEasy) == 1 {
            let dialog = UIAlertController(title: "モード開放", message: "NORMALモードが開放されました", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(dialog, animated: true, completion: nil)
            defaults.set(2, forKey: Constant.UserDefaultKeys.isClearEasy)
        }
    }
    
    /// サウンドボタンが押されたときのBGMの音量変更，画像変更
    @IBAction func soundPressed(_ sender: UIButton) {
        // ミュート変数の値を変更
        isMute = isMute ? false : true
        // ミュートかどうかで画像を変更
        isMute ? soundButton.setImage(Constant.Images.sounds[1], for: .normal) : soundButton.setImage(Constant.Images.sounds[0], for: .normal)
        
        guard let appDel = appDelegate else { return }
        appDel.opPlayer.muteSound(isMute: isMute)
        defaults.set(isMute, forKey: Constant.UserDefaultKeys.isMute)
    }

    /// ボタンタップ時の効果音を設定
    @IBAction func otherButtonPressed(_ sender: UIButton) {
        pushPlayer.playSound(name: Constant.Sounds.push, isMute: isMute)
    }

    @IBAction func playButtonPressed(_ sender: UIButton) {
        pushPlayer.playSound(name: Constant.Sounds.push, isMute: isMute)
    }
}
