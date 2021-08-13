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
    @IBOutlet weak var easyImage: UIImageView!
    @IBOutlet weak var normalImage: UIImageView!
    @IBOutlet weak var hardImage: UIImageView!
    @IBOutlet weak var normalHideView: UIView!
    @IBOutlet weak var hardHideView: UIView!
    
    let defaults = UserDefaults.standard
    var pushPlayer = SoundPlayer()
    var currentMode: String = ""
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modeUnLock()
        
        let modeViews = [easyView, normalView, hardView, normalHideView, hardHideView]
        let modeImages = [easyImage, normalImage, hardImage]
        modeViews.forEach { $0?.layer.cornerRadius = 10.0 }
        modeImages.forEach { $0?.layer.cornerRadius = 40.0 }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueID.toplay {
            let destinationVC = segue.destination as? PlayViewController
            destinationVC?.currentMode = currentMode
        }
    }
    
    /// モード選択
    @IBAction func modeSelected(_ sender: UIButton) {
        // オープニングの停止，ボタンの効果音再生
        let isMute = defaults.bool(forKey: Constant.UserDefaultKeys.isMute)
        guard let appDel = appDelegate else { return }
        pushPlayer.playSound(name: Constant.Sounds.push, isMute: isMute)
        appDel.opPlayer.stopSound()
        // 選んだモードのViewにHeroIDを設定
        guard let mode = sender.currentTitle else { return }
        currentMode = mode
        changeHeroID(mode: mode)
        // PlayVCに画面遷移
        performSegue(withIdentifier: Constant.SegueID.toplay, sender: nil)
    }

    /// モードのロックを解除する
    func modeUnLock() {
        if defaults.integer(forKey: Constant.UserDefaultKeys.isClearEasy) >= 1 {
            normalHideView.removeFromSuperview()
            normalImage.image = Constant.Images.enemy[Constant.Mode.normal]
        }
        
        if defaults.integer(forKey: Constant.UserDefaultKeys.isClearNormal) >= 1 {
            normalHideView.removeFromSuperview()
            hardHideView.removeFromSuperview()
            normalImage.image = Constant.Images.enemy[Constant.Mode.normal]
            hardImage.image = Constant.Images.enemy[Constant.Mode.hard]
        }
    }
    
    /// 選ばれたモードに応じてHeroIDを設定する
    /// - Parameter mode: モード
    func changeHeroID(mode: String) {
        if mode == Constant.Mode.easy {
            easyView.heroID = Constant.HeroID.mode
            easyImage.heroID = Constant.HeroID.enemy
            
        } else if mode == Constant.Mode.normal {
            normalView.heroID = Constant.HeroID.mode
            normalImage.heroID = Constant.HeroID.enemy
        } else {
            hardView.heroID = Constant.HeroID.mode
            hardImage.heroID = Constant.HeroID.enemy
        }
    }
}
