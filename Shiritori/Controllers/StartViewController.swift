//
//  StartViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/04.
//

import UIKit
import RealmSwift
import GRDB
import AVFoundation

class StartViewController: UIViewController {
    
    @IBOutlet weak var MainTitle: UILabel!
    @IBOutlet weak var SubTitle: UILabel!
    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var SoundButton: UIButton!
    @IBOutlet weak var easyFigure: UIButton!
    @IBOutlet weak var normalFigure: UIButton!
    @IBOutlet weak var hardFigure: UIButton!
    @IBOutlet weak var EASYView: UIView!
    @IBOutlet weak var NORMALView: UIView!
    @IBOutlet weak var HARDView: UIView!
    
    var opPlayer = SoundPlayer()
    var pushPlayer = SoundPlayer()
    var figurePlayer = SoundPlayer()
    var wordSource = WordSource()
    var isMute = false
    let defaults = UserDefaults.standard
    let realm = try! Realm()
    var words: Results<Word>?
    var myWords: Results<MyWord>?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaults.bool(forKey: K.UserDefaultKeys.firstLaunch) {
            defaults.set(1, forKey: K.ModeLock)
            defaults.set(false, forKey: K.UserDefaultKeys.firstLaunch)
        }
        
        MainTitle.text = K.Texts.mainTitle
        SubTitle.text = K.Texts.subTitle
        
        let ismute = defaults.bool(forKey: K.UserDefaultKeys.isMute)
        isMute = ismute
        isMute ? SoundButton.setImage(K.Images.Sounds[1], for: .normal) : SoundButton.setImage(K.Images.Sounds[0], for: .normal)
        
        Figure()
        load()
        
        wordSource.createDatabase()
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        PlayButton.layer.cornerRadius = 5.0
        
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let newWord = Word()
        newWord.name = "waaa"
        newWord.isLike = false
        save(model: newWord)
        
        guard let words = words else { fatalError() }
        for word in words {
            if word.isLike {
                let newMyWord = MyWord()
                newMyWord.name = word.name
                newMyWord.mean = wordSource.featchMean(word: newMyWord.name)
                save(model: newMyWord)
            } else {
                do {
                    try realm.write {
                        realm.delete(word)
                    }
                } catch {
                    print("Error deleting word, \(error)")
                }
            }
        }
        //単語リストに単語を追加
//        for word in words {
//            if word.like {
//                var newMyWord = MyWord()
//                newMyWord.name = word.name
//                newMyWord.mean = wordSource.featchMean(word: newMyWord.myword!)
//                saveWord()
//            } else {
//                context.delete(word)
//                saveWord()
//            }
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.easyFigure.addTarget(self, action: #selector(self.tapButton(_ :)), for: .touchDown)
        self.easyFigure.addTarget(self, action: #selector(self.tapButton2(_ :)), for: .touchUpInside)
        self.normalFigure.addTarget(self, action: #selector(self.tapButton(_ :)), for: .touchDown)
        self.normalFigure.addTarget(self, action: #selector(self.tapButton2(_ :)), for: .touchUpInside)
        self.hardFigure.addTarget(self, action: #selector(self.tapButton(_ :)), for: .touchDown)
        self.hardFigure.addTarget(self, action: #selector(self.tapButton2(_ :)), for: .touchUpInside)
    }
    
    @objc func tapButton(_ sender: UIButton) {
        guard let id = sender.accessibilityIdentifier else { print("error"); return }
        sender.setImage(K.Images.figure[id]?[1], for: .normal)
        figurePlayer.playSound(name: id+"0")
    }
    
    @objc func tapButton2(_ sender: UIButton) {
        guard let id = sender.accessibilityIdentifier else { print("error"); return }
        sender.setImage(K.Images.figure[id]?[0], for: .normal)
        figurePlayer.playSound(name: id+"1")
    }
    
    @IBAction func soundPressed(_ sender: UIButton) {
        //ミュート変数の値を変更
        isMute = isMute ? false : true
        //ミュートかどうかで画像を変更
        isMute ? SoundButton.setImage(K.Images.Sounds[1], for: .normal) : SoundButton.setImage(K.Images.Sounds[0], for: .normal)
        
        appDelegate.opPlayer.muteSound(isMute: isMute)
        defaults.set(isMute, forKey: K.UserDefaultKeys.isMute)
    }
    
    func Figure() {
        let modeLock = defaults.integer(forKey: K.ModeLock)
        switch modeLock {
        case 1:
            EASYView.isHidden = true
            NORMALView.isHidden = true
            HARDView.isHidden = true
        case 2:
            EASYView.isHidden = false
            NORMALView.isHidden = true
            HARDView.isHidden = true
        case 3:
            EASYView.isHidden = false
            NORMALView.isHidden = false
            HARDView.isHidden = true
        case 4:
            EASYView.isHidden = false
            NORMALView.isHidden = false
            HARDView.isHidden = false
        default:
            EASYView.isHidden = true
            NORMALView.isHidden = true
            HARDView.isHidden = true
        }
    }
    
    
    @IBAction func otherButtonPressed(_ sender: UIButton) {
        pushPlayer.playSound(name: K.Sounds.push, isMute: isMute)
    }
    @IBAction func playButtonPressed(_ sender: UIButton) {
        pushPlayer.playSound(name: K.Sounds.push,  isMute: isMute)
    }
    
    func save(model: Object) {
        do {
            try realm.write {
                realm.add(model)
            }
        } catch {
            print("Error saving word, \(error)")
        }
    }
    
    func load() {
        words = realm.objects(Word.self)
        myWords = realm.objects(MyWord.self)
    }
    
    
    //MARK: - Data Manipulation Methods
//    func saveWord() {
//        do {
//            try context.save()
//
//        } catch {
//            print("Error saving word array, \(error)")
//
//        }
//    }
//
//    func loadWord(with request: NSFetchRequest<Word> = Word.fetchRequest()) {
//        do {
//            wordArray = try context.fetch(request)
//        } catch {
//            print("Error loading word from context \(error)")
//        }
//    }

}
