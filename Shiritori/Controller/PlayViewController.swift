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
    
    
    let imageManager = ImageManager()
    var wordManager = WordManager()
    var shiritoriManager = ShiritoriManager()
    var gamescore: Int = -10
    var timer = Timer()
    var timerCount = 0
    var bomberCount = 0
    var charaEnd: Character = "a"
    let alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        wordManager.delegate = self
        TextField.delegate = self
        self.wordManager.featchWord(InputWord: alphabet[Int.random(in: 0...25)])
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.TimerCount), userInfo: nil, repeats: true)
        
    }

    //ボタンが押されたときに実行される処理
    @IBAction func AnswerPressed(_ sender: UIButton) {
        if shiritoriManager.Shiritori(textField: TextField, endCharacter: charaEnd) {
            wordManager.judgeWord(InputWord: TextField.text!)
        }
    }
    
    
    
    @objc func TimerCount() {
        TimeBar.progress = 1.0 - Float(bomberCount)/60
        timerCount += 1
        if timerCount == 4 {
            self.WordLabel.text = "対戦ヨロシク！"
        } else if timerCount > 4 {
            bomberCount = timerCount - 4
            switch bomberCount {
            case 1:
                FaceImage.image = imageManager.FaceImage[0]
            case 2..<22:
                FaceImage.image = imageManager.FaceImage[0]
            case 6..<42:
                FaceImage.image = imageManager.FaceImage[1]
            case 11..<62:
                FaceImage.image = imageManager.FaceImage[2]
            case 62:
                timer.invalidate()
                timerCount = 0
                self.performSegue(withIdentifier: "toResult", sender: nil)
            default:
                FaceImage.image = imageManager.FaceImage[0]
            }
        } else {
            FaceImage.image = imageManager.FaceImage[timerCount-1]
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResult" {
            let destinationVC = segue.destination as! ResultViewController
            destinationVC.score = gamescore
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
    
    func didUpdateJudgement(_ wordManager: WordManager, judge: Bool) {
        print("judgement get")
        DispatchQueue.main.async {
            if judge {
                self.wordManager.featchWord(InputWord: self.TextField.text!)
                self.FaceImage.image = self.imageManager.FaceImage[1]
                self.gamescore += 10
            } else {
                self.TextField.text = ""
                self.TextField.placeholder = "Invalid word!"
                self.gamescore -= 10
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
