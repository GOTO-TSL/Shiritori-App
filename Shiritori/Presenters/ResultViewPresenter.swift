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
    func didPressedHome()
}

final class ResultViewPresenter {
    private let view: ResultViewProtocol
    var wordDataManager: WordDataManager!
    
    init(view: ResultViewProtocol) {
        self.view = view
        self.wordDataManager = WordDataManager()
        wordDataManager.delegate = self
        wordDataManager.createDB(name: Const.DBName.myWords)
        wordDataManager.openDB(name: Const.DBName.usedWords)
    }
    
    func didPressedHome() {
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
