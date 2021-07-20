//
//  WordRistViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/06/04.
//

import UIKit
import RealmSwift

class WordListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var words: Results<Word>?
    var myWords: Results<MyWord>?
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    
        //カスタムセルを有効化
        tableView.register(UINib(nibName: K.NibName.wordCell, bundle: nil), forCellReuseIdentifier: K.CellID.wordListCell)
        
        load()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - Database Management Methods
    
    func load() {
        
        words = realm.objects(Word.self)
        
        tableView.reloadData()
    }

}

//MARK: - TableView DataSource Methods
extension WordListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellID.wordListCell, for: indexPath) as! WordListCell
        guard let selectedWord = words?[indexPath.row] else { fatalError() }
        //セルのテキストを設定，お気に入り登録されると星がつくように画像を変更
        cell.WordLabel.text = selectedWord.name
        cell.StarImage.image = selectedWord.isLike ? K.Images.Stars[1] : K.Images.Stars[0]
        
        return cell
    }
    
    
}

//MARK: - TableView Delegate Methods
extension WordListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //タップされたセルをお気に入り状態に変更
        guard let selectedWord = words?[indexPath.row] else { fatalError() }
        do {
            try realm.write {
                selectedWord.isLike = !selectedWord.isLike
            }
        } catch {
            print("Error updating isLike, \(error)")
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
