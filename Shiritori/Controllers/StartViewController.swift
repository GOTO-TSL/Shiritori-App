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
    
    var wordArray = [Word]()
    var myWords = [MyWord]()
    var wordsource = WordSource()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        if let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let path = dir.appending("/ejdict.sqlite3")
            do {
                let dbQueue = try DatabaseQueue(path: path)
                wordsource.featchWord(dbqueue: dbQueue, inputWord: "dd")
                wordsource.featchMean(dbqueue: dbQueue, word: wordsource.word)
            } catch {
                print("Error \(error)")
            }
        }
        
        loadWord()
        
        for word in wordArray {
            if word.like {
                let newMyWord = MyWord(context: context)
                newMyWord.myword = word.word
                newMyWord.mean = ""
                myWords.append(newMyWord)
                context.delete(word)
                saveWord()
            } else {
                context.delete(word)
                saveWord()
            }
        }
    }
    
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

}
