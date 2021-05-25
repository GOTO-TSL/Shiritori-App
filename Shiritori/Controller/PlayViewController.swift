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
    @IBOutlet weak var CenterImage: UIImageView!
    @IBOutlet weak var TopView: UIView!
    @IBOutlet weak var SecondView: UIView!
    @IBOutlet weak var ThiredView: UIView!
    
    let imagedata = ImageManager()
    var wordManager = WordManager()
    var shiritoriManager = ShiritoriManager()
    var gamescore: Int = -10
    var timer = Timer()
    var timerCount = 0
    var bomberCount = 0
    var wordEnd: Character = "a"
    let alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        wordManager.delegate = self
        TextField.delegate = self
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.TimerCount), userInfo: nil, repeats: true)
        //キーボードに合わせてtextFieldを上に上げる
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
    }

    //ボタンが押されたときに実行される処理
    @IBAction func AnswerPressed(_ sender: UIButton) {
        if shiritoriManager.Shiritori(textField: TextField, endOfWord: wordEnd) {
            wordManager.judgeWord(InputWord: TextField.text!)
        }
    }
    
    //キーボードが出てきたら呼ばれる処理
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
                self.ThiredView.frame.origin.y += 120
                self.SecondView.frame.origin.y += 200
                self.TopView.frame.origin.y += 280
            } else {
                let suggestionHeight = self.view.frame.origin.y + keyboardSize.height
                self.view.frame.origin.y -= suggestionHeight
            }
        }
    }
    
    //キーボードが隠れたら呼ばれる処理
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
            self.ThiredView.frame.origin.y -= 120
            self.SecondView.frame.origin.y -= 200
            self.TopView.frame.origin.y -= 280
        }
    }
    
    //キーボード以外の場所が押されたとき呼ばれる処理
    @objc func dismissKeyboard() {
            self.view.endEditing(true)
        }
    
    
    
    @objc func TimerCount() {
        TimeBar.progress = 1.0 - Float(bomberCount)/60
        timerCount += 1
        if timerCount == 4 {
            CenterImage.image = imagedata.countImage[timerCount-1]
        } else if timerCount > 4 {
            bomberCount = timerCount - 4
            switch bomberCount {
            case 1:
                CenterImage.image = imagedata.bombImage[0]
                self.wordManager.featchWord(InputWord: alphabet[Int.random(in: 0...25)])
            case 2..<22:
                CenterImage.image = imagedata.bombImage[0]
                UIView.animate(withDuration: 1.5, delay: 0.0, options: [.curveEaseIn, .autoreverse], animations: {
                    self.CenterImage.center.x += 10
                }) { _ in
                    self.CenterImage.center.x -= 10
                }
            case 6..<42:
                CenterImage.image = imagedata.bombImage[1]
                UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseIn, .autoreverse], animations: {
                    self.CenterImage.center.x += 15
                }) { _ in
                    self.CenterImage.center.x -= 15
                }
            case 11..<62:
                CenterImage.image = imagedata.bombImage[2]
                UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseIn, .autoreverse], animations: {
                    self.CenterImage.center.x += 20
                }) { _ in
                    self.CenterImage.center.x -= 20
                }
            case 62:
                timer.invalidate()
                timerCount = 0
                self.performSegue(withIdentifier: "toResult", sender: nil)
            default:
                CenterImage.image = imagedata.bombImage[0]
            }
        } else {
            CenterImage.image = imagedata.countImage[timerCount-1]
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
            self.wordEnd = word[word.index(before: word.endIndex)]
            self.TextField.text = ""
        }
    }
    
    func didUpdateJudgement(_ wordManager: WordManager, judge: Bool) {
        print("judgement get")
        DispatchQueue.main.async {
            if judge {
                self.wordManager.featchWord(InputWord: self.TextField.text!)
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
