//
//  UsedWordViewPresenter.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/21.
//

import Foundation

protocol UsedWordViewProtocol: AnyObject {
    func didFeatchWord(_ usedWordViewPresenter: UsedWordViewPresenter)
}

protocol UsedWordViewPresenterProtocol: AnyObject {
    var numberOfWords: Int { get }
    func usedWord(forRow row: Int) -> Word?
    func usedWordViewDidLoad()
    func didPressedLikeButton(of word: Word)
}

final class UsedWordViewPresenter {
    // MARK: - Properties
    private weak var view: UsedWordViewProtocol!
    private var wordDataManager: WordDataManager!
    private(set) var usedWords = [Word]()
    
    // MARK: - Lifecycle
    init(view: UsedWordViewProtocol) {
        self.view = view
        self.wordDataManager = WordDataManager()
        wordDataManager.delegate = self
        wordDataManager.openDB(name: Const.DBName.usedWords)
    }
    // MARK: - UsedWordViewPresenterProtocol Methods
    var numberOfWords: Int {
        return usedWords.count
    }
    
    func usedWord(forRow row: Int) -> Word? {
        if row >= usedWords.count {
            return nil
        } else {
            return usedWords[row]
        }
    }
    
    func usedWordViewDidLoad() {
        wordDataManager.loadWords()
    }
    
    func didPressedLikeButton(of word: Word) {
        wordDataManager.changeLike(for: word)
    }
}
// MARK: - WordDataManagerDelegate Methods
extension UsedWordViewPresenter: WordDataManagerDelegate {
    func didCopyWord(_ wordDataManager: WordDataManager) {
        // do nothing
    }
    
    func didCheckIsUsed(_ wordDataManager: WordDataManager, word: String, count: Int) {
        // do nothing
    }
    
    func didLoadWord(_ wordDataManager: WordDataManager, words: [Word]) {
        usedWords = words
        view.didFeatchWord(self)
    }
    
}
