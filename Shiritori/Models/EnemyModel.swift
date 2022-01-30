//
//  EnemyModel.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/20.
//

import Foundation

enum Mode: String {
    case easy
    case normal
    case hard
    case challenge
    
    init?(modeString: String) {
        switch modeString {
        case "EASY": self = .easy
        case "NORMAL": self = .normal
        case "HARD": self = .hard
        case "CHALLENGE": self = .challenge
        default: return nil
        }
    }
}

protocol EnemyModelDelegate: AnyObject {
    func didChangeHP(_ enemyModel: EnemyModel, currentHP: Int, maxHP: Int)
}

final class EnemyModel {
    // MARK: - Properties
    let mode: Mode
    let hpMax: Int
    var shiritoriCount: Int = 0
    var hitpoint: Int
    weak var delegete: EnemyModelDelegate?
    
    // MARK: - Lifecycle
    init() {
        self.mode = UserDefaults.standard.getEnum(forKey: Const.UDKeys.currentMode)!
        
        switch mode {
        case .easy:
            self.hpMax = Const.GameParam.easy
            self.hitpoint = Const.GameParam.easy
        case .normal:
            self.hpMax = Const.GameParam.normal
            self.hitpoint = Const.GameParam.normal
        case .hard:
            self.hpMax = Const.GameParam.hard
            self.hitpoint = Const.GameParam.hard
        case .challenge:
            // TODO: challengeモードでは必要ないのであとでなんとかする
            self.hpMax = 100
            self.hitpoint = 100
        }
    }
    
    // MARK: - EnemyModel Methods
    // 単語の文字数かける10ダメージHPをへらす
    func getDamage(word: String) {
        let damage = word.count * 10
        hitpoint -= damage
        self.delegete?.didChangeHP(self, currentHP: hitpoint, maxHP: hpMax)
        
    }
    // HPを30回復する
    func heal() {
        hitpoint += 30
        if hitpoint >= hpMax {
            hitpoint = hpMax
        }
        self.delegete?.didChangeHP(self, currentHP: hitpoint, maxHP: hpMax)
    }
}
