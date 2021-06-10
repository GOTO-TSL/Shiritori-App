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
    func updateMean(_ wordSource: WordSource, mean: String)
    func addPlayerWord()
}

struct WordSource {
    var word: String = ""
    var mean: String = ""
    var id: String = ""
    
    var delegate: WordSourceDelegate?
    
    mutating func featchWord(dbqueue: DatabaseQueue, inputWord: String) {
        //ゲームスタート時に呼ばれるランダムなワードを取ってくる処理
        if inputWord.count == 1 {
            do {
                try dbqueue.read { db in
                    // Fetch database rows
                    guard let rows = try Row.fetchOne(db, sql: "SELECT * FROM items WHERE word LIKE '\(inputWord)%' AND word NOT LIKE '%.' ORDER BY RANDOM()") else {
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
                    guard (try Row.fetchOne(db, sql: "SELECT * FROM items WHERE word LIKE '\(inputWord)' AND word NOT LIKE '%.'")) != nil else {
                        self.delegate?.updateWord(self, word: "")
                        return
                    }
                    self.delegate?.addPlayerWord()
                    let initial = inputWord[inputWord.index(before: inputWord.endIndex)]
                    guard let rows = try Row.fetchOne(db, sql: "SELECT * FROM items WHERE word LIKE '\(initial)%' AND word NOT LIKE '%.' ORDER BY RANDOM()") else {
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
    
    mutating func featchMean(dbqueue: DatabaseQueue, word: String) {
        do {
            try dbqueue.read { db in
                // Fetch database rows
                guard let rows = try Row.fetchOne(db, sql: "SELECT * FROM items WHERE word LIKE '\(word)'") else {
                    self.delegate?.updateMean(self, mean: "")
                    return
                }
                let mean: String = rows["mean"]
                self.delegate?.updateMean(self, mean: mean)
            }
        } catch {
            print("Error \(error)")
        }
    }
}
