//
//  Constant.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/30.
//

import Foundation
import UIKit

struct Constant {
    static let alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    static let scoreLimit = ["EASY": 350, "NORMAL": 600, "HARD": 1000]
    static let modeColor: [String: UIColor] = ["EASY": .systemGreen, "NORMAL": .systemBlue, "HARD": .systemPink]
    
    enum CellID {
        static let wordListCell = "ReusableCell"
        static let mywordCell = "MyWordCell"
    }
    
    enum NibName {
        static let wordCell = "WordListCell"
        static let mywordCell = "MyWordCell"
    }

    enum Mode {
        static let easy = "EASY"
        static let normal = "NORMAL"
        static let hard = "HARD"
    }
    
    enum Texts {
        static let mainTitle = "英単語しりとり"
        static let subTitle = "~Let's defeat the monster with Shiritori~"
        static let rule = """
        しりとりをすることで敵に攻撃することができます．\n60秒以内敵を倒すことができたらクリアです．\n
        しりとりのルール\n・敵の繰り出す最後の文字から始まる英単語をであること\n・二文字以上の単語であること\n・辞書にある単語であること
        """
        static let winText = "You Win!"
        static let loseText = "You Lose..."
    }
    
    enum Comments {
        static let lose = "やられた～"
        static let invalid = "辞書にない!"
        static let single = "１文字だよ!"
        static let used = "使った単語!"
        static let noShiritori = "しりとりしてね"
        static let empty = "なにか書いてね"
        static let start = "START!"
        static let end = "Time's Up!"
        static let wait = "..."
    }

    enum DataBase {
        static let path = "/ejdict.sqlite3"
        static let name = "ejdict.sqlite3"
        static let fore = "ejdict"
        static let back = "sqlite3"
        static let word = "word"
        static let mean = "mean"
    }
    
    enum UserDefaultKeys {
        static let currentWord = "currentWord"
        static let currentMode = "currentMode"
        static let isMute = "isMute"
        static let isClearEasy = "isClearEasy"
        static let isClearNormal = "isClearNormal"
        static let isClearHard = "isClearHard"
        static let firstLaunch = "firstLaunch"
        static let hitpoint = "hitpoint"
    }

    enum HeroID {
        static let mode = "mode"
        static let enemy = "enemy"
    }

    enum SegueID {
        static let toresult = "toResult"
        static let towordlist = "toWordRist"
        static let toplay = "toPlay"
        static let toMean = "toMean"
        static let goBackToResult = "goBackToResult"
        static let toWordList = "toWordList"
    }

    enum Timer {
        static let playTime: Int = 60
        static let countDownTime: Int = 4
    }
    
    enum Images {
        static let enemy = ["EASY": #imageLiteral(resourceName: "EASY0"), "NORMAL": #imageLiteral(resourceName: "NORMAL0"), "HARD": #imageLiteral(resourceName: "HARD0")]
        static let rewards = ["EASY": [#imageLiteral(resourceName: "EASYclear0"), #imageLiteral(resourceName: "EASYclear1")], "NORMAL": [#imageLiteral(resourceName: "NORMALclear0"), #imageLiteral(resourceName: "NORMALclear1")], "HARD": [#imageLiteral(resourceName: "HARDclear0"), #imageLiteral(resourceName: "HARDclear1")]]
        static let stars = [#imageLiteral(resourceName: "brank"), #imageLiteral(resourceName: "fill")]
        static let sounds = [#imageLiteral(resourceName: "musicON"), #imageLiteral(resourceName: "musicOFF")]
    }
    
    enum AnimationAction {
        static let main = ""
        static let damage = "damage"
        static let heal = "heal"
        static let down = "down"
        static let win = "win"
        static let lose = "lose"
    }
    
    enum Sounds {
        static let opening = "opening"
        static let push = "push"
        static let battle = "battle"
        static let heal = "heal"
        static let damage = "damage"
        static let win = "win"
        static let lose = "lose"
    }
}
