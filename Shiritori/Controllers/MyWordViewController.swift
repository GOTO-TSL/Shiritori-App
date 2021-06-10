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
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SegueID.toMean {
            if let indexPath = tableView.indexPathForSelectedRow {
                let distinationVC = segue.destination as? MeanViewController
                distinationVC?.word = mywords[indexPath.row].myword
                distinationVC?.mean = mywords[indexPath.row].mean
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    }
    
    func saveWord() {
        do {
            try context.save()
            
        } catch {
            print("Error saving word array, \(error)")
            
        }
    }

    @IBAction func removePressed(_ sender: UIBarButtonItem) {
        if (tableView.isEditing) {
            tableView.setEditing(false, animated: true)
        } else {
            tableView.setEditing(true, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        context.delete(mywords[indexPath.row])
        saveWord()
        loadWord()
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
}
