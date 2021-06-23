//
//  Constant.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/30.
//

import Foundation
import UIKit

struct K {
    
    static let alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    static let feeling = ["normal": 0, "laugh": 1, "confuse": 2]
    static let scoreLimit = ["EASY": 50, "NORMAL": 100, "HARD": 200]
    static let modeColor: [String: UIColor] = ["EASY": .systemGreen, "NORMAL": .systemBlue, "HARD": .systemPink]

    struct SegueID {
        static let toresult = "toResult"
        static let towordlist = "toWordRist"
        static let toplay = "toPlay"
        static let toMean = "toMean"
    }
    struct Timer {
        static let playTime: Int = 60
        static let countDownTime: Int = 4
    }
    
    struct Images {
        static let enemy = ["EASY": #imageLiteral(resourceName: "EASY0"), "NORMAL": #imageLiteral(resourceName: "NORMAL0"), "HARD": #imageLiteral(resourceName: "HARD0")]
        static let ending = [[#imageLiteral(resourceName: "happyEndRight2"), #imageLiteral(resourceName: "badEndRight2")], [#imageLiteral(resourceName: "happyEndRight1"), #imageLiteral(resourceName: "badEndRight1")], [#imageLiteral(resourceName: "happyEndRight3"), #imageLiteral(resourceName: "badEndRight3")]]
        static let playerEnd = [#imageLiteral(resourceName: "happyEndLeft"), #imageLiteral(resourceName: "badEndLeft")]
        static let Stars = [#imageLiteral(resourceName: "brankstar"), #imageLiteral(resourceName: "fillstar")]
    }

}
