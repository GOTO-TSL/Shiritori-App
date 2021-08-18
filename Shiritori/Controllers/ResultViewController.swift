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
    var mode: String = ""
    var hitpoint: Int = 0
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
        
        guard let safeMode = defaults.string(forKey: Constant.UserDefaultKeys.currentMode) else { return }
        mode = safeMode
        hitpoint = defaults.integer(forKey: Constant.UserDefaultKeys.hitpoint)
        changeResult(hitpoint: hitpoint, mode: mode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        changeResultSound(hitpoint: hitpoint, mode: mode)
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
    
    /// 結果に応じてタイトルテキストと画像を変更
    /// - Parameters:
    ///   - hitpoint: 最終的な敵のHP値
    ///   - mode: 選択中のモード
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
    
    /// 結果に応じてサウンドを変更
    /// - Parameters:
    ///   - hitpoint: 最終的な敵のHP値
    ///   - mode: 選択中のモード
    func changeResultSound(hitpoint: Int, mode: String) {
        let isMute = defaults.bool(forKey: Constant.UserDefaultKeys.isMute)
        if hitpoint <= 0 {
            edPlayer.playSound(name: Constant.Sounds.win, isMute: isMute)
        } else {
            edPlayer.playSound(name: Constant.Sounds.lose, isMute: isMute)
        }
    }

    /// モード開放のためのUserDefaultを設定
    /// - Parameter mode: 選択中のモード
    func modeOpen(mode: String) {
        switch mode {
        case "EASY":
            if defaults.integer(forKey: Constant.UserDefaultKeys.isClearEasy) != 2 {
                defaults.set(1, forKey: Constant.UserDefaultKeys.isClearEasy)
            }
        case "NORMAL":
            if defaults.integer(forKey: Constant.UserDefaultKeys.isClearNormal) != 2 {
                defaults.set(1, forKey: Constant.UserDefaultKeys.isClearNormal)
            }
        case "HARD":
            if defaults.integer(forKey: Constant.UserDefaultKeys.isClearHard) != 2 {
                defaults.set(1, forKey: Constant.UserDefaultKeys.isClearHard)
            }
        default:
            defaults.set(1, forKey: Constant.UserDefaultKeys.isClearEasy)
        }
    }
}
