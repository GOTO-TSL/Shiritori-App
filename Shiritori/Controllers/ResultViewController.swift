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
    
    @IBAction func wordsPressed(_ sender: UIButton) {
        let isMute = defaults.bool(forKey: K.UserDefaultKeys.isMute)
        pushPlayer.playSound(name: K.Sounds.push, isMute: isMute)

    }
    
    @IBAction func homePressed(_ sender: UIButton) {
        let isMute = defaults.bool(forKey: K.UserDefaultKeys.isMute)
        pushPlayer.playSound(name: K.Sounds.push, isMute: isMute)
        appDelegate.opPlayer.playSound(name: K.Sounds.op, isMute: isMute, loop: -1)
    }
    
    
    func changeResult(score: Int, mode: String) {
        let isMute = defaults.bool(forKey: K.UserDefaultKeys.isMute)
        if K.scoreLimit[mode] == score {
            self.imageManager.imageAnimation(for: resultImage,
                                             mode: "",
                                             action: K.animationAction.win,
                                             duration: 1.0)
            self.edPlayer.playSound(name: K.Sounds.win, isMute: isMute)
            self.resultLabel.text = K.Texts.winText
        } else {
            self.imageManager.imageAnimation(for: resultImage,
                                             mode: mode,
                                             action: K.animationAction.lose,
                                             duration: 1.0)
            self.edPlayer.playSound(name: K.Sounds.lose, isMute: isMute)
            self.resultLabel.text = K.Texts.loseText
        }
    }
}


