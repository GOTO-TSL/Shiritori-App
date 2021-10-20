//
//  DictDataModel.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/19.
//

import SQLite
import Foundation

protocol DictDataManagerDelegate: AnyObject {
    func didFeatchWord(_ dictDataManager: DictDataManager, word: String)
    func didCheckWord(_ dictDataManager: DictDataManager, word: String, count: Int)
}

final class DictDataManager {
    
    weak var delegate: DictDataManagerDelegate?
    var database: Connection?
    var items: Table
    var word: Expression<String>
    var mean: Expression<String>
    
    init() {
        self.items = Table("items")
        self.word = Expression<String>("word")
        self.mean = Expression<String>("mean")
    }
    
    func openDB() {
        
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
        let table = getSafeWord(initial: initial)
        
        do {
            let query = try database!.prepare(table
                                              .limit(1, offset: Int.random(in: 0...count(table))))
            for item in query {
                print("word: \(trim(item[word]))")
                self.delegate?.didFeatchWord(self, word: trim(item[word]))
            }
        } catch {
            print(error)
        }
    }
    // 辞書にあるかどうかをチェックする
    func checkWord(inputs: String) {
        let queryTable = items.filter(word.like(inputs))
        let count = count(queryTable)
        self.delegate?.didCheckWord(self, word: inputs, count: count)

    }
    // 取得した単語の文字数をカウント　ランダムの範囲を指定する際に使用
    private func count(_ table: Table) -> Int {
        do {
            let count = try database!.scalar(table.count)
            return count
        } catch {
                print(error)
            return 0
        }
    }
    // しりとりに使用できる単語を取得するクエリ
    private func getSafeWord(initial: Character) -> Table {
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
