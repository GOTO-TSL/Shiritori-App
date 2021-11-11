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
    func resultViewDidLoad(isWin: Bool, mode: Mode)
    func didPressedHome()
}

final class ResultViewPresenter {
    private weak var view: ResultViewProtocol!
    private var wordDataManager: WordDataManager!
    private var winSound: SoundPlayer!
    private var loseSound: SoundPlayer!
    private var pushSound: SoundPlayer!
    private(set) var usedWords = [Word]()
    
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
    
    func resultViewDidLoad(isWin: Bool, mode: Mode) {
        // UserDefaultに勝利判定と現在のモードを設定
        let defaults = UserDefaults.standard
        defaults.set(isWin, forKey: Const.UDKeys.isWin)
        defaults.setEnum(mode, forKey: Const.UDKeys.currentMode)
        // 結果に応じてサウンドを再生し，勝利の場合，勝数をカウント(319勝まで)
        if isWin {
            winSound.playSound()
            let winCount = defaults.integer(forKey: Const.UDKeys.winCount)
            if winCount < 320 {
                defaults.set(winCount+1, forKey: Const.UDKeys.winCount)
            } else {
                defaults.set(winCount, forKey: Const.UDKeys.winCount)
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
