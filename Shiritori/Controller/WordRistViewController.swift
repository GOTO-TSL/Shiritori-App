//
//  WordRistViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/06/04.
//

import UIKit

class WordRistViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var words: [WordRist] = [
        WordRist(word: "dog", meaning: "犬"),
        WordRist(word: "cat", meaning: "猫"),
        WordRist(word: "pig", meaning: "豚")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "WordCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")

    }

}
extension WordRistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! WordCell
        cell.wordLabel.text = words[indexPath.row].meaning
        return cell
    }
    
    
}
