//
//  SelectGameViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/30.
//

import UIKit
import Hero

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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let EASYview = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        openModeLock()
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
    
    //モード選択
    @IBAction func modeSelected(_ sender: UIButton) {
        //オープニングの停止，ボタンの効果音再生
        let isMute = defaults.bool(forKey: K.UserDefaultKeys.isMute)
        pushPlayer.playSound(name: K.Sounds.push, isMute: isMute)
        appDelegate.opPlayer.stopSound()
        //選んだモードのViewにHeroIDを設定
        guard let mode = sender.currentTitle else { return }
        defaults.set(mode, forKey: K.UserDefaultKeys.mode)
        changeHeroID(mode: mode)
        //PlayVCに画面遷移
        self.performSegue(withIdentifier: K.SegueID.toplay, sender: nil)
    }
    //モードのロックを解除する
    func openModeLock() {
        let modeLock = defaults.integer(forKey: K.ModeLock)
        if modeLock == 2 {
            normalHideView.removeFromSuperview()
            normalFace.image = K.Images.enemy[K.Mode.normal]
        } else if modeLock == 3 {
            normalHideView.removeFromSuperview()
            hardHideView.removeFromSuperview()
            normalFace.image = K.Images.enemy[K.Mode.normal]
            hardFace.image = K.Images.enemy[K.Mode.hard]
        }
    }
    
    
    func changeHeroID(mode: String) {
        if mode == K.Mode.easy {
            easyView.heroID = K.HeroID.mode
            easyFace.heroID = K.HeroID.enemy
            
        } else if mode == K.Mode.normal {
            normalView.heroID = K.HeroID.mode
            normalFace.heroID = K.HeroID.enemy
        } else {
            hardView.heroID = K.HeroID.mode
            hardFace.heroID = K.HeroID.enemy
        }
    }


}
