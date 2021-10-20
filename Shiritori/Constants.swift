//
//  Constants.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/11.
//

import Foundation

struct Const {
    static let font = "DotGothic16-Regular"
    static let alphabet = "abcdefghijklmnopqrstuvwxyz"
    static let placeholder = "入力してね"
    
    enum DBPath {
        static let fileName = "ejdict.sqlite3"
        static let ejdict = "ejdict"
        static let sqlite3 = "sqlite3"
    }
    
    enum CellID {
        static let used = "UsedWordCell"
        static let mine = "MyWordCell"
    }
    
    enum TitleText {
        static let main = "英単語しりとり"
        static let sub = "~Let's defeat the monster with Shiritori~"
        static let mode = "MODE SELECT"
        static let resultWin = "GAME CLEAR"
        static let resultLose = "GAME OVER"
        static let words = "WORDS"
        static let rule = "RULE"
        static let myWords = "MYWORDS"
        static let detail = "DETAIL"
        static let ranking = "RANKING"
    }
    
    enum BodyText {
        static let rule = """
        しりとりのルール\n・敵の単語の一番最後の文字から始まる英単語を返すこと\n・2文字以上の単語であること\n・辞書にある単語であること\n・同じ単語は使えない
        \n\n
        入力する英単語の文字数が与えるダメージになります\n
        制限時間以内に敵の体力を0にするとゲームクリア！
        """
        static let cms = "COMMING SOON..."
        static let text = """
                              あああああああああああ\n
                              あああああああああああ\n
                              あああああああああああ\n
                              あああああああああああ\n
                              あああああああああああ\n
                              あああああああああああ\n
                              あああああああああああ\n
                              あああああああああああ\n
                              あああああああああああ\n
                              あああああああああああ\n
                              あああああああああああ\n
                              あああああああああああ\n
                              あああああああああああ\n
                              あああああああああああ\n
                              あああああああああああ\n
                             """
    }
    
    enum GameText {
        static let start = "START!"
        static let end = "TIME IS UP!"
    }
    
    enum ButtonText {
        static let play = "PLAY"
        static let word = "WORDS"
        static let back = "back"
        static let home = "HOME"
        static let atk = "ATK"
        static let easy = "EASY"
        static let normal = "NORMAL"
        static let hard = "HARD"
    }
    
    enum Image {
        static let background = "background128"
        static let backB = "back_icon"
        static let backW = "back_icon_white"
        static let buttonFrame = "button_frame"
        static let like = "like"
        static let unlike = "unlike"
        static let next = "next"
        static let sound = "sound_icon16"
        static let help = "help_icon16"
        static let ranking = "ranking_icon16"
        static let modeFrame = "mode_frame"
        static let speechballoon = "speechballoon"
        static let hpFrame = "hp_frame"
        static let easy = "easy"
        static let normal = "normal"
        static let hard = "hard"
    }

}
