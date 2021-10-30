//
//  UsedWordViewPresenter.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/21.
//

import Foundation

protocol UsedWordViewProtocol: AnyObject {
    func showWords(_ usedWordViewPresenter: UsedWordViewPresenter, _ words: [Word])
}

protocol UsedWordViewPresenterProtocol: AnyObject {
    func usedWordViewDidLoad()
    func didPressedLikeButton(of word: Word)
}

final class UsedWordViewPresenter {
    
    private weak var view: UsedWordViewProtocol!
    var wordDataManager: WordDataManager!
    
    init(view: UsedWordViewProtocol) {
        self.view = view
        self.wordDataManager = WordDataManager()
        wordDataManager.delegate = self
        wordDataManager.openDB(name: Const.DBName.usedWords)
    }
    
    func usedWordViewDidLoad() {
        view.showWords(self, wordDataManager.currentWords)
    }
    
    func didPressedLikeButton(of word: Word) {
        wordDataManager.changeLike(for: word)
    }
}
// MARK: - UsedWordManagerDelegate Methods
extension UsedWordViewPresenter: WordDataManagerDelegate {
    func didUpdateDB(_ wordDataManager: WordDataManager) {
        view.showWords(self, wordDataManager.currentWords)
    }
    
    func didCheckIsUsed(_ wordDataManager: WordDataManager, word: String, count: Int) {
        // do nothing
    }
}
