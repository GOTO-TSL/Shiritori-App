//
//  ViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/03.
//

import UIKit

class PlayViewController: UIViewController {

    @IBOutlet weak var WordLabel: UILabel!
    @IBOutlet weak var TimeBar: UIProgressView!
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var FaceImage: UIImageView!
    @IBOutlet weak var FriendShipImage: UIStackView!
    
    
    
    
    var wordManager = WordManager()
    var gameLogic = GameLogic()
    var imageManager = ImageManager()
    var charaEnd: Character = "a"
    var playmode: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let timerManager = TimerManager(commentLabel: WordLabel, timeBar: TimeBar)
        
        //navigationBarを非表示
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        //難易度によってハートを非表示
        gameLogic.heartVisible(stackView: FriendShipImage, mode: playmode!)
        
        //delegateの宣言
        wordManager.delegate = self
        TextField.delegate = self
        
        //難易度によって相手の顔を変更
        imageManager.changeFace(face: FaceImage, mode: playmode!, feeling: "normal")
        
        //タイマー処理関係
        timerManager.countdownTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(K.Timer.countDownTime)) {
            self.wordManager.featchWord(InputWord: K.alphabet[Int.random(in: 0...25)])
            timerManager.gameTimer()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(K.Timer.playTime+K.Timer.countDownTime+3)) {
            self.performSegue(withIdentifier: K.SegueID.toresult, sender: nil)
        }
        
    }

    //ボタンが押されたときに実行される処理
    @IBAction func AnswerPressed(_ sender: UIButton) {
        if gameLogic.Shiritori(textField: TextField, endCharacter: charaEnd) {
            wordManager.judgeWord(InputWord: TextField.text!)
        } else {
            imageManager.changeFace(face: FaceImage, mode: playmode!, feeling: "confuse")
            self.gameLogic.subPoint()
            self.imageManager.changeFriendShip(heartStack: self.FriendShipImage,
                                               gamescore: self.gameLogic.gamescore,
                                               mode: self.playmode!)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SegueID.toresult {
            let destinationVC = segue.destination as! ResultViewController
            destinationVC.score = self.gameLogic.gamescore
        }
    }
    
}

//MARK: - UITextFieldDelegate
extension PlayViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        TextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            TextField.endEditing(true)
            return true
        } else {
            TextField.endEditing(false)
            return true
        }
    }
    
}

//MARK: - WordManagerDelegate
extension PlayViewController: WordManagerDelegate {
    func didUpdateWord(_ wordManager: WordManager, word: String) {
        DispatchQueue.main.async {
            print("word get")
            self.WordLabel.text = word
            self.charaEnd = word[word.index(before: word.endIndex)]
            self.TextField.text = ""
        }
    }
    
    func didJudgement(_ wordManager: WordManager, judge: Bool) {
        print("judgement get")
        DispatchQueue.main.async {
            if judge {
                self.wordManager.featchWord(InputWord: self.TextField.text!)
                self.imageManager.changeFace(face: self.FaceImage,
                                             mode: self.playmode!,
                                             feeling: "laugh")
                self.gameLogic.addPoint()
                self.imageManager.changeFriendShip(heartStack: self.FriendShipImage,
                                                   gamescore: self.gameLogic.gamescore,
                                                   mode: self.playmode!)
            } else {
                self.TextField.text = ""
                self.TextField.placeholder = "Invalid word!"
                self.imageManager.changeFace(face: self.FaceImage,
                                             mode: self.playmode!,
                                             feeling: "confuse")
                self.gameLogic.subPoint()
                self.imageManager.changeFriendShip(heartStack: self.FriendShipImage,
                                                   gamescore: self.gameLogic.gamescore,
                                                   mode: self.playmode!)
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
