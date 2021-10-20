//
//  DictDataModel.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/19.
//

import SQLite
import Foundation

struct DictDataModel {
    
    var database: Connection?
    
    mutating func openDB() {
        
        copyDataBaseFile()
        
        let path = Bundle.main.path(forResource: "ejdict", ofType: "sqlite3")!

        do {
            database = try Connection(path, readonly: true)
        } catch {
            print(error)
        }
    }
    // initialから始まる単語をDBから取得する
    func featchWord(initial: Character) {
        let word = Expression<String>("word")
        
        do {
            let query = try database!.prepare(getSafeWord(initial: initial)
                                              .limit(1, offset: Int.random(in: 0...count(initial: initial))))
            for item in query {
                print("word: \(item[word])")
            }
        } catch {
            print(error)
        }
    }
    // 取得した単語の文字数をカウント　ランダムの範囲を指定する際に使用
    private func count(initial: Character) -> Int {
        do {
            let count = try database!.scalar(getSafeWord(initial: initial).count)
            return count
        } catch {
                print(error)
            return 0
        }
    }
    // しりとりに使用できる単語を取得するクエリ
    private func getSafeWord(initial: Character) -> Table {
        let items = Table("items")
        let word = Expression<String>("word")
        // 特殊文字を除外してinitialから始まる単語を取得するクエリ
        let queryTable = items.filter(word.like("\(initial)%") &&
                                      !word.like("%.") &&
                                      !word.like("%!") &&
                                      !word.like("%\'") &&
                                      !word.like("%)") &&
                                      !word.like("%]") &&
                                      !word.like("%/"))
        return queryTable
    }
    // 単語をきれいな形にする
    private func trim(_ word: String) -> String {
        // すべて小文字にする
        var trimTarget = word.lowercased()
        // 数字を除外する
        trimTarget = trimTarget.remove(characterSet: .decimalDigits)
        return trimTarget
    }
    
    // DBファイルを実行ディレクトリにコピー
    private func copyDataBaseFile() {
        let fileManager = FileManager.default
        guard let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let finalDatabaseURL = documentsUrl.appendingPathComponent(Const.DBPath.fileName)
        do {
            if !fileManager.fileExists(atPath: finalDatabaseURL.path) {
                //print("DB does not exist in documents folder")
                if let dbFilePath = Bundle.main.path(forResource: Const.DBPath.ejdict, ofType: Const.DBPath.sqlite3) {
                    try fileManager.copyItem(atPath: dbFilePath, toPath: finalDatabaseURL.path)
                } else {
                    //print("Uh oh - foo.db is not in the app bundle")
                }
            } else {
                //print("Database file found at path: \(finalDatabaseURL.path)")
            }
        } catch {
            //print("Unable to copy foo.db: \(error)")
        }
    }
}
