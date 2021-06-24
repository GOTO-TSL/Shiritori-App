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
    @IBOutlet weak var modeView: UIView!
    @IBOutlet weak var HitPointBar: UIProgressView!
    
    var wordArray = [Word]()
    var gameLogic = GameLogic()
    var imageManager = ImageManager()
    var timerManager = TimerManager()
    var wordSource = WordSource()
    var dbQueue = DatabaseQueue()
    let defaults = UserDefaults.standard
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let mode = defaults.string(forKey: "playmode") else { return }
        defaults.set(0, forKey: "score")
        defaults.set("aaaa", forKey: "currentWord")
        
        modeView.layer.cornerRadius = 5.0
        //モードによってviewやlabelなどを変更
        changeModeLabel(mode: mode)
        FaceImage.image = K.Images.enemy[mode]
        
        //delegateの宣言
        gameLogic.delegate = self
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
        //imageManager.changeFace(mode: mode, feeling: "normal")
        //ゲーム開始のタイマースタート
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
        guard let userInput = TextField.text else { return }
        gameLogic.applyRule(for: userInput)
    }
    
    @IBAction func QuitPressed(_ sender: UIButton) {
        self.TextField.resignFirstResponder()
        timerManager.stopTimer()
    }
    
    func changeModeLabel(mode: String) {
        modeLabel.text = mode
        modeLabel.backgroundColor = K.modeColor[mode]
        modeView.backgroundColor = K.modeColor[mode]
    }

    
    func saveWord(word: String) {
        let newWord = Word(context: context)
        newWord.word = word
        newWord.like = false
        wordArray.append(newWord)
        
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
    func invalidWord() {
        DispatchQueue.main.async {
            self.WordLabel.text = "Invalid Word!"
            self.gameLogic.subGamePoint()
            self.TextField.text = ""
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            guard let current = self.defaults.string(forKey: "currentWord") else { return }
            self.WordLabel.text = current
        }
    }
    
    func addPlayerWord() {
        DispatchQueue.main.async {
            if let word = self.TextField.text {
                self.saveWord(word: word)
            }
        }

    }
    
    func updateFirst(word: String) {
        DispatchQueue.main.async {
            self.saveWord(word: word)
            self.WordLabel.text = word
            self.defaults.set(word, forKey: "currentWord")
            
        }
    }
    
    func updateWord(word: String) {
        DispatchQueue.main.async {
            
            self.saveWord(word: word)
            self.WordLabel.text = word
            self.defaults.set(word, forKey: "currentWord")
            self.gameLogic.addGamePoint()
            self.TextField.text = ""
            
        }
    }
}
//MARK: - GameLogicDelegate
extension PlayViewController: GameLogicDelegate {
    func updateHitPoint(score: Int, scoreLimit: Int) {
        DispatchQueue.main.async {
            self.HitPointBar.progress = 1.0 - Float(score) / Float(scoreLimit)
        }
    }
    
    func shiritoriSucessed() {
        DispatchQueue.main.async {
            guard let text = self.TextField.text else { return }
            self.wordSource.featchWord(dbqueue: self.dbQueue, inputWord: text)
        }
    }
    
    func shiritoriFailed(comment: String) {
        DispatchQueue.main.async {
            self.gameLogic.subGamePoint()
            self.WordLabel.text = comment
            self.TextField.text = ""
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            guard let current = self.defaults.string(forKey: "currentWord") else { return }
            self.WordLabel.text = current
        }
    }
    
    func gotoResultView() {
        DispatchQueue.main.async {
            self.WordLabel.text = "やられた～"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.performSegue(withIdentifier: K.SegueID.toresult, sender: nil)
            self.timerManager.mainTimer.invalidate()
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
            guard let mode = self.defaults.string(forKey: "playmode") else { return }
            self.wordSource.featchFirstWord(dbqueue: self.dbQueue)
            self.imageManager.imageAnimation(for: self.FaceImage, mode: mode)
        }
    }
    
    func gotoNextView() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: K.SegueID.toresult, sender: nil)
        }
    }
}

