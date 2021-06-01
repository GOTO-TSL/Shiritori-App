//
//  ShiritoriManager.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/25.
//

import Foundation
import UIKit

struct GameLogic {
    var gamescore: Int = 0
    
    func Shiritori(textField: UITextField?, endCharacter: Character) -> Bool {
        if let safetf = textField {
            if safetf.text != "" {
                let initialString = safetf.text?[safetf.text!.startIndex]
                
                if safetf.text?.count == 1 {
                    safetf.text = ""
                    safetf.placeholder = "Enter at least 2 characters"
                    return false
                } else {
                    if endCharacter == initialString {
                        safetf.placeholder = ""
                        return true
                    } else {
                        safetf.text = ""
                        safetf.placeholder = "Shiritori Please!"
                        return false
                    }
                }
            } else {
                textField?.placeholder = "Wirte Something!"
                return false
            }
        } else {
            return false
        }
    }
    
    mutating func addPoint() {
        self.gamescore += 10
    }
    
    mutating func subPoint() {
        if self.gamescore < 0 {
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
