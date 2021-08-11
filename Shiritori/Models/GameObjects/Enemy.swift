//
//  Enemy.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/08/08.
//
import Foundation

class Enemy {
    var mode: String
    var hitpoint: Int
    var limit: Int
    var damage: Int = 0 {
        didSet {
            self.hitpoint -= damage
        }
    }
    
    var heal: Int = 0 {
        didSet {
            self.hitpoint += heal
        }
    }
    
    init(_ mode: String) {
        self.mode = mode
        self.hitpoint = Constant.scoreLimit[mode] ?? 0
        self.limit = Constant.scoreLimit[mode] ?? 0
    }
}
