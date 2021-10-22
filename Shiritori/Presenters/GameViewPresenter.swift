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
    var dictDataManager: DictDataManager!
    var gameLogic: GameLogic!
    var enemyModel: EnemyModel!
    var wordDataManager: WordDataManager!
    
    init(view: GameViewProtocol, mode: Mode) {
        self.view = view
        self.timeManager = TimeManager()
        self.dictDataManager = DictDataManager()
        self.gameLogic = GameLogic()
        self.enemyModel = EnemyModel(mode: mode)
        self.wordDataManager = WordDataManager()
        
        timeManager.delegate = self
        dictDataManager.delegate = self
        gameLogic.delegate = self
        enemyModel.delegete = self
        wordDataManager.delegate = self
    }
    
    func gameViewDidLoad() {
        // カウントダウンスタート
        timeManager.firstCount()
        // 英単語DBを読み込む
        dictDataManager.openDB()
        // 使用した単語を保存するDBを作成
        wordDataManager.createDB(name: Const.DBName.usedWords)
    }
    
    func willGameStart() {
        // ゲームの制限時間カウントスタート
        timeManager.gameCount()
        // 最初の単語取得を依頼
        dictDataManager.featchWord(initial: Const.alphabet.randomElement()!)
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
        case 0...Const.GameParam.timeLimit:
            let text = "TIME:\(Const.GameParam.timeLimit - count)"
            view.showTimeLimit(self, text: text)
        case Const.GameParam.timeLimit+1:
            view.showText(self, text: Const.GameText.end, state: .end)
        default: break
        }
    }
}

// MARK: - DictDataModelDelegate Methods
extension GameViewPresenter: DictDataManagerDelegate {
    func didFeatchMean(_ dictDataManager: DictDataManager, word: String, mean: String) {
        // 単語を保存
        var usedWord = Word()
        usedWord.word = word
        usedWord.mean = mean
        wordDataManager.insert(usedWord)
    }
    
    func didCheckIsInDict(_ dictDataManager: DictDataManager, word: String, count: Int) {
        // 辞書を検索して0件 -> エラー表示を依頼
        // 1件以上ヒット -> 使用した単語かどうかをチェック
        if count != 0 {
            wordDataManager.checkIsUsed(word)
        } else {
            view.showText(self, text: Const.GameText.notInDict, state: .error)
            enemyModel.heal()
        }
    }
    
    func didFeatchWord(_ dictDataModel: DictDataManager, word: String, mean: String) {
        // 現在の敵の単語をUserDefaultに保存
        UserDefaults.standard.set(word, forKey: Const.UDKeys.currentWord)
        // 使用した単語DBに保存
        var usedWord = Word()
        usedWord.word = word
        usedWord.mean = mean
        wordDataManager.insert(usedWord)
        // 表示を依頼
        var trimedWord = word.lowercased()
        trimedWord = word.remove(characterSet: .decimalDigits)
        view.showText(self, text: trimedWord, state: .normal)
    }
}

// MARK: - GameLogicDelegate Methods
extension GameViewPresenter: GameLogicDelegate {
    // しりとり成立
    func shiritoriSucceeded(_ gameLogic: GameLogic, safeWord: String) {
        // 辞書にある単語かどうかを調べる処理を依頼
        dictDataManager.checkIsInDict(inputs: safeWord)
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
// MARK: - UsedWordManagerDelegate Methods
extension GameViewPresenter: WordDataManagerDelegate {
    func didUpdateDB(_ wordDataManager: WordDataManager) {
        // do nothing
    }
    
    func didCheckIsUsed(_ wordDataManager: WordDataManager, word: String, count: Int) {
        // 使用済み単語一覧での検索結果
        // 0件　-> 意味を取得，次の単語を取得，敵にダメージ
        // 1件以上 -> エラー分表示，敵を回復
        if count <= 0 {
            dictDataManager.featchMean(of: word)
            let initial = word[word.index(before: word.endIndex)]
            dictDataManager.featchWord(initial: initial)
            enemyModel.getDamage(word: word)
        } else {
            view.showText(self, text: Const.GameText.used, state: .error)
            enemyModel.heal()
        }
    }
}
