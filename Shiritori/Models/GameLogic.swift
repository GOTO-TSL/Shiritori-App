//
//  ShiritoriManager.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/25.
//

import Foundation

protocol GameLogicDelegate: AnyObject {
    func shiritoriSucessed(_ gameLogic: GameLogic)
    func shiritoriFailed(_ gameLogic: GameLogic, comment: String)
    func updateHitPoint(_ gameLogic: GameLogic, score: Int, scoreLimit: Int)
    func updateDamage(_ gameLogic: GameLogic, damage: Int)
    func gotoResultView(_ gameLogic: GameLogic)
}

struct GameLogic {
    var dataManager = DataManager()
    weak var delegate: GameLogicDelegate?
    let defaults = UserDefaults.standard
    
    // しりとりのルールに則っているか判定する
    func applyRule(for text: String) {
        guard let currentWord = defaults.string(forKey: Constant.UserDefaultKeys.currentWord) else { return }
        let endCharacter = currentWord[currentWord.index(before: currentWord.endIndex)]
        if text != "" {
            let initialString = text[text.startIndex]
            
            if text.count == 1 {
                delegate?.shiritoriFailed(self, comment: Constant.Comments.single)
            } else {
                if endCharacter == initialString {
                    if dataManager.isUsed(word: text) {
                        delegate?.shiritoriFailed(self, comment: Constant.Comments.used)
                    } else {
                        delegate?.shiritoriSucessed(self)
                    }
                } else {
                    delegate?.shiritoriFailed(self, comment: Constant.Comments.noShiritori)
                }
            }
        } else {
            delegate?.shiritoriFailed(self, comment: Constant.Comments.empty)
        }
    }
    
    func addGamePoint(userWord: String) {
        let currentScore = defaults.integer(forKey: Constant.UserDefaultKeys.score)
        guard let mode = defaults.string(forKey: Constant.UserDefaultKeys.mode) else { return }
        
        let damage = userWord.count * 10
        let newScore = currentScore + damage
        defaults.set(newScore, forKey: Constant.UserDefaultKeys.score)
        
        guard let scoreLimit = Constant.scoreLimit[mode] else { return }
        if newScore >= scoreLimit {
            delegate?.updateHitPoint(self, score: newScore, scoreLimit: scoreLimit)
            delegate?.updateDamage(self, damage: damage)
            delegate?.gotoResultView(self)
        } else {
            delegate?.updateHitPoint(self, score: newScore, scoreLimit: scoreLimit)
            delegate?.updateDamage(self, damage: damage)
        }
    }
    
    func subGamePoint() {
        var currentScore = defaults.integer(forKey: Constant.UserDefaultKeys.score)
        guard let mode = defaults.string(forKey: Constant.UserDefaultKeys.mode) else { return }
        guard let scoreLimit = Constant.scoreLimit[mode] else { return }
        
        if currentScore <= 0 {
            currentScore = 0
            defaults.set(currentScore, forKey: Constant.UserDefaultKeys.score)
            delegate?.updateHitPoint(self, score: currentScore, scoreLimit: scoreLimit)
        } else {
            let newScore = currentScore - 10
            defaults.set(newScore, forKey: Constant.UserDefaultKeys.score)
            delegate?.updateHitPoint(self, score: newScore, scoreLimit: scoreLimit)
        }
    }
}
