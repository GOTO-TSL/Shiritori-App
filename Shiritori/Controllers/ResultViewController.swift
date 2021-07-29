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
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var wordsButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordsButton.layer.cornerRadius = 5.0
        homeButton.layer.cornerRadius = 5.0
        
        guard let mode = defaults.string(forKey: Constant.UserDefaultKeys.mode) else { return }
        let score = defaults.integer(forKey: Constant.UserDefaultKeys.score)
        
        changeResult(score: score, mode: mode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        guard let mode = defaults.string(forKey: Constant.UserDefaultKeys.mode) else { return }
        let score = defaults.integer(forKey: Constant.UserDefaultKeys.score)
        changeResultSound(score: score, mode: mode)
    }
    
    @IBAction func wordsPressed(_ sender: UIButton) {
        // ボタンタップ時の効果音を設定
        let isMute = defaults.bool(forKey: Constant.UserDefaultKeys.isMute)
        pushPlayer.playSound(name: Constant.Sounds.push, isMute: isMute)
    }
    
    @IBAction func homePressed(_ sender: UIButton) {
        guard let appDel = appDelegate else { return }
        // ボタンタップ時の効果音を設定，オープニングを再生
        let isMute = defaults.bool(forKey: Constant.UserDefaultKeys.isMute)
        pushPlayer.playSound(name: Constant.Sounds.push, isMute: isMute)
        appDel.opPlayer.playSound(name: Constant.Sounds.opening, isMute: isMute, loop: -1)
    }
    
    // ゲーム結果に応じてResult画面の画像，タイトルテキスト，モードLOCK変数を変更
    func changeResult(score: Int, mode: String) {
        let modeLock = defaults.integer(forKey: Constant.ModeLock)
        guard let scoreLimit = Constant.scoreLimit[mode] else { return }
        
        if scoreLimit <= score {
            imageManager.imageAnimation(for: resultImage,
                                        mode: "",
                                        action: Constant.AnimationAction.win,
                                        duration: 1.0)
            resultLabel.text = Constant.Texts.winText
            defaults.set(modeOpen(mode: mode, modeLock: modeLock), forKey: Constant.ModeLock)
        } else {
            imageManager.imageAnimation(for: resultImage,
                                        mode: mode,
                                        action: Constant.AnimationAction.lose,
                                        duration: 1.0)
            resultLabel.text = Constant.Texts.loseText
        }
    }

    // ゲーム結果に応じてサウンドを変更
    func changeResultSound(score: Int, mode: String) {
        let isMute = defaults.bool(forKey: Constant.UserDefaultKeys.isMute)
        guard let scoreLimit = Constant.scoreLimit[mode] else { return }
        if scoreLimit <= score {
            edPlayer.playSound(name: Constant.Sounds.win, isMute: isMute)
        } else {
            edPlayer.playSound(name: Constant.Sounds.lose, isMute: isMute)
        }
    }

    // 現在のモードのクリア状況に応じて新しいモードを開放するかを決める
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
