//
//  WordRistViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/06/04.
//

import UIKit
import CoreData

class WordListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var wordArray = [Word]()
    var mywords = [MyWord]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    
        //カスタムセルを有効化
        tableView.register(UINib(nibName: "WordListCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        loadWord()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - Database Management Methods
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
        
        tableView.reloadData()
    }

}

//MARK: - TableView DataSource Methods
extension WordListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! WordListCell
        let words = wordArray[indexPath.row]
        
        cell.WordLabel.text = words.word
        cell.StarImage.image = wordArray[indexPath.row].like ? K.Images.Stars[1] : K.Images.Stars[0]
        
        return cell
    }
    
    
}

//MARK: - TableView Delegate Methods
extension WordListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        wordArray[indexPath.row].like = !wordArray[indexPath.row].like
        tableView.reloadData()
        saveWord()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
