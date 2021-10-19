//
//  GameViewPresenter.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/19.
//

import Foundation

protocol GameViewProtocol {
    func showCount(_ gameViewPresenter: GameViewPresenter, text: String)
    func showStart(_ gameViewPresenter: GameViewPresenter, text: String)
    func showTimeLimit(_ gameViewPresenter: GameViewPresenter, text: String)
    func goToNextView(_ gameViewPresenter: GameViewPresenter, text: String)
}

protocol GameViewPresenterProtocol {
    func gameViewDidLoad()
    func willGameStart()
}

class GameViewPresenter {
    
    private let view: GameViewProtocol!
    var timeManager: TimeManager!
    
    init(view: GameViewProtocol) {
        self.view = view
        self.timeManager = TimeManager()
        timeManager.delegate = self
    }
    
    func gameViewDidLoad() {
        timeManager.firstCount()
    }
    
    func willGameStart() {
        timeManager.gameCount()
    }
}

extension GameViewPresenter: TimeManagerDelegate {
    // 最初のカウントダウン時に毎秒呼ばれる
    func didFirstCount(_ timeManager: TimeManager, count: Int) {
        switch count {
        case 0...2:
            view.showCount(self, text: "\(3 - count)")
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
