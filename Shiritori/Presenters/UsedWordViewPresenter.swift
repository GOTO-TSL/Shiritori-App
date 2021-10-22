//
//  UsedWordViewPresenter.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/21.
//

import Foundation

protocol UsedWordViewProtocol {
    func showWords(_ usedWordViewPresenter: UsedWordViewPresenter, _ words: [Word])
    func changeCellImage(_ usedWordViewPresenter: UsedWordViewPresenter)
}

protocol UsedWordViewPresenterProtocol {
    func usedWordViewDidLoad()
    func didPressedLikeButton(of word: Word)
}

final class UsedWordViewPresenter {
    
    private let view: UsedWordViewProtocol!
    var wordDataManager: WordDataManager!
    
    init(view: UsedWordViewProtocol) {
        self.view = view
        self.wordDataManager = WordDataManager()
        wordDataManager.delegate = self
        wordDataManager.openDB(name: Const.DBName.usedWords)
    }
    
    func usedWordViewDidLoad() {
        wordDataManager.getAllWords()
    }
    
    func didPressedLikeButton(of word: Word) {
        wordDataManager.changeLike(for: word)
    }
}
// MARK: - UsedWordManagerDelegate Methods
extension UsedWordViewPresenter: WordDataManagerDelegate {
    func didUpdateDB(_ wordDataManager: WordDataManager) {
        view.changeCellImage(self)
    }
    
    func didCheckIsUsed(_ wordDataManager: WordDataManager, word: String, count: Int) {
        // do nothing
    }
    
    func didGetUsedWords(_ wordDataManager: WordDataManager, words: [Word]) {
        // 使用した単語一覧を表示
        view.showWords(self, words)
    }
}
