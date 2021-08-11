//
//  WordRistViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/06/04.
//

import UIKit

class WordListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var dataManager = DataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    
        // カスタムセルを有効化
        tableView.register(UINib(nibName: Constant.NibName.wordCell, bundle: nil), forCellReuseIdentifier: Constant.CellID.wordListCell)
        
        dataManager.loadWords()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: - TableView DataSource Methods

extension WordListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.words?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellID.wordListCell, for: indexPath) as? WordListCell
        guard let wordCell = cell else { fatalError() }
        guard let selectedWord = dataManager.words?[indexPath.row] else { fatalError() }
        // セルのテキストを設定，お気に入り登録されると星がつくように画像を変更
        wordCell.wordLabel.text = selectedWord.name
        wordCell.starImage.image = selectedWord.isLike ? Constant.Images.stars[1] : Constant.Images.stars[0]
        
        return wordCell
    }
}

// MARK: - TableView Delegate Methods

extension WordListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // タップされたセルをお気に入り状態に変更
        guard let selectedWord = dataManager.words?[indexPath.row] else { fatalError() }
        dataManager.changeisLikeValue(for: selectedWord)
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
