//
//  StartViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/04.
//

import UIKit
import CoreData
import GRDB
import AVFoundation

class StartViewController: UIViewController {
    
    @IBOutlet weak var MainTitle: UILabel!
    @IBOutlet weak var SubTitle: UILabel!
    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var SoundButton: UIButton!
    
    var opPlayer = SoundPlayer()
    var pushPlayer = SoundPlayer()
    var wordArray = [Word]()
    var myWords = [MyWord]()
    var wordSource = WordSource()
    var dbQueue = DatabaseQueue()
    var isMute = false
    let defaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MainTitle.text = K.Texts.mainTitle
        SubTitle.text = K.Texts.subTitle
        
        let ismute = defaults.bool(forKey: K.UserDefaultKeys.isMute)
        isMute = ismute
        isMute ? SoundButton.setImage(K.Images.Sounds[1], for: .normal) : SoundButton.setImage(K.Images.Sounds[0], for: .normal)
        
        createDatabase()
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        PlayButton.layer.cornerRadius = 5.0
        //データベースのパスを取得しデータベースキューを設定
        if let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let path = dir.appending(K.DataBase.path)
            do {
                dbQueue = try DatabaseQueue(path: path)
            } catch {
                print("Error \(error)")
            }
        }
        
        loadWord()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //単語リストに単語を追加
        for word in wordArray {
            if word.like {
                let newMyWord = MyWord(context: context)
                newMyWord.myword = word.word
                newMyWord.mean = wordSource.featchMean(dbqueue: dbQueue, word: newMyWord.myword!)
                myWords.append(newMyWord)
                context.delete(word)
                saveWord()
            } else {
                context.delete(word)
                saveWord()
            }
        }
    }
    @IBAction func soundPressed(_ sender: UIButton) {
        //ミュート変数の値を変更
        isMute = isMute ? false : true
        //ミュートかどうかで画像を変更
        isMute ? SoundButton.setImage(K.Images.Sounds[1], for: .normal) : SoundButton.setImage(K.Images.Sounds[0], for: .normal)
        
        appDelegate.opPlayer.muteSound(isMute: isMute)
        defaults.set(isMute, forKey: K.UserDefaultKeys.isMute)
    }
    
    @IBAction func otherButtonPressed(_ sender: UIButton) {
        pushPlayer.playSound(name: K.Sounds.push, isMute: isMute)
    }
    @IBAction func playButtonPressed(_ sender: UIButton) {
        pushPlayer.playSound(name: K.Sounds.push,  isMute: isMute)
    }
    
    //MARK: - Data Manipulation Methods
    func saveWord() {
        do {
            try context.save()
            
        } catch {
            print("Error saving word array, \(error)")
            
        }
    }
    
    func loadWord(with request: NSFetchRequest<Word> = Word.fetchRequest()) {
        do {
            wordArray = try context.fetch(request)
        } catch {
            print("Error loading word from context \(error)")
        }
    }
    /*
     データベースファイルをコピーする処理
     マスターデータファイルをアプリ実行時のディレクトリにコピーする
     */
    func createDatabase(){
        let fileManager = FileManager.default
        guard let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let finalDatabaseURL = documentsUrl.appendingPathComponent(K.DataBase.name)
        do {
            if !fileManager.fileExists(atPath: finalDatabaseURL.path) {
//                print("DB does not exist in documents folder")
                if let dbFilePath = Bundle.main.path(forResource: K.DataBase.fore, ofType: K.DataBase.back) {
                    try fileManager.copyItem(atPath: dbFilePath, toPath: finalDatabaseURL.path)
                } else {
//                    print("Uh oh - foo.db is not in the app bundle")
                }
            } else {
//                print("Database file found at path: \(finalDatabaseURL.path)")
            }
        } catch {
//            print("Unable to copy foo.db: \(error)")
        }
    }

}
