//
//  MyWordViewPresenter.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/22.
//

import Foundation

protocol MyWordViewProtocol: AnyObject {
    func showWords(_ myWordViewPresenter: MyWordViewPresenter, words: [Word])
}

protocol MyWordViewPresenterProtocol: AnyObject {
    func myWordViewDidLoad()
    func deleted(word: Word)
}

final class MyWordViewPresenter {
    private weak var view: MyWordViewProtocol!
    private var wordDataManager: WordDataManager!
    
    init(view: MyWordViewProtocol) {
        self.view = view
        self.wordDataManager = WordDataManager()
        wordDataManager.openDB(name: Const.DBName.myWords)
    }
    
    func myWordViewDidLoad() {
        view.showWords(self, words: wordDataManager.currentWords)
    }
    
    func deleted(word: Word) {
        wordDataManager.delete(option: .selected, selectedWord: word.word)
    }
    
}
