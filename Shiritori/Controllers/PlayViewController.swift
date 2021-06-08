//
//  ViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/03.
//

import UIKit
import CoreData

class PlayViewController: UIViewController {

    @IBOutlet weak var WordLabel: UILabel!
    @IBOutlet weak var TimeBar: UIProgressView!
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var FaceImage: UIImageView!
    @IBOutlet weak var FriendShipImage: UIStackView!
    
    
    var wordArray = [Word]()
    var wordManager = WordManager()
    var gameLogic = GameLogic()
    var imageManager = ImageManager()
    var timerManager = TimerManager()
    var charaEnd: Character = "a"
    var playmode: String?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationBarを非表示
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        //難易度によってハートを非表示
        gameLogic.heartVisible(stackView: FriendShipImage, mode: playmode!)
        
        //delegateの宣言
        wordManager.delegate = self
        timerManager.delegate = self
        gameLogic.delegate = self
        imageManager.delegate = self
        TextField.delegate = self
        
        //難易度によって相手の顔を変更
        imageManager.changeFace(mode: playmode!, feeling: "normal")
        
        //タイマー処理
        timerManager.gameTimer()
        
    }

    //ボタンが押されたときに実行される処理
    @IBAction func AnswerPressed(_ sender: UIButton) {
        gameLogic.applyRule(textField: TextField, endCharacter: charaEnd)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SegueID.toresult {
            let destinationVC = segue.destination as! ResultViewController
            destinationVC.score = self.gameLogic.gamescore
            destinationVC.playmode = self.playmode
        }
    }
    
    func saveWord() {
        do {
            try context.save()
            
        } catch {
            print("Error saving word array, \(error)")
            
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
            let newWord = Word(context: self.context)
            newWord.word = word
            newWord.like = false
            self.wordArray.append(newWord)
            self.saveWord()
            self.WordLabel.text = word
            self.charaEnd = word[word.index(before: word.endIndex)]
            self.TextField.text = ""
        }
    }
    
    func didJudgement(_ wordManager: WordManager, judge: Bool) {
        print("judgement get")
        DispatchQueue.main.async {
            if judge {
                let newWord = Word(context: self.context)
                if let word = self.TextField.text {
                    newWord.word = word
                    newWord.like = false
                }
                self.wordArray.append(newWord)
                self.saveWord()
                
                self.wordManager.featchWord(InputWord: self.TextField.text!)
                self.imageManager.changeFace(mode: self.playmode!, feeling: "laugh")
                self.gameLogic.addPoint()
                self.imageManager.changeFriendShip(gamescore: self.gameLogic.gamescore, mode: self.playmode!)
            } else {
                self.TextField.text = ""
                self.TextField.placeholder = "Invalid word!"
                self.imageManager.changeFace(mode: self.playmode!, feeling: "confuse")
                self.gameLogic.subPoint()
                self.imageManager.changeFriendShip(gamescore: self.gameLogic.gamescore, mode: self.playmode!)
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - GameLogicDelegate
extension PlayViewController: GameLogicDelegate {
    func shiritoriSucessed() {
        DispatchQueue.main.async {
            self.wordManager.judgeWord(InputWord: self.TextField.text!)
        }
    }
    
    func shiritoriFailed() {
        DispatchQueue.main.async {
            self.imageManager.changeFace(mode: self.playmode!, feeling: "confuse")
            self.gameLogic.subPoint()
            self.imageManager.changeFriendShip(gamescore: self.gameLogic.gamescore, mode: self.playmode!)
        }
    }
}

//MARK: - TimerManagerDelegate
extension PlayViewController: TimerManagerDelegate {
    func didUpdateComment(comment: String) {
        DispatchQueue.main.async {
            self.WordLabel.text = comment
        }
    }
    
    func didUpdateTimeBar(timeNow: Float) {
        DispatchQueue.main.async {
            self.TimeBar.progress = timeNow
        }
    }
    
    func gameStart() {
        DispatchQueue.main.async {
            self.wordManager.featchWord(InputWord: K.alphabet[Int.random(in: 0...24)])
        }
    }
    
    func gotoNextView() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: K.SegueID.toresult, sender: nil)
        }
    }
}

//MARK: - ImageManagerDelegate
extension PlayViewController: ImageManagerDelegate {
    func didUpdateResult(isHappy: Bool, modeIndex: Int) {
        //do nothing
    }
    
    func didUpdateFace(mode: String, index: Int) {
        DispatchQueue.main.async {
            if mode == "EASY" {
                self.FaceImage.image = K.Images.easyFace[index]
            } else if mode == "NORMAL" {
                self.FaceImage.image = K.Images.normalFace[index]
            } else {
                self.FaceImage.image = K.Images.hardFace[index]
            }            
        }
    }
    
    func didUpdateHeart(end: Int, row: Int, isHalf: Bool) {
        DispatchQueue.main.async {
            if let hearts = self.FriendShipImage.arrangedSubviews as? [UIStackView] {
                if let heart = hearts[row].arrangedSubviews as? [UIImageView] {
                    for i in 0...4 {
                        heart[i].image = K.Images.hearts[0]
                    }
                    if isHalf {
                        if end >= 0 {
                            for i in 0..<end {
                                heart[i].image = K.Images.hearts[2]
                            }
                            heart[end].image = K.Images.hearts[1]
                        }
                    } else {
                        if end >= 0 {
                            for i in 0...end {
                                heart[i].image = K.Images.hearts[2]
                            }
                        }
                    }
                }
            }
        }
    }
    
    func gotoResultView() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: K.SegueID.toresult, sender: nil)
            self.timerManager.timer.invalidate()
        }
    }
}
