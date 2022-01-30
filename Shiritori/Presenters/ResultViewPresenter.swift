//
//  ResultViewPresenter.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/22.
//

import Foundation

protocol ResultViewProtocol: AnyObject {
    func goHomeView(_ resultViewPresenter: ResultViewPresenter)
}

protocol ResultViewPresenterProtocol: AnyObject {
    func resultViewDidLoad()
    func didPressedHome()
}

final class ResultViewPresenter {
    // MARK: - Properties
    private weak var view: ResultViewProtocol!
    private var wordDataManager: WordDataManager!
    private var winSound: SoundPlayer!
    private var loseSound: SoundPlayer!
    private var pushSound: SoundPlayer!
    private(set) var usedWords = [Word]()
    
    // MARK: - Lifecycle
    init(view: ResultViewProtocol) {
        self.view = view
        self.wordDataManager = WordDataManager()
        self.winSound = SoundPlayer(name: Const.Sound.win)
        self.loseSound = SoundPlayer(name: Const.Sound.lose)
        self.pushSound = SoundPlayer(name: Const.Sound.push)
        
        wordDataManager.delegate = self
        
        wordDataManager.createDB(name: Const.DBName.myWords)
        wordDataManager.openDB(name: Const.DBName.usedWords)
    }
    
    // MARK: - ResultViewPresenterProtocol Methods
    func resultViewDidLoad() {
        // UserDefaultに勝利判定と現在のモードを設定
        let defaults = UserDefaults.standard
        let isWin = defaults.bool(forKey: Const.UDKeys.isWin)
        let mode: Mode = defaults.getEnum(forKey: Const.UDKeys.currentMode)!
        // 結果に応じてサウンドを再生し，勝利の場合，勝数をカウント(319勝まで)
        if isWin {
            winSound.playSound()
            let winCount = defaults.integer(forKey: Const.UDKeys.winCount)
            var newWinCount = winCount
            // 難易度に応じてリワードの数を変更
            switch mode {
            case .easy:
                newWinCount += 1
            case .normal:
                newWinCount += 3
            case .hard:
                newWinCount += 6
            case .challenge:
                // TODO: challengeモードのところあとで考える
                newWinCount += 0
            }
            // UserDefaultsの更新
            if newWinCount < 320 {
                defaults.set(newWinCount, forKey: Const.UDKeys.winCount)
            } else {
                defaults.set(320, forKey: Const.UDKeys.winCount)
            }
        } else {
            loseSound.playSound()
        }
    }
    
    func didPressedWord() {
        pushSound.playSound()
    }
    
    func didPressedHome() {
        pushSound.playSound()
        wordDataManager.delete(option: .isntLike)
        wordDataManager.copyWord(currentWords: usedWords, to: Const.DBName.myWords)
    }
}
// MARK: - WordDataManagerDelegate Methods
extension ResultViewPresenter: WordDataManagerDelegate {
    func didCopyWord(_ wordDataManager: WordDataManager) {
        view.goHomeView(self)
    }
    
    func didCheckIsUsed(_ wordDataManager: WordDataManager, word: String, count: Int) {
        // do nothing
    }
    
    func didLoadWord(_ wordDataManager: WordDataManager, words: [Word]) {
        usedWords = words
    }
    
}
