//
//  DataManager.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/07/27.
//

import RealmSwift

struct DataManager {
    let realm = try! Realm()
    
    var words: Results<Word>?
    var myWords: Results<MyWord>?
    
    func save(model: Object) {
        do {
            try realm.write {
                realm.add(model)
            }
        } catch {
            print("Error saving word, \(error)")
        }
    }

    mutating func loadWords() {
        words = realm.objects(Word.self)
    }
    
    mutating func loadMyWords() {
        myWords = realm.objects(MyWord.self)
    }
    
    func delete(word: Object) {
        do {
            try realm.write {
                realm.delete(word)
            }
        } catch {
            print("Error deleting word, \(error)")
        }
    }
    
    func save(word: String) {
        let newWord = Word()
        newWord.name = word
        newWord.isLike = false
        
        do {
            try realm.write {
                realm.add(newWord)
            }
        } catch {
            print("Error saving word, \(error)")
        }
    }
    
    func changeisLikeValue(for word: Word) {
        do {
            try realm.write {
                word.isLike = !word.isLike
            }
        } catch {
            print("Error updating isLike, \(error)")
        }
    }

    
}
