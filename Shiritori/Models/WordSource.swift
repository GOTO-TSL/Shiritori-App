//
//  WordSource.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/06/10.
//

import Foundation
import GRDB

protocol WordSourceDelegate {
    func updateWord(word: String)
    func updateFirst(word: String)
    func invalidWord()
    func addPlayerWord()
}

struct WordSource {
    
    var delegate: WordSourceDelegate?
    
    func featchFirstWord(dbqueue: DatabaseQueue) {
        let initialString = K.alphabet[Int.random(in: 0...24)]
        do {
            try dbqueue.read { db in
                //Fetch database rows
                guard let rows = try Row.fetchOne(db, sql:"SELECT * FROM items WHERE word LIKE '\(initialString)%' AND word NOT LIKE '%.' AND LENGTH(word) <= 14 ORDER BY RANDOM()") else {
                    self.delegate?.updateFirst(word: "")
                    return
                }
                let word: String = rows[K.DataBase.word]
                self.delegate?.updateFirst(word: word)
            }
        } catch {
            print("Error \(error)")
        }
    }
    
    func featchWord(dbqueue: DatabaseQueue, inputWord: String) { //プレイヤーからの入力にしりとりする単語をランダムに取ってくる処理
        do {
            try dbqueue.read { db in
                // Fetch database rows
                guard (try Row.fetchOne(db, sql: "SELECT * FROM items WHERE word LIKE '\(inputWord)' AND word NOT LIKE '%.' AND LENGTH(word) <= 14")) != nil else {
                    self.delegate?.invalidWord()
                    return
                }
                self.delegate?.addPlayerWord()
                let initial = inputWord[inputWord.index(before: inputWord.endIndex)]
                guard let rows = try Row.fetchOne(db, sql: "SELECT * FROM items WHERE word LIKE '\(initial)%' AND word NOT LIKE '%.' AND LENGTH(word) <= 14 ORDER BY RANDOM()") else {
                    self.delegate?.invalidWord()
                    return
                }
                let word: String = rows[K.DataBase.word]
                self.delegate?.updateWord(word: word)
                
            }
        } catch {
            print("Error \(error)")
        }
    }
    
    //英単語の意味をとってっくる処理
    func featchMean(dbqueue: DatabaseQueue, word: String) -> String {
        var result = ""
        do {
            try dbqueue.read { db in
                // Fetch database rows
                guard let rows = try Row.fetchOne(db, sql: "SELECT * FROM items WHERE word LIKE '\(word)'") else {
                    return
                }
                let mean: String = rows[K.DataBase.mean]
                result = mean
            }
        } catch {
            print("Error \(error)")
        }
        return result
    }
}
