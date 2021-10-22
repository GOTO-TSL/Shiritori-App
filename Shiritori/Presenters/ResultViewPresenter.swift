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
    var usedWordManager: UsedWordManager!
    
    init(view: ResultViewProtocol) {
        self.view = view
        self.usedWordManager = UsedWordManager()
        
        usedWordManager.delegate = self
        usedWordManager.openDB()
    }
    
    func didPressedHome() {
        usedWordManager.delete()
    }
}
// MARK: - UsedWordManagerDelegate Methods
extension ResultViewPresenter: UsedWordManagerDelegate {
    func didCheckIsUsed(_ usedWordManager: UsedWordManager, word: String, count: Int) {
        // do nothing
    }
    
    func didGetUsedWords(_ usedWordManager: UsedWordManager, words: [UsedWord]) {
        // do nothing
    }
    
    func didUpdateDB(_ usedWordManager: UsedWordManager) {
        view.goToNextView(self)
    }
}
