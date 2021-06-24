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
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        easyView.layer.cornerRadius = 20.0
        normalView.layer.cornerRadius = 20.0
        hardView.layer.cornerRadius = 20.0
        
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
        guard let mode = sender.currentTitle else { return }
        defaults.set(mode, forKey: K.UserDefaultKeys.mode)
        changeHeroID(mode: mode)
        self.performSegue(withIdentifier: K.SegueID.toplay, sender: nil)
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
