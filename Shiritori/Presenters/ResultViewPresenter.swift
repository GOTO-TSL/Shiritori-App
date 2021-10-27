//
//  ResultViewPresenter.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/22.
//

import Foundation

protocol ResultViewProtocol {
    func goToNextView(_ resultViewPresenter: ResultViewPresenter)
}

protocol ResultViewPresenterProtocol {
    func resultViewDidLoad(isWin: Bool, mode: Mode)
    func didPressedHome()
}

final class ResultViewPresenter {
    private let view: ResultViewProtocol
    var wordDataManager: WordDataManager!
    var winSound: SoundPlayer!
    var loseSound: SoundPlayer!
    var pushSound: SoundPlayer!
    
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
    
    func resultViewDidLoad(isWin: Bool) {
        if isWin {
            winSound.playSound()
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
        wordDataManager.openDB(name: Const.DBName.myWords, isLoad: false)
        wordDataManager.copyWord()
    }
}
// MARK: - UsedWordManagerDelegate Methods
extension ResultViewPresenter: WordDataManagerDelegate {
    func didCheckIsUsed(_ wordDataManager: WordDataManager, word: String, count: Int) {
        // do nothing
    }
    
    func didUpdateDB(_ wordDataManager: WordDataManager) {
        view.goToNextView(self)
    }
}
