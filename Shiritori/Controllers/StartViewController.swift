//
//  StartViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/04.
//

import AVFoundation
import GRDB
import UIKit

class StartViewController: UIViewController {
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
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
    var dataManager = DataManager()
    var isMute = false
    let defaults = UserDefaults.standard
    var dbQueue = DatabaseQueue()
    
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初回起動時のみ実行する処理のための値をセット
        if defaults.bool(forKey: Constant.UserDefaultKeys.firstLaunch) {
            defaults.set(1, forKey: Constant.ModeLock)
            defaults.set(false, forKey: Constant.UserDefaultKeys.firstLaunch)
        }
        
        // タイトルを表示
        mainTitle.text = Constant.Texts.mainTitle
        subTitle.text = Constant.Texts.subTitle
        
        // BGMをミュートに切り替える処理
        let ismute = defaults.bool(forKey: Constant.UserDefaultKeys.isMute)
        isMute = ismute
        isMute ? soundButton.setImage(Constant.Images.Sounds[1], for: .normal) : soundButton.setImage(Constant.Images.Sounds[0], for: .normal)
        
        figure()
        
        dataManager.loadWords()
        dataManager.loadMyWords()
        
        wordSource.createDatabase()
        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        playButton.layer.cornerRadius = 5.0
        
        if let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let path = dir.appending(Constant.DataBase.path)
            do {
                dbQueue = try DatabaseQueue(path: path)
            } catch {
                print("Error \(error)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ナビゲーションバーを非表示
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 使用した単語リストのうち，お気に入り登録した単語をマイ単語リストへ移す処理
        guard let words = dataManager.words else { fatalError() }
        for word in words {
            if word.isLike {
                let newMyWord = MyWord()
                newMyWord.name = word.name
                newMyWord.mean = wordSource.featchMean(dbq: dbQueue, word: newMyWord.name)
                dataManager.save(model: newMyWord)
                dataManager.delete(word: word)
            } else {
                dataManager.delete(word: word)
            }
        }
    }

    // おまけをタップすると音が出る処理を実行
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        easyFigure.addTarget(self, action: #selector(tapButton(_:)), for: .touchDown)
        easyFigure.addTarget(self, action: #selector(tapButton2(_:)), for: .touchUpInside)
        normalFigure.addTarget(self, action: #selector(tapButton(_:)), for: .touchDown)
        normalFigure.addTarget(self, action: #selector(tapButton2(_:)), for: .touchUpInside)
        hardFigure.addTarget(self, action: #selector(tapButton(_:)), for: .touchDown)
        hardFigure.addTarget(self, action: #selector(tapButton2(_:)), for: .touchUpInside)
    }
    
    @objc func tapButton(_ sender: UIButton) {
        guard let accessID = sender.accessibilityIdentifier else { print("error"); return }
        sender.setImage(Constant.Images.figure[accessID]?[1], for: .normal)
        figurePlayer.playSound(name: accessID + "0")
    }
    
    @objc func tapButton2(_ sender: UIButton) {
        guard let accessID = sender.accessibilityIdentifier else { print("error"); return }
        sender.setImage(Constant.Images.figure[accessID]?[0], for: .normal)
        figurePlayer.playSound(name: accessID + "1")
    }

    // ゲームクリアのおまけの表示/非表示
    func figure() {
        let modeLock = defaults.integer(forKey: Constant.ModeLock)
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
    
    // サウンドボタンが押されたときのBGMの音量変更，画像変更
    @IBAction func soundPressed(_ sender: UIButton) {
        // ミュート変数の値を変更
        isMute = isMute ? false : true
        // ミュートかどうかで画像を変更
        isMute ? soundButton.setImage(Constant.Images.Sounds[1], for: .normal) : soundButton.setImage(Constant.Images.Sounds[0], for: .normal)
        
        guard let appDel = appDelegate else { return }
        appDel.opPlayer.muteSound(isMute: isMute)
        defaults.set(isMute, forKey: Constant.UserDefaultKeys.isMute)
    }

    // ボタンタップ時の効果音を設定
    @IBAction func otherButtonPressed(_ sender: UIButton) {
        pushPlayer.playSound(name: Constant.Sounds.push, isMute: isMute)
    }

    @IBAction func playButtonPressed(_ sender: UIButton) {
        pushPlayer.playSound(name: Constant.Sounds.push, isMute: isMute)
    }
}
