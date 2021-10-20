//
//  GameLogic.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/20.
//

import Foundation

protocol GameLogicDelegate: AnyObject {
    func shiritoriSucceeded(_ gameLogic: GameLogic, safeWord: String)
    func shiritoriFailed(_ gameLogic: GameLogic, message: String)
}

final class GameLogic {
    
    weak var delegate: GameLogicDelegate?
    
    func applyShiritoriRule(for word: String) {
        
        guard let currentWord = UserDefaults.standard.string(forKey: Const.UDKeys.currentWord) else { fatalError() }
        
        let endChar = currentWord[currentWord.index(before: currentWord.endIndex)]
        if word.count >= 2 {
            if word[word.startIndex] == endChar {
                // TODO: 使った単語かどうか判定
                self.delegate?.shiritoriSucceeded(self, safeWord: word)
            } else {
                self.delegate?.shiritoriFailed(self, message: Const.GameText.shiritori)
            }
        } else {
            self.delegate?.shiritoriFailed(self, message: Const.GameText.blank)
        }
        
    }
}
