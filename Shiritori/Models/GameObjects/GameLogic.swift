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
    func updateHitPoint(_ gameLogic: GameLogic, hitpoint: Int, scoreLimit: Int)
    func updateDamage(_ gameLogic: GameLogic, damage: Int)
    func gotoResultView(_ gameLogic: GameLogic)
}

final class GameLogic {
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

    func addGamePoint(enemy: Enemy, userWord: String) {
        let damage = userWord.count * 10
        enemy.damage = damage
        let hitpoint = enemy.hitpoint
        let limit = enemy.limit
        
        if hitpoint <= 0 {
            delegate?.updateHitPoint(self, hitpoint: hitpoint, scoreLimit: limit)
            delegate?.updateDamage(self, damage: damage)
            delegate?.gotoResultView(self)
        } else {
            delegate?.updateHitPoint(self, hitpoint: hitpoint, scoreLimit: limit)
            delegate?.updateDamage(self, damage: damage)
        }
    }
    
    func subGamePoint(enemy: Enemy) {
        let hitpoint = enemy.hitpoint
        let limit = enemy.limit
        enemy.heal = 10
        
        if hitpoint >= limit {
            enemy.hitpoint = limit
            delegate?.updateHitPoint(self, hitpoint: hitpoint, scoreLimit: limit)
        } else {
            delegate?.updateHitPoint(self, hitpoint: hitpoint, scoreLimit: limit)
        }
    }
}
