//
//  WordSource.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/06/10.
//

import Foundation
import GRDB

protocol WordSourceDelegate {
    func updateWord(_ wordSource: WordSource, word: String)
    func addPlayerWord()
}

struct WordSource {
    
    var delegate: WordSourceDelegate?
    
    func featchWord(dbqueue: DatabaseQueue, inputWord: String) {
        //ゲームスタート時に呼ばれるランダムなワードを取ってくる処理
        if inputWord.count == 1 {
            do {
                try dbqueue.read { db in
                    // Fetch database rows
                    guard let rows = try Row.fetchOne(db, sql:"SELECT * FROM items WHERE word LIKE '\(inputWord)%' AND word NOT LIKE '%.' AND LENGTH(word) <= 14 ORDER BY RANDOM()") else {
                        self.delegate?.updateWord(self, word: "")
                        return
                    }
                    let word: String = rows["word"]
                    self.delegate?.updateWord(self, word: word)
                }
            } catch {
                print("Error \(error)")
            }
        } else {
            //プレイヤーからの入力にしりとりする単語をランダムに取ってくる処理
            do {
                try dbqueue.read { db in
                    // Fetch database rows
                    guard (try Row.fetchOne(db, sql: "SELECT * FROM items WHERE word LIKE '\(inputWord)' AND word NOT LIKE '%.' AND LENGTH(word) <= 14")) != nil else {
                        self.delegate?.updateWord(self, word: "")
                        return
                    }
                    self.delegate?.addPlayerWord()
                    let initial = inputWord[inputWord.index(before: inputWord.endIndex)]
                    guard let rows = try Row.fetchOne(db, sql: "SELECT * FROM items WHERE word LIKE '\(initial)%' AND word NOT LIKE '%.' AND LENGTH(word) <= 14 ORDER BY RANDOM()") else {
                        self.delegate?.updateWord(self, word: "")
                        return
                    }
                    let word: String = rows["word"]
                    self.delegate?.updateWord(self, word: word)
                }
            } catch {
                print("Error \(error)")
            }
        }
    }
    
    func featchMean(dbqueue: DatabaseQueue, word: String) -> String {
        var result = ""
        do {
            try dbqueue.read { db in
                // Fetch database rows
                guard let rows = try Row.fetchOne(db, sql: "SELECT * FROM items WHERE word LIKE '\(word)'") else {
                    return
                }
                let mean: String = rows["mean"]
                result = mean
            }
        } catch {
            print("Error \(error)")
        }
        return result
    }
}
