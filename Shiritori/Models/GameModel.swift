//
//  GameLogic.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/20.
//

import Foundation

protocol GameLogicDelegate: AnyObject {
    func shiritoriSucceeded(_ gameLogic: GameModel, safeWord: String)
    func shiritoriFailed(_ gameLogic: GameModel, message: String)
}

final class GameModel {
    // MARK: - Properties
    weak var delegate: GameLogicDelegate?
    
    // MARK: - GameModel Methods
    func applyShiritoriRule(for word: String) {
        
        guard let currentWord = UserDefaults.standard.string(forKey: Const.UDKeys.currentWord) else { fatalError() }
        
        let endChar = currentWord[currentWord.index(before: currentWord.endIndex)]
        if word.count >= 2 {
            if word[word.startIndex] == endChar {
                self.delegate?.shiritoriSucceeded(self, safeWord: word)
            } else {
                self.delegate?.shiritoriFailed(self, message: Const.GameText.shiritori)
            }
        } else {
            self.delegate?.shiritoriFailed(self, message: Const.GameText.blank)
        }
    }
}
