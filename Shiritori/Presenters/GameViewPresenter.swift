//
//  GameViewPresenter.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/19.
//

import Foundation

enum TextState {
    case normal
    case error
    case start
    case end
}

protocol GameViewProtocol {
    func showText(_ gameViewPresenter: GameViewPresenter, text: String, state: TextState)
    func showTimeLimit(_ gameViewPresenter: GameViewPresenter, text: String)
    func updateHPBar(_ gameViewPresenter: GameViewPresenter, progress: Float)
}

protocol GameViewPresenterProtocol {
    func gameViewDidLoad()
    func willGameStart()
    func didInputWord(word: String)
}

final class GameViewPresenter {
    
    private let view: GameViewProtocol!
    var timeManager: TimeManager!
    var dictDataModel: DictDataManager!
    var gameLogic: GameLogic!
    var enemyModel: EnemyModel!
    
    init(view: GameViewProtocol, mode: Mode) {
        self.view = view
        self.timeManager = TimeManager()
        self.dictDataModel = DictDataManager()
        self.gameLogic = GameLogic()
        self.enemyModel = EnemyModel(mode: mode)
        
        timeManager.delegate = self
        dictDataModel.delegate = self
        gameLogic.delegate = self
        enemyModel.delegete = self
    }
    
    func gameViewDidLoad() {
        // カウントダウンスタート
        timeManager.firstCount()
        // 英単語DBを読み込む
        dictDataModel.openDB()
    }
    
    func willGameStart() {
        // ゲームの制限時間カウントスタート
        timeManager.gameCount()
        // 最初の単語取得を依頼
        dictDataModel.featchWord(initial: Const.alphabet.randomElement()!)
    }
    
    func didInputWord(word: String) {
        // しりとりのルールを適用する処理を依頼
        gameLogic.applyShiritoriRule(for: word)
    }
}
// MARK: - TimeManagerDelegate Methods
extension GameViewPresenter: TimeManagerDelegate {
    // 最初のカウントダウン時に毎秒呼ばれる
    func didFirstCount(_ timeManager: TimeManager, count: Int) {
        switch count {
        case 0...2:
            view.showText(self, text: "\(3 - count)", state: .normal)
        case 3:
            view.showText(self, text: Const.GameText.start, state: .start)
        default: break
        }
    }
    // ゲーム中のカウント時に毎秒呼ばれる
    func didGameCount(_ timeManager: TimeManager, count: Int) {
        switch count {
        case 0...60:
            view.showTimeLimit(self, text: "\(60 - count)")
        case 61:
            view.showText(self, text: Const.GameText.end, state: .end)
        default: break
        }
    }
}

// MARK: - DictDataModelDelegate Methods
extension GameViewPresenter: DictDataManagerDelegate {
    func didCheckWord(_ dictDataManager: DictDataManager, word: String, count: Int) {
        // 辞書を検索して0件だったらエラー表示を依頼，そうでなければ単語取得を依頼
        if count != 0 {
            let initial = word[word.index(before: word.endIndex)]
            dictDataManager.featchWord(initial: initial)
            enemyModel.getDamage(word: word)
        } else {
            view.showText(self, text: Const.GameText.notInDict, state: .error)
            enemyModel.heal()
        }
    }
    
    func didFeatchWord(_ dictDataModel: DictDataManager, word: String) {
        // 現在の敵の単語をUserDefaultに保存
        UserDefaults.standard.set(word, forKey: Const.UDKeys.currentWord)
        // 表示を依頼
        view.showText(self, text: word, state: .normal)
    }
}

// MARK: - GameLogicDelegate Methods
extension GameViewPresenter: GameLogicDelegate {
    // しりとり成立
    func shiritoriSucceeded(_ gameLogic: GameLogic, safeWord: String) {
        // 辞書にある単語かどうかを調べる処理を依頼
        dictDataModel.checkWord(inputs: safeWord)
    }
    // しりとり不成立
    func shiritoriFailed(_ gameLogic: GameLogic, message: String) {
        // エラー表示を依頼
        view.showText(self, text: message, state: .error)
        enemyModel.heal()
    }
    
}
// MARK: - EnemyModelDelegate Methods
extension GameViewPresenter: EnemyModelDelegate {
    // 敵のHPに変化があったときの処理
    func didChangeHP(_ enemyModel: EnemyModel, currentHP: Int, maxHP: Int) {
        let progress = Float(currentHP) / Float(maxHP)
        // HPが0かどうかで処理を分ける
        if currentHP > 0 {
            view.updateHPBar(self, progress: progress)
        } else {
            view.updateHPBar(self, progress: progress)
            view.showText(self, text: Const.GameText.dead, state: .end)
            timeManager.stopTimer()
        }
    }
}
