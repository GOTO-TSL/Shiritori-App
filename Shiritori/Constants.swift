//
//  Constant.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/30.
//

import Foundation

struct K {
    
    static let alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    static let feeling = ["normal": 0, "laugh": 1, "confuse": 2]
    
    struct SegueID {
        static let toresult = "toResult"
        static let toplay = "toPlay"
    }
    struct Timer {
        static let playTime: Int = 60
        static let countDownTime: Int = 4
    }

}
