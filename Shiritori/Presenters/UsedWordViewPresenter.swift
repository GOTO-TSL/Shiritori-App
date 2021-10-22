//
//  UsedWordViewPresenter.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/21.
//

import Foundation

protocol UsedWordViewProtocol {
    func showWords(_ usedWordViewPresenter: UsedWordViewPresenter, _ words: [UsedWord])
    func changeCellImage(_ usedWordViewPresenter: UsedWordViewPresenter)
}

protocol UsedWordViewPresenterProtocol {
    func usedWordViewDidLoad()
    func didPressedLikeButton(of word: UsedWord)
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
    
    func didPressedLikeButton(of word: UsedWord) {
        usedWordManager.changeLike(for: word)
    }
}
// MARK: - UsedWordManagerDelegate Methods
extension UsedWordViewPresenter: UsedWordManagerDelegate {
    func didUpdateDB(_ usedWordManager: UsedWordManager) {
        view.changeCellImage(self)
    }
    
    func didCheckIsUsed(_ usedWordManager: UsedWordManager, word: String, count: Int) {
        // do nothing
    }
    
    func didGetUsedWords(_ usedWordManager: UsedWordManager, words: [UsedWord]) {
        // 使用した単語一覧を表示
        view.showWords(self, words)
    }
}
