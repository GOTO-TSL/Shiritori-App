//
//  WordSource.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/06/10.
//

import Foundation
import GRDB

protocol WordSourceDelegate: AnyObject {
    func updateWord(_ wordSource: WordSource, word: String)
    func updateFirst(_ wordSource: WordSource, word: String)
    func invalidWord(_ wordSource: WordSource)
    func addPlayerWord(_ wordSource: WordSource)
}

struct WordSource {
    weak var delegate: WordSourceDelegate?
    
    func featchFirstWord(dbq: DatabaseQueue) {
        let initialString = Constant.alphabet[Int.random(in: 0 ... 24)]
        do {
            try dbq.read { database in
                // Fetch database rows
                guard let rows = try Row.fetchOne(database, sql: "SELECT * FROM items WHERE word LIKE '\(initialString)%' AND word NOT LIKE '%.' AND LENGTH(word) <= 14 ORDER BY RANDOM()") else {
                    self.delegate?.updateFirst(self, word: "")
                    return
                }
                let word: String = rows[Constant.DataBase.word]
                let lowWord = word.lowercased()
                self.delegate?.updateFirst(self, word: lowWord)
            }
        } catch {
            print("Error \(error)")
        }
    }
    
    func featchWord(dbq: DatabaseQueue, inputWord: String) { // プレイヤーからの入力にしりとりする単語をランダムに取ってくる処理
        do {
            try dbq.read { database in
                // Fetch database rows
                guard (try Row.fetchOne(database, sql: "SELECT * FROM items WHERE word LIKE '\(inputWord)' AND word NOT LIKE '%.' AND LENGTH(word) <= 14")) != nil else {
                    self.delegate?.invalidWord(self)
                    return
                }
                self.delegate?.addPlayerWord(self)
                let initial = inputWord[inputWord.index(before: inputWord.endIndex)]
                guard let rows = try Row.fetchOne(database, sql: "SELECT * FROM items WHERE word LIKE '\(initial)%' AND word NOT LIKE '%.' AND LENGTH(word) <= 14 ORDER BY RANDOM()") else {
                    self.delegate?.invalidWord(self)
                    return
                }
                let word: String = rows[Constant.DataBase.word]
                let lowWord = word.lowercased()
                self.delegate?.updateWord(self, word: lowWord)
            }
        } catch {
            print("Error \(error)")
        }
    }
    
    // 英単語の意味をとってっくる処理
    func featchMean(dbq: DatabaseQueue, word: String) -> String {
        var result = ""
        do {
            try dbq.read { database in
                // Fetch database rows
                guard let rows = try Row.fetchOne(database, sql: "SELECT * FROM items WHERE word LIKE '\(word)'") else {
                    return
                }
                let mean: String = rows[Constant.DataBase.mean]
                result = mean
            }
        } catch {
            print("Error \(error)")
        }
        return result
    }
    
    /*
     データベースファイルをコピーする処理
     マスターデータファイルをアプリ実行時のディレクトリにコピーする
     */
    func createDatabase() {
        let fileManager = FileManager.default
        guard let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let finalDatabaseURL = documentsUrl.appendingPathComponent(Constant.DataBase.name)
        do {
            if !fileManager.fileExists(atPath: finalDatabaseURL.path) {
//                print("DB does not exist in documents folder")
                if let dbFilePath = Bundle.main.path(forResource: Constant.DataBase.fore, ofType: Constant.DataBase.back) {
                    try fileManager.copyItem(atPath: dbFilePath, toPath: finalDatabaseURL.path)
                } else {
//                    print("Uh oh - foo.db is not in the app bundle")
                }
            } else {
//                print("Database file found at path: \(finalDatabaseURL.path)")
            }
        } catch {
//            print("Unable to copy foo.db: \(error)")
        }
    }
}
