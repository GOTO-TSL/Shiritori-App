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
    
    enum UDKeys {
        static let currentWord = "currentWord"
        static let currentMode = "currentMode"
        static let isWin = "isWin"
        static let isMute = "isMute"
        static let isWinEasy = "winEasy"
        static let isWinNormal = "winNormal"
        static let isWinHard = "winHard"
        static let first = "firstLaunch"
        static let winCount = "winCount"
    }
    
    enum GameParam {
        static let easy = 250
        static let normal = 500
        static let hard = 1100
        static let timeLimit = 60
    }
    
    enum DBName {
        static let ejdict = "ejdict.sqlite3"
        static let usedWords = "usedWords.sqlite3"
        static let myWords = "myWords.sqlite3"
    }
    
    enum DBPath {
        static let fileName = "ejdict.sqlite3"
        static let ejdict = "ejdict"
        static let sqlite3 = "sqlite3"
    }
    
    enum CellID {
        static let used = "UsedWordCell"
        static let mine = "MyWordCell"
    }
    
    enum TutorialText {
        static let home = ["モードを選択後にしりとりゲームが始まるよ！",
                           "ゲーム終了後に使った単語を登録すると，\nここで確認できるよ！",
                           "音楽のON/OFFを切り替えれるよ！",
                           "しりとりゲームのルールを確認できるよ！",
                           "現在開発中だよ！"]
        static let game = ["敵が英単語をくりだして来るよ！",
                           "しりとりになる英単語を入力しよう！",
                           "ATTACKボタンで攻撃しよう！",
                           "しりとりが成功するとダメージが与えられるよ！",
                           "制限時間以内に敵をたおそう！"]
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
    
    enum AlertText {
        static let open = "モード解放"
        static let clear = "ゲームクリア！"
        static let messageNormal = "NORMALモードが解放されました"
        static let messageHard = "HARDモードが解放されました"
        static let messageClear = "遊んでくれてありがとう！"
    }
    
    enum BodyText {
        static let rule = """
        しりとりのルール\n・敵の単語の一番最後の文字から始まる英単語を返すこと\n・2文字以上の単語であること\n・辞書にある単語であること\n・同じ単語は使えない
        \n\n
        入力する英単語の文字数が与えるダメージになります\n
        制限時間以内に敵の体力を0にするとゲームクリア！
        """
        static let cms = "COMMING SOON..."
    }
    
    enum GameText {
        static let start = "START!"
        static let end = "TIME IS UP!"
        static let notInDict = "辞書にないよ"
        static let shiritori = "しりとりしてね"
        static let blank = "2文字以上入力してね"
        static let used = "使った単語だよ"
        static let dead = "やられた〜"
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
        static let challenge = "CHALLENGE"
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
        static let mute = "sound_icon_off16"
        static let help = "help_icon16"
        static let ranking = "ranking_icon16"
        static let modeFrame = "mode_frame"
        static let speechballoon = "speechballoon"
        static let hpFrame = "hp_frame"
        static let easy = "EASY"
        static let normal = "NORMAL"
        static let hard = "HARD"
        static let trash = "trash"
        static let tutorial = "tutorial"
        static let reward0 = "easy/reward"
        static let reward1 = "normal/reward"
        static let reward2 = "hard/reward"
    }
    
    enum Sound {
        static let opening = "opening"
        static let battle = "battle"
        static let push = "push"
        static let damage = "damage"
        static let heal = "heal"
        static let win = "win"
        static let lose = "lose"
    }

}
