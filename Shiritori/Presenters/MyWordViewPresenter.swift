//
//  MyWordViewPresenter.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/22.
//

import Foundation

protocol MyWordViewProtocol {
    func showWords(_ myWordViewPresenter: MyWordViewPresenter, words: [Word])
}

protocol MyWordViewPresenterProtocol {
    func myWordViewDidLoad()
}

final class MyWordViewPresenter {
    private let view: MyWordViewProtocol
    private var wordDataManager: WordDataManager!
    
    init(view: MyWordViewProtocol) {
        self.view = view
        self.wordDataManager = WordDataManager()
        wordDataManager.openDB(name: Const.DBName.myWords)
    }
    
    func myWordViewDidLoad() {
        view.showWords(self, words: wordDataManager.currentWords)
    }
    
}
