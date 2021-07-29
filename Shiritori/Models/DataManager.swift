//
//  DataManager.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/07/27.
//

import RealmSwift

struct DataManager {
    let realm = try? Realm()
    
    var words: Results<Word>?
    var myWords: Results<MyWord>?
    
    func save(model: Object) {
        guard let real = realm else { fatalError() }
        do {
            try real.write {
                real.add(model)
            }
        } catch {
            print("Error saving word, \(error)")
        }
    }

    mutating func loadWords() {
        guard let real = realm else { fatalError() }
        words = real.objects(Word.self)
    }
    
    mutating func loadMyWords() {
        guard let real = realm else { fatalError() }
        myWords = real.objects(MyWord.self)
    }
    
    func delete(word: Object) {
        guard let real = realm else { fatalError() }
        do {
            try real.write {
                real.delete(word)
            }
        } catch {
            print("Error deleting word, \(error)")
        }
    }
    
    func save(word: String) {
        let newWord = Word()
        newWord.name = word
        newWord.isLike = false
        
        guard let real = realm else { fatalError() }
        
        do {
            try real.write {
                real.add(newWord)
            }
        } catch {
            print("Error saving word, \(error)")
        }
    }
    
    func changeisLikeValue(for word: Word) {
        guard let real = realm else { fatalError() }
        do {
            try real.write {
                word.isLike = !word.isLike
            }
        } catch {
            print("Error updating isLike, \(error)")
        }
    }
    
    func isUsed(word: String) -> Bool {
        guard let real = realm else { fatalError() }
        let results = real.objects(Word.self).filter("name LIKE %@", word)
        if results.count == 0 {
            return false
        } else {
            return true
        }
    }
}
