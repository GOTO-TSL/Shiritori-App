//
//  MyWordViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/06/09.
//

import UIKit
import RealmSwift

class MyWordViewController: UITableViewController {
    
    var myWords: Results<MyWord>?
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        //カスタムセルの追加
        tableView.register(UINib(nibName: K.NibName.mywordCell, bundle: nil), forCellReuseIdentifier: K.CellID.mywordCell)
        loadWord()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MeanViewControllerへの値渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SegueID.toMean {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let myWord = myWords?[indexPath.row] else { fatalError() }
                let distinationVC = segue.destination as? MeanViewController
                distinationVC?.name = myWord.name
                distinationVC?.mean = myWord.mean
            }
        }
    }

    // MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myWords?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellID.mywordCell, for: indexPath) as! MyWordCell
        
        guard let myWord = myWords?[indexPath.row] else { fatalError() }
        cell.MyWordLabel.text = myWord.name
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //MeanVCへ移動
        performSegue(withIdentifier: K.SegueID.toMean, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //単語を削除
        guard let deletedWord = myWords?[indexPath.row] else { fatalError() }
        do {
            try realm.write {
                realm.delete(deletedWord)
            }
        } catch {
            print("Error deleted word, \(error)")
        }
        loadWord()
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
    
    //MARK: - Database Management Methods
    func loadWord() {
        myWords = realm.objects(MyWord.self)
    }

    //削除ボタンが押されたときの処理
    @IBAction func removePressed(_ sender: UIBarButtonItem) {
        if (tableView.isEditing) {
            tableView.setEditing(false, animated: true)
        } else {
            tableView.setEditing(true, animated: true)
        }
    }
}
