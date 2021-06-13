//
//  StartViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/04.
//

import UIKit
import CoreData
import GRDB

class StartViewController: UIViewController {
    
    @IBOutlet weak var PlayButton: UIButton!
    var wordArray = [Word]()
    var myWords = [MyWord]()
    var wordSource = WordSource()
    var dbQueue = DatabaseQueue()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        PlayButton.layer.cornerRadius = 5.0
        
        createDatabase()
        if let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let path = dir.appending("/ejdict.sqlite3")
            do {
                dbQueue = try DatabaseQueue(path: path)
            } catch {
                print("Error \(error)")
            }
        }
        
        loadWord()
        
        for word in wordArray {
            if word.like {
                let newMyWord = MyWord(context: context)
                newMyWord.myword = word.word
                newMyWord.mean = wordSource.featchMean(dbqueue: dbQueue, word: newMyWord.myword!)
                myWords.append(newMyWord)
                context.delete(word)
                saveWord()
            } else {
                context.delete(word)
                saveWord()
            }
        }
    }
    //MARK: - Data Manipulation Methods
    func saveWord() {
        do {
            try context.save()
            
        } catch {
            print("Error saving word array, \(error)")
            
        }
    }
    
    func loadWord(with request: NSFetchRequest<Word> = Word.fetchRequest()) {
        do {
            wordArray = try context.fetch(request)
        } catch {
            print("Error loading word from context \(error)")
        }
    }
    /*
     データベースファイルをコピーする処理
     マスターデータファイルをアプリ実行時のディレクトリにコピーする
     */
    func createDatabase(){
        let fileManager = FileManager.default
        guard let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let finalDatabaseURL = documentsUrl.appendingPathComponent("ejdict.sqlite3")
        do {
            if !fileManager.fileExists(atPath: finalDatabaseURL.path) {
//                print("DB does not exist in documents folder")
                if let dbFilePath = Bundle.main.path(forResource: "ejdict", ofType: "sqlite3") {
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
