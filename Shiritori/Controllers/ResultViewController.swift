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
    var mode: String?
    var hitpoint: Int?
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
        
        guard let safeMode = mode else { return }
        guard let safeHP = hitpoint else { return }
        
        changeResult(hitpoint: safeHP, mode: safeMode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        guard let safeMode = mode else { return }
        guard let safeHP = hitpoint else { return }
        changeResultSound(hitpoint: safeHP, mode: safeMode)
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
    func changeResult(hitpoint: Int, mode: String) {
        if hitpoint <= 0 {
            imageManager.imageAnimation(for: resultImage,
                                        mode: "",
                                        action: Constant.AnimationAction.win,
                                        duration: 1.0)
            modeOpen(mode: mode)
            resultLabel.text = Constant.Texts.winText
        } else {
            imageManager.imageAnimation(for: resultImage,
                                        mode: mode,
                                        action: Constant.AnimationAction.lose,
                                        duration: 1.0)
            resultLabel.text = Constant.Texts.loseText
        }
    }

    // ゲーム結果に応じてサウンドを変更
    func changeResultSound(hitpoint: Int, mode: String) {
        let isMute = defaults.bool(forKey: Constant.UserDefaultKeys.isMute)
        if hitpoint <= 0 {
            edPlayer.playSound(name: Constant.Sounds.win, isMute: isMute)
        } else {
            edPlayer.playSound(name: Constant.Sounds.lose, isMute: isMute)
        }
    }

    // 現在のモードのクリア状況に応じて新しいモードを開放するかを決める
    func modeOpen(mode: String) {
        switch mode {
        case "EASY":
            defaults.set(true, forKey: Constant.UserDefaultKeys.isClearEasy)
        case "NORMAL":
            defaults.set(true, forKey: Constant.UserDefaultKeys.isClearNormal)
        case "HARD":
            defaults.set(true, forKey: Constant.UserDefaultKeys.isClearHard)
        default:
            defaults.set(true, forKey: Constant.UserDefaultKeys.isClearEasy)
        }
    }
}
