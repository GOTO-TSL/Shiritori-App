//
//  UsedWordManager.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/21.
//

import Foundation
import SQLite
import FileProvider

struct Word {
    var wordID: Int = 0
    var word: String = ""
    var mean: String = ""
    var isLike: Bool = false
}

enum DeleteOption {
    case all
    case isntLike
    case selected
}

protocol WordDataManagerDelegate: AnyObject {
    func didCheckIsUsed(_ wordDataManager: WordDataManager, word: String, count: Int)
    func didLoadWord(_ wordDataManager: WordDataManager, words: [Word])
    func didCopyWord(_ wordDataManager: WordDataManager)
}

final class WordDataManager {
    
    private var database: Connection?
    
    private var words: Table
    private var wordID: Expression<Int>
    private var word: Expression<String>
    private var mean: Expression<String>
    private var isLike: Expression<Bool>
    weak var delegate: WordDataManagerDelegate?
    
    init() {
        self.words = Table("words")
        self.wordID = Expression<Int>("id")
        self.word = Expression<String>("word")
        self.mean = Expression<String>("mean")
        self.isLike = Expression<Bool>("isLike")
    }
    
    func createDB(name: String) {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        
        do {
            database = try Connection("\(path)/\(name)")
            guard let safeDB = database else { return }
            try safeDB.run(words.create(ifNotExists: true) { table in
                table.column(wordID, primaryKey: true)
                table.column(word)
                table.column(mean)
                table.column(isLike)
            })
        } catch {
            print(error)
        }
    }
    
    func openDB(name: String) {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        
        do {
            database = try Connection("\(path)/\(name)")
        } catch {
            print(error)
        }
    }
    
    func insert(_ usedWord: Word) {
        do {
            try database!.run(words.insert(or: .replace, word <- usedWord.word, mean <- usedWord.mean, isLike <- usedWord.isLike))
        } catch {
            print(error)
        }
    }
    
    func checkIsUsed(_ inputs: String) {
        let queryTable = words.filter(word.like(inputs))
        
        do {
            let count = try database!.scalar(queryTable.count)
            self.delegate?.didCheckIsUsed(self, word: inputs, count: count)
        } catch {
            print(error)
        }
    }
    
    func changeLike(for target: Word) {
        let tagWords = words.filter(wordID == target.wordID)
        
        do {
            try database!.run(tagWords.update(isLike <- !target.isLike))
        } catch {
            print(error)
        }
        loadWords()
    }
    
    func delete(option: DeleteOption, selectedWord: String = "") {
        var tagWords = Table("words")
        switch option {
        case .all:
            tagWords = words
        case .isntLike:
            tagWords = words.filter(isLike == false)
        case .selected:
            tagWords = words.filter(word.like(selectedWord))
        }
        do {
            try database!.run(tagWords.delete())
        } catch {
            print(error)
        }
        loadWords()
    }
    
    func copyWord(currentWords: [Word], to dbname: String) {
        openDB(name: dbname)
        do {
            for myWord in currentWords {
                try database!.run(words.insert(or: .replace, word <- myWord.word, mean <- myWord.mean, isLike <- myWord.isLike))
            }
            self.delegate?.didCopyWord(self)
        } catch {
            print(error)
        }
    }
    // DBをcurrentWordsにコピーする
    func loadWords() {
        var currentWords = [Word]()
        do {
            let query = try database!.prepare(words)
            for item in query {
                var wordobj = Word()
                wordobj.wordID = item[wordID]
                wordobj.word = item[word]
                wordobj.mean = item[mean]
                wordobj.isLike = item[isLike]
                currentWords.append(wordobj)
            }
            self.delegate?.didLoadWord(self, words: currentWords)
        } catch {
            print(error)
        }
        
    }
}
