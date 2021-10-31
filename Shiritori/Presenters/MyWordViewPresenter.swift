//
//  MyWordViewPresenter.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/22.
//

import Foundation

protocol MyWordViewProtocol: AnyObject {
    func didUpdateWord(_ myWordViewPresenter: MyWordViewPresenter)
}

protocol MyWordViewPresenterProtocol: AnyObject {
    var numberOfWords: Int { get }
    func myWord(forRow row: Int) -> Word?
    func myWordViewDidLoad()
    func deleted(wordID: Int)
}

final class MyWordViewPresenter {
    private weak var view: MyWordViewProtocol!
    private var wordDataManager: WordDataManager!
    private(set) var myWords = [Word]()
    
    init(view: MyWordViewProtocol) {
        self.view = view
        self.wordDataManager = WordDataManager()
        wordDataManager.delegate = self
        wordDataManager.openDB(name: Const.DBName.myWords)
    }
    
    var numberOfWords: Int {
        return myWords.count
    }
    
    func myWord(forRow row: Int) -> Word? {
        if row >= myWords.count {
            return nil
        } else {
            return myWords[row]
        }
    }
    
    func myWordViewDidLoad() {
        wordDataManager.loadWords()
    }
    
    func deleted(wordID: Int) {
        wordDataManager.delete(option: .selected, selectedID: wordID)
    }
    
}
// MARK: - WordDataManagerDelegate Methods
extension MyWordViewPresenter: WordDataManagerDelegate {
    func didCopyWord(_ wordDataManager: WordDataManager) {
        // do nothing
    }
    
    func didCheckIsUsed(_ wordDataManager: WordDataManager, word: String, count: Int) {
        // do nothing
    }
    
    func didLoadWord(_ wordDataManager: WordDataManager, words: [Word]) {
        myWords = words
        view.didUpdateWord(self)
    }
    
}
