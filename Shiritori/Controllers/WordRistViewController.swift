//
//  WordRistViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/06/04.
//

import UIKit

class WordRistViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var wordArray: [Word]?
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Words.plist")


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "WordCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        loadWord()

    }
    
    func loadWord() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do {
                wordArray = try decoder.decode([Word].self, from: data)
                
            } catch {
                print("Error decoding word array, \(error)")
                
            }
        }
    }

}

//MARK: - TableView DataSource Methods
extension WordRistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! WordCell
        
        cell.wordLabel.text = wordArray![indexPath.row].word
        
        return cell
    }
    
    
}
