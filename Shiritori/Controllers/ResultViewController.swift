//
//  ResultViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/04.
//

import UIKit

class ResultViewController: UIViewController {
    
    var imageManager = ImageManager()
    var pushPlayer = SoundPlayer()
    var edPlayer = SoundPlayer()
    let defaults = UserDefaults.standard
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var WordsButton: UIButton!
    @IBOutlet weak var HomeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WordsButton.layer.cornerRadius = 5.0
        HomeButton.layer.cornerRadius = 5.0
        
        guard let mode = defaults.string(forKey: K.UserDefaultKeys.mode) else { return }
        let score = defaults.integer(forKey: K.UserDefaultKeys.score)
        
        changeResult(score: score, mode: mode)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        guard let mode = defaults.string(forKey: K.UserDefaultKeys.mode) else { return }
        let score = defaults.integer(forKey: K.UserDefaultKeys.score)
        changeResultSound(score: score, mode: mode)
    }
    
    @IBAction func wordsPressed(_ sender: UIButton) {
        //ボタンタップ時の効果音を設定
        let isMute = defaults.bool(forKey: K.UserDefaultKeys.isMute)
        pushPlayer.playSound(name: K.Sounds.push, isMute: isMute)

    }
    
    @IBAction func homePressed(_ sender: UIButton) {
        //ボタンタップ時の効果音を設定，オープニングを再生
        let isMute = defaults.bool(forKey: K.UserDefaultKeys.isMute)
        pushPlayer.playSound(name: K.Sounds.push, isMute: isMute)
        appDelegate.opPlayer.playSound(name: K.Sounds.op, isMute: isMute, loop: -1)
    }
    
    //ゲーム結果に応じてResult画面の画像，タイトルテキスト，モードLOCK変数を変更
    func changeResult(score: Int, mode: String) {
        let modeLock = defaults.integer(forKey: K.ModeLock)
        guard let scoreLimit = K.scoreLimit[mode] else { return }
        
        if scoreLimit <= score {
            self.imageManager.imageAnimation(for: resultImage,
                                             mode: "",
                                             action: K.animationAction.win,
                                             duration: 1.0)
            self.resultLabel.text = K.Texts.winText
            defaults.set(modeOpen(mode: mode, modeLock: modeLock), forKey: K.ModeLock)
        } else {
            self.imageManager.imageAnimation(for: resultImage,
                                             mode: mode,
                                             action: K.animationAction.lose,
                                             duration: 1.0)
            self.resultLabel.text = K.Texts.loseText
        }
    }
    //ゲーム結果に応じてサウンドを変更
    func changeResultSound(score: Int, mode: String) {
        let isMute = defaults.bool(forKey: K.UserDefaultKeys.isMute)
        guard let scoreLimit = K.scoreLimit[mode] else { return }
        if scoreLimit <= score {
            self.edPlayer.playSound(name: K.Sounds.win, isMute: isMute)
        } else {
            self.edPlayer.playSound(name: K.Sounds.lose, isMute: isMute)
        }
    }
    //現在のモードのクリア状況に応じて新しいモードを開放するかを決める
    func modeOpen(mode: String, modeLock: Int) -> Int {
        if modeLock < 3 {
            if mode == "EASY" {
                return 2
            } else {
                return 3
            }
        } else {
            return 4
        }
    }
}


