//
//  ResultViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/04.
//

import UIKit

class ResultViewController: UIViewController {
    
    var score: Int?
    var playmode: String?
    var imageManager = ImageManager()
    
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var WordsButton: UIButton!
    @IBOutlet weak var HomeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WordsButton.layer.cornerRadius = 5.0
        HomeButton.layer.cornerRadius = 5.0
        
        imageManager.delegate = self
        imageManager.changeResultImage(gamescore: score!, mode: playmode!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

}

extension ResultViewController: ImageManagerDelegate {
    func didUpdateFace(mode: String, index: Int) {
        //do nothing
    }
    
    func didUpdateHeart(end: Int, row: Int, isHalf: Bool) {
        //do nothing
    }
    
    func didUpdateResult(isHappy: Bool, modeIndex: Int) {
        DispatchQueue.main.async {
            if isHappy {
                self.resultLabel.text = "Became friends!"
                self.leftImage.image = K.Images.ending[modeIndex][0]
                self.rightImage.image = K.Images.playerEnd[0]
            } else {
                self.resultLabel.text = "Couldn't be friends."
                self.leftImage.image = K.Images.ending[modeIndex][1]
                self.rightImage.image = K.Images.playerEnd[1]
            }
        }
    }
    
    func gotoResultView() {
        //do nothing
    }
    
    
}


