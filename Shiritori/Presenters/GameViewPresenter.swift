//
//  GameViewPresenter.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/19.
//

import Foundation

protocol GameViewProtocol {
    func showText(_ gameViewPresenter: GameViewPresenter, text: String)
    func showStart(_ gameViewPresenter: GameViewPresenter, text: String)
    func showTimeLimit(_ gameViewPresenter: GameViewPresenter, text: String)
    func goToNextView(_ gameViewPresenter: GameViewPresenter, text: String)
}

protocol GameViewPresenterProtocol {
    func gameViewDidLoad()
    func willGameStart()
    func didInputWord(word: String)
}

class GameViewPresenter {
    
    private let view: GameViewProtocol!
    var timeManager: TimeManager!
    var dictDataModel: DictDataModel!
    
    init(view: GameViewProtocol) {
        self.view = view
        self.timeManager = TimeManager()
        self.dictDataModel = DictDataModel()
        timeManager.delegate = self
        dictDataModel.delegate = self
    }
    
    func gameViewDidLoad() {
        timeManager.firstCount()
        dictDataModel.openDB()
    }
    
    func willGameStart() {
        timeManager.gameCount()
        dictDataModel.featchWord(initial: Const.alphabet.randomElement()!)
    }
    
    func didInputWord(word: String) {
        let initial = word[word.index(before: word.endIndex)]
        dictDataModel.featchWord(initial: initial)
    }
}
// MARK: - TimeManagerDelegate Methods
extension GameViewPresenter: TimeManagerDelegate {
    // 最初のカウントダウン時に毎秒呼ばれる
    func didFirstCount(_ timeManager: TimeManager, count: Int) {
        switch count {
        case 0...2:
            view.showText(self, text: "\(3 - count)")
        case 3:
            view.showStart(self, text: Const.GameText.start)
        default: break
        }
    }
    // ゲーム中のカウント時に毎秒呼ばれる
    func didGameCount(_ timeManager: TimeManager, count: Int) {
        switch count {
        case 0...60:
            view.showTimeLimit(self, text: "\(60 - count)")
        case 61:
            view.goToNextView(self, text: Const.GameText.end)
        default: break
        }
    }
}

// MARK: - DictDataModelDelegate Methods
extension GameViewPresenter: DictDataModelDelegate {
    func didFeatchWord(_ dictDataModel: DictDataModel, word: String) {
        view.showText(self, text: word)
    }
}
