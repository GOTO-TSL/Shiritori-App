//
//  SelectGameViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/30.
//

import UIKit
import Hero

class SelectGameViewController: UIViewController {
    var mode = ""
    
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
        mode = sender.currentTitle!
        defaults.set(mode, forKey: "playmode")
        changeHeroID(mode: mode)
        self.performSegue(withIdentifier: K.SegueID.toplay, sender: nil)
    }
    
    
    func changeHeroID(mode: String) {
        if mode == "EASY" {
            easyView.heroID = "mode"
            easyFace.heroID = "face"
            
        } else if mode == "NORMAL" {
            normalView.heroID = "mode"
            normalFace.heroID = "face"
        } else {
            hardView.heroID = "mode"
            hardFace.heroID = "face"
        }
    }


}
