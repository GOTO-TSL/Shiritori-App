//
//  UsedWordViewPresenter.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/21.
//

import Foundation

protocol UsedWordViewProtocol {
    func showWords(_ usedWordViewPresenter: UsedWordViewPresenter, _ words: [UsedWord])
}

protocol UsedWordViewPresenterProtocol {
    func usedWordViewDidLoad()
}

final class UsedWordViewPresenter {
    
    private let view: UsedWordViewProtocol!
    var usedWordManager: UsedWordManager!
    
    init(view: UsedWordViewProtocol) {
        self.view = view
        self.usedWordManager = UsedWordManager()
        usedWordManager.delegate = self
        usedWordManager.openDB()
    }
    
    func usedWordViewDidLoad() {
        usedWordManager.getAllWords()
    }
}
// MARK: - UsedWordManagerDelegate Methods
extension UsedWordViewPresenter: UsedWordManagerDelegate {
    func didCheckIsUsed(_ usedWordManager: UsedWordManager, word: String, count: Int) {
        // do nothing
    }
    
    func didGetUsedWords(_ usedWordManager: UsedWordManager, words: [UsedWord]) {
        // 使用した単語一覧を表示
        view.showWords(self, words)
    }
}
