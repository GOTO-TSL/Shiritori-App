//
//  ViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/03.
//

import UIKit
import GRDB
import CoreData

class PlayViewController: UIViewController {

    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var WordLabel: UILabel!
    @IBOutlet weak var TimeBar: UIProgressView!
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var FaceImage: UIImageView!
    @IBOutlet weak var FriendShipImage: UIStackView!
    
    var wordArray = [Word]()
    var myWords = [MyWord]()
    var gameLogic = GameLogic()
    var imageManager = ImageManager()
    var timerManager = TimerManager()
    var wordSource = WordSource()
    var charaEnd: Character = "a"
    var dbQueue = DatabaseQueue()
    let defaults = UserDefaults.standard
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let mode = defaults.string(forKey: "playmode") else { return }
        defaults.set(-10, forKey: "score")
        //難易度によってハートを非表示
        gameLogic.heartVisible(stackView: FriendShipImage, mode: mode)
        changeModeLabel(mode: mode)
        
        //delegateの宣言
        gameLogic.delegate = self
        imageManager.delegate = self
        timerManager.delegate = self
        wordSource.delegate = self
        TextField.delegate = self
        
        //データベースのパスを取得し，データベースキューを設定
        if let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let path = dir.appending("/ejdict.sqlite3")
            do {
                dbQueue = try DatabaseQueue(path: path)
            } catch {
                print("Error \(error)")
            }
        }
        //難易度によって相手の顔を変更
        imageManager.changeFace(mode: mode, feeling: "normal")
        //タイマー処理
        timerManager.gameTimer()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationBarを非表示
        navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //キーボードを自動的に表示
        self.TextField.keyboardType = .alphabet
        self.TextField.becomeFirstResponder()
            
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.TextField.resignFirstResponder()
    }

    //ボタンが押されたときに実行される処理
    @IBAction func AnswerPressed(_ sender: UIButton) {
        gameLogic.applyRule(textField: TextField, endCharacter: charaEnd)
    }
    
    @IBAction func QuitPressed(_ sender: UIButton) {
        self.TextField.resignFirstResponder()
        timerManager.stopTimer()
    }
    
    func changeModeLabel(mode: String) {
        if mode == "EASY" {
            modeLabel.text = mode
            modeLabel.backgroundColor = .systemGreen
        } else if mode == "NORMAL" {
            modeLabel.text = mode
            modeLabel.backgroundColor = .systemBlue
        } else {
            modeLabel.text = mode
            modeLabel.backgroundColor = .systemPink
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

//MARK: - WordSourceDelegate
extension PlayViewController: WordSourceDelegate {
    func addPlayerWord() {
        DispatchQueue.main.async {
            let newWord = Word(context: self.context)
            if let word = self.TextField.text {
                newWord.word = word
                newWord.like = false
            }
            self.wordArray.append(newWord)
            self.saveWord()
        }

    }
    
    func updateWord(_ wordSource: WordSource, word: String) {
        DispatchQueue.main.async {
            print("word get")
            guard let mode = self.defaults.string(forKey: "playmode") else { return }

            if word.count > 0 {
                let newWord = Word(context: self.context)
                newWord.word = word
                newWord.like = false
                self.wordArray.append(newWord)
                self.saveWord()
                self.gameLogic.addPoint()
                self.WordLabel.text = word
                self.charaEnd = word[word.index(before: word.endIndex)]
                self.imageManager.changeFace(mode: mode, feeling: "laugh")
                
                let score = self.defaults.integer(forKey: "score")
                self.imageManager.changeFriendShip(gamescore: score, mode: mode)
                self.TextField.text = ""
                
            } else {
                self.gameLogic.subPoint()
                self.TextField.text = ""
                self.TextField.placeholder = "Invalid word!"
                self.imageManager.changeFace(mode: mode, feeling: "confuse")
                
                let score = self.defaults.integer(forKey: "score")
                self.imageManager.changeFriendShip(gamescore: score, mode: mode)
            }

        }
    }
}
//MARK: - GameLogicDelegate
extension PlayViewController: GameLogicDelegate {
    func shiritoriSucessed() {
        DispatchQueue.main.async {
            self.wordSource.featchWord(dbqueue: self.dbQueue, inputWord: self.TextField.text!)
        }
    }
    
    func shiritoriFailed() {
        guard let mode = defaults.string(forKey: "playmode") else { return }
        DispatchQueue.main.async {
            self.imageManager.changeFace(mode: mode, feeling: "confuse")
            self.gameLogic.subPoint()
            let score = self.defaults.integer(forKey: "score")
            self.imageManager.changeFriendShip(gamescore: score, mode: mode)
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
            self.wordSource.featchWord(dbqueue: self.dbQueue, inputWord: K.alphabet[Int.random(in: 0...24)])
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
            self.performSegue(withIdentifier: K.SegueID.toresult, sender: nil)
            self.timerManager.timer.invalidate()
    }
}
