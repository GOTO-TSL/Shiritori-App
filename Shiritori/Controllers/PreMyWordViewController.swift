//
//  MyWordViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/06/09.
//

import UIKit

class PreMyWordViewController: UITableViewController {
    var dataManager = DataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // カスタムセルの追加
        tableView.register(UINib(nibName: Constant.NibName.mywordCell, bundle: nil), forCellReuseIdentifier: Constant.CellID.mywordCell)
        dataManager.loadMyWords()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    /// MeanViewControllerへの値渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueID.toMean {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let myWord = dataManager.myWords?[indexPath.row] else { fatalError() }
                let distinationVC = segue.destination as? MeanViewController
                distinationVC?.name = myWord.name
                distinationVC?.mean = myWord.mean
            }
        }
    }

    // MARK: - TableView DataSource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.myWords?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellID.mywordCell, for: indexPath) as? MyWordCell
        guard let myWordCell = cell else { fatalError() }
        guard let myWord = dataManager.myWords?[indexPath.row] else { fatalError() }
        myWordCell.myWordLabel.text = myWord.name
        
        return myWordCell
    }
    
    // MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // MeanVCへ移動
        performSegue(withIdentifier: Constant.SegueID.toMean, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 単語を削除
        guard let deletedWord = dataManager.myWords?[indexPath.row] else { fatalError() }
        dataManager.delete(word: deletedWord)
        dataManager.loadMyWords()
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }

    // 削除ボタンが押されたときの処理
    @IBAction func removePressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
        } else {
            tableView.setEditing(true, animated: true)
        }
    }
}
