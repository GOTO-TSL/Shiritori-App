//
//  ShiritoriManager.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/25.
//

import Foundation

protocol PreGameLogicDelegate: AnyObject {
    func shiritoriSucessed(_ gameLogic: PreGameLogic)
    func shiritoriFailed(_ gameLogic: PreGameLogic, comment: String)
    func updateHitPoint(_ gameLogic: PreGameLogic, hitpoint: Int, scoreLimit: Int)
    func updateDamage(_ gameLogic: PreGameLogic, damage: Int)
    func gotoResultView(_ gameLogic: PreGameLogic)
}

/// しりとりのゲームロジックを担当するモデル
final class PreGameLogic {
    var dataManager = DataManager()
    weak var delegate: PreGameLogicDelegate?
    let defaults = UserDefaults.standard
    
    /// しりとりのルールに則っているか判定し，結果に応じて処理を分ける
    /// - Parameter text: 入力されたテキスト
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
    
    /// 敵にダメージを与える
    /// - Parameters:
    ///   - enemy: Enemy Model
    ///   - userWord: 入力された単語
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
    
    /// 敵が回復する
    /// - Parameter enemy: Enemy Model
    func subGamePoint(enemy: Enemy) {
        let hitpoint = enemy.hitpoint
        let limit = enemy.limit
        enemy.heal = 30
        
        if hitpoint >= limit {
            enemy.hitpoint = limit
            delegate?.updateHitPoint(self, hitpoint: hitpoint, scoreLimit: limit)
        } else {
            delegate?.updateHitPoint(self, hitpoint: hitpoint, scoreLimit: limit)
        }
    }
}
