//
//  ResultViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/04.
//

import UIKit

class ResultViewController: UIViewController {
    
    var imageManager = ImageManager()
    let defaults = UserDefaults.standard
    
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
    
    func changeResult(score: Int, mode: String) {
        if K.scoreLimit[mode] == score {
            self.imageManager.imageAnimation(for: resultImage,
                                             mode: "",
                                             action: K.animationAction.win,
                                             duration: 1.0)
            self.resultLabel.text = K.Texts.winText
        } else {
            self.imageManager.imageAnimation(for: resultImage,
                                             mode: mode,
                                             action: K.animationAction.lose,
                                             duration: 1.0)
            self.resultLabel.text = K.Texts.loseText
        }
    }
}


