//
//  UsedWordManager.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/21.
//

import Foundation
import SQLite

struct UsedWord {
    let wordID: Int = 0
    let word: String
    let mean: String
    let isLike: Bool = false
}

protocol UsedWordManagerDelegate: AnyObject {
    func didCreateDB(_ usedWordManager: UsedWordManager)
    func didInsertWord(_ usedWordManager: UsedWordManager)
    func didCheckIsUsed(_ usedWordManager: UsedWordManager, word: String, count: Int)
}

final class UsedWordManager {
    
    private var database: Connection?
    weak var delegate: UsedWordManagerDelegate?
    private var usedWords: Table
    private var wordID: Expression<Int>
    private var word: Expression<String>
    private var mean: Expression<String>
    private var isLike: Expression<Bool>
    
    init() {
        self.usedWords = Table("usedWords")
        self.wordID = Expression<Int>("id")
        self.word = Expression<String>("word")
        self.mean = Expression<String>("mean")
        self.isLike = Expression<Bool>("isLike")
    }
    
    func createDB() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        
        do {
            database = try Connection("\(path)/usedWord.sqlite3")
            guard let safeDB = database else { return }
            try safeDB.run(usedWords.create(ifNotExists: true) { table in
                table.column(wordID, primaryKey: true)
                table.column(word)
                table.column(mean)
                table.column(isLike)
            })
            self.delegate?.didCreateDB(self)
        } catch {
            print(error)
        }
    }
    
    func insert(_ usedWord: UsedWord) {
        do {
            try database!.run(usedWords.insert(or: .replace, word <- usedWord.word, mean <- usedWord.mean, isLike <- usedWord.isLike))
            self.delegate?.didInsertWord(self)
        } catch {
            print(error)
        }
    }
    
    func checkIsUsed(_ inputs: String) {
        let queryTable = usedWords.filter(word.like(inputs))
        
        do {
            let count = try database!.scalar(queryTable.count)
            self.delegate?.didCheckIsUsed(self, word: inputs, count: count)
        } catch {
            print(error)
        }
    }
}
