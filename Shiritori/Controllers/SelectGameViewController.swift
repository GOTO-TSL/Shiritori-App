//
//  SelectGameViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/30.
//

import Hero
import UIKit

class SelectGameViewController: UIViewController {
    @IBOutlet weak var easyView: UIView!
    @IBOutlet weak var normalView: UIView!
    @IBOutlet weak var hardView: UIView!
    @IBOutlet weak var easyFace: UIImageView!
    @IBOutlet weak var normalFace: UIImageView!
    @IBOutlet weak var hardFace: UIImageView!
    @IBOutlet weak var normalHideView: UIView!
    @IBOutlet weak var hardHideView: UIView!
    
    let defaults = UserDefaults.standard
    var pushPlayer = SoundPlayer()
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modeUnLock()
        easyView.layer.cornerRadius = 20.0
        normalView.layer.cornerRadius = 20.0
        hardView.layer.cornerRadius = 20.0
        normalHideView.layer.cornerRadius = 20.0
        hardHideView.layer.cornerRadius = 20.0
        
        easyFace.layer.cornerRadius = 40.0
        normalFace.layer.cornerRadius = 40.0
        hardFace.layer.cornerRadius = 40.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // モード選択
    @IBAction func modeSelected(_ sender: UIButton) {
        // オープニングの停止，ボタンの効果音再生
        let isMute = defaults.bool(forKey: Constant.UserDefaultKeys.isMute)
        guard let appDel = appDelegate else { return }
        pushPlayer.playSound(name: Constant.Sounds.push, isMute: isMute)
        appDel.opPlayer.stopSound()
        // 選んだモードのViewにHeroIDを設定
        guard let mode = sender.currentTitle else { return }
        defaults.set(mode, forKey: Constant.UserDefaultKeys.mode)
        changeHeroID(mode: mode)
        // PlayVCに画面遷移
        performSegue(withIdentifier: Constant.SegueID.toplay, sender: nil)
    }

    // モードのロックを解除する
    func modeUnLock() {
        let modeLock = defaults.integer(forKey: Constant.ModeLock)
        if modeLock == 2 {
            normalHideView.removeFromSuperview()
            normalFace.image = Constant.Images.enemy[Constant.Mode.normal]
        } else if modeLock == 3 {
            normalHideView.removeFromSuperview()
            hardHideView.removeFromSuperview()
            normalFace.image = Constant.Images.enemy[Constant.Mode.normal]
            hardFace.image = Constant.Images.enemy[Constant.Mode.hard]
        }
    }
    
    // 選ばれたモードに応じてHeroIDを設定する
    func changeHeroID(mode: String) {
        if mode == Constant.Mode.easy {
            easyView.heroID = Constant.HeroID.mode
            easyFace.heroID = Constant.HeroID.enemy
            
        } else if mode == Constant.Mode.normal {
            normalView.heroID = Constant.HeroID.mode
            normalFace.heroID = Constant.HeroID.enemy
        } else {
            hardView.heroID = Constant.HeroID.mode
            hardFace.heroID = Constant.HeroID.enemy
        }
    }
}
