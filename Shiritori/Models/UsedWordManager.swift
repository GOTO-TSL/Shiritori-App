//
//  UsedWordManager.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/21.
//

import Foundation
import SQLite

struct UsedWord {
    var wordID: Int = 0
    var word: String = ""
    var mean: String = ""
    var isLike: Bool = false
}

protocol UsedWordManagerDelegate: AnyObject {
    func didCheckIsUsed(_ usedWordManager: UsedWordManager, word: String, count: Int)
    func didGetUsedWords(_ usedWordManager: UsedWordManager, words: [UsedWord])
    func didChangeIsLike(_ usedWordManager: UsedWordManager, wordID: Int)
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
        } catch {
            print(error)
        }
    }
    
    func openDB() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        
        do {
            database = try Connection("\(path)/usedWord.sqlite3")
        } catch {
            print(error)
        }
    }
    
    func insert(_ usedWord: UsedWord) {
        do {
            try database!.run(usedWords.insert(or: .replace, word <- usedWord.word, mean <- usedWord.mean, isLike <- usedWord.isLike))
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
    
    func getAllWords() {
        var words = [UsedWord]()
        do {
            let query = try database!.prepare(usedWords)
            for item in query {
                var usedWord = UsedWord()
                usedWord.wordID = item[wordID]
                usedWord.word = item[word]
                usedWord.mean = item[mean]
                usedWord.isLike = item[isLike]
                words.append(usedWord)
            }
            self.delegate?.didGetUsedWords(self, words: words)
        } catch {
            print(error)
        }
    }
    
    func changeLike(for target: UsedWord) {
        let tagWord = usedWords.filter(wordID == target.wordID)
        
        do {
            try database!.run(tagWord.update(isLike <- !target.isLike))
            self.delegate?.didChangeIsLike(self, wordID: target.wordID)
        } catch {
            print(error)
        }
    }
}
