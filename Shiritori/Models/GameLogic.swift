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
    func shiritoriFailed()
}


struct GameLogic {
    var gamescore: Int = -10
    var delegate: GameLogicDelegate?
    
    func applyRule(textField: UITextField?, endCharacter: Character) {
        if let safetf = textField {
            if safetf.text != "" {
                let initialString = safetf.text?[safetf.text!.startIndex]
                
                if safetf.text?.count == 1 {
                    safetf.text = ""
                    safetf.placeholder = "Enter at least 2 characters"
                    self.delegate?.shiritoriFailed()
                } else {
                    if endCharacter == initialString {
                        safetf.placeholder = ""
                        self.delegate?.shiritoriSucessed()
                    } else {
                        safetf.text = ""
                        safetf.placeholder = "Shiritori Please!"
                        self.delegate?.shiritoriFailed()
                    }
                }
            } else {
                textField?.placeholder = "Wirte Something!"
                self.delegate?.shiritoriFailed()
            }
        } else {
            self.delegate?.shiritoriFailed()
        }
    }
    
    mutating func addPoint() {
        self.gamescore += 10
    }
    
    mutating func subPoint() {
        if self.gamescore <= 0 {
            self.gamescore = 0
        } else {
            self.gamescore -= 10
        }
    }
    
    func heartVisible(stackView: UIStackView, mode: String) {
        if mode == "EASY" {
            if let view = stackView.arrangedSubviews as? [UIStackView] {
                view[1].isHidden = true
            }
        } else {
            stackView.isHidden = false
        }
    }
        
}
