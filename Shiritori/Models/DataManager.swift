//
//  DataManager.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/07/27.
//

import RealmSwift

/// Realmによる単語の保存や読み込みの処理を担当するモデル
struct DataManager {
    let realm = try? Realm()
    
    var words: Results<Word>?
    var myWords: Results<MyWord>?
    
    /// オブジェクトの変更を保存
    /// - Parameter model: 保存したいRealmオブジェクト
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
    
    /// Wordモデルの読み込み
    mutating func loadWords() {
        guard let real = realm else { fatalError() }
        words = real.objects(Word.self)
    }
    
    /// MyWordモデルの読み込み
    mutating func loadMyWords() {
        guard let real = realm else { fatalError() }
        myWords = real.objects(MyWord.self)
    }
    
    /// 単語の削除
    /// - Parameter word: 削除したい単語があるオブジェクト
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
    
    /// 新しい単語をWordオブジェクトに保存
    /// - Parameter word: 保存したい単語
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
    
    /// WordオブジェクトのisLike変数の値を変更し保存
    /// - Parameter word: 対象のWordオブジェクト
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
    
    /// 使用済みの単語かどうかを判定
    /// - Parameter word: 対象の単語
    /// - Returns: 結果
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
