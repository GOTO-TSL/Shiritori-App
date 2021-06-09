//
//  MyWordViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/06/09.
//

import UIKit
import CoreData

class MyWordViewController: UITableViewController {
    
    var mywords = [MyWord]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        loadWord()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mywords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyWordCell", for: indexPath)
        cell.textLabel?.text = mywords[indexPath.row].myword
        return cell
    }
    
    func loadWord(with request: NSFetchRequest<MyWord> = MyWord.fetchRequest()) {
        do {
            mywords = try context.fetch(request)
        } catch {
            print("Error loading word from context \(error)")
        }
        tableView.reloadData()
    }

}
