//
//  EnemyModel.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/20.
//

import Foundation

enum Mode {
    case easy
    case normal
    case hard
}

protocol EnemyModelDelegate: AnyObject {
    func didChangeHP(_ enemyModel: EnemyModel, currentHP: Int, maxHP: Int)
}

final class EnemyModel {
    let mode: Mode
    let hpMax: Int
    var hitpoint: Int
    weak var delegete: EnemyModelDelegate?
    
    init(mode: Mode) {
        self.mode = mode
        
        switch mode {
        case .easy:
            self.hpMax = Const.HP.easy
            self.hitpoint = Const.HP.easy
        case .normal:
            self.hpMax = Const.HP.normal
            self.hitpoint = Const.HP.normal
        case .hard:
            self.hpMax = Const.HP.hard
            self.hitpoint = Const.HP.hard
        }
    }
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
