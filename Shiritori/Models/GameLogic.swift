//
//  ShiritoriManager.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/25.
//

import Foundation
import UIKit

protocol GameLogicDelegate {
    func shiritoriSucessed()
    func shiritoriFailed(comment: String)
    func updateHitPoint(score: Int, scoreLimit: Int)
    func gotoResultView()
}


struct GameLogic {
    var delegate: GameLogicDelegate?
    let defaults = UserDefaults.standard
    
    //しりとりのルールに則っているか判定する
    func applyRule(for text: String) {
        guard let currentWord = defaults.string(forKey: "currentWord") else { return }
        let endCharacter = currentWord[currentWord.index(before: currentWord.endIndex)]
        if text != "" {
            let initialString = text[text.startIndex]
            
            if text.count == 1 {
                self.delegate?.shiritoriFailed(comment: "Enter at least 2 characters")
            } else {
                if endCharacter == initialString {
                    self.delegate?.shiritoriSucessed()
                } else {
                    self.delegate?.shiritoriFailed(comment: "Shiritori Please")
                }
            }
        } else {
            self.delegate?.shiritoriFailed(comment: "Write Something")
        }
    }
    
    func addGamePoint() {
        let currentScore = defaults.integer(forKey: "score")
        guard let mode = defaults.string(forKey: "playmode") else { return }
        
        let newScore = currentScore + 10
        defaults.set(newScore, forKey: "score")
        
        guard let scoreLimit = K.scoreLimit[mode] else { return }
        if newScore == scoreLimit {
            self.delegate?.updateHitPoint(score: newScore, scoreLimit: scoreLimit)
            self.delegate?.gotoResultView()
        } else {
            self.delegate?.updateHitPoint(score: newScore, scoreLimit: scoreLimit)
        }
        
    }
    
    func subGamePoint() {
        
        var currentScore = defaults.integer(forKey: "score")
        guard let mode = defaults.string(forKey: "playmode") else { return }
        guard let scoreLimit = K.scoreLimit[mode] else { return }
        
        if currentScore <= 0 {
            currentScore = 0
            defaults.set(currentScore, forKey: "score")
            self.delegate?.updateHitPoint(score: currentScore, scoreLimit: scoreLimit)
        } else {
            let newScore = currentScore - 10
            defaults.set(newScore, forKey: "score")
            self.delegate?.updateHitPoint(score: newScore, scoreLimit: scoreLimit)
        }
    }
        
}
