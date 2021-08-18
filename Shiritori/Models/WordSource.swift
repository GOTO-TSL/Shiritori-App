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

/// 使用する単語を辞書から持ってくる処理を担当するモデル
struct WordSource {
    weak var delegate: WordSourceDelegate?
    
    /// 最初の単語を持ってくる処理
    /// - Parameter dbq: 辞書のデータベースキュー
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
                if !isSafeWord(word) {
                    self.delegate?.invalidWord(self)
                }
                let lowWord = word.lowercased()
                self.delegate?.updateFirst(self, word: lowWord)
            }
        } catch {
            print("Error \(error)")
        }
    }
    
    /// 敵の繰り出す単語を辞書から取得する処理
    /// - Parameters:
    ///   - dbq: 辞書データベースキュー
    ///   - inputWord: 入力された単語
    func featchWord(dbq: DatabaseQueue, inputWord: String) {
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
                if !isSafeWord(word) {
                    self.delegate?.invalidWord(self)
                }
                let lowWord = word.lowercased()
                self.delegate?.updateWord(self, word: lowWord)
            }
        } catch {
            print("Error \(error)")
        }
    }
    
    /// 英単語の意味を辞書から取得する処理
    /// - Parameters:
    ///   - dbq: 辞書データベースキュー
    ///   - word: 英単語
    /// - Returns: 意味
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
    
    /// データベースファイルをコピーする処理，マスターデータファイルをアプリ実行時のディレクトリにコピーする
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
    
    private func isSafeWord(_ word: String) -> Bool {
        let end = word.suffix(1)
        if Constant.alphabet.contains(String(end)) {
            return true
        } else {
            return false
        }
    }
}
