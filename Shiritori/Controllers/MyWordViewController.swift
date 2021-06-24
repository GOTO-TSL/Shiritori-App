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
                let distinationVC = segue.destination as? MeanViewController
                distinationVC?.word = mywords[indexPath.row].myword
                distinationVC?.mean = mywords[indexPath.row].mean
            }
        }
    }

    // MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mywords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellID.mywordCell, for: indexPath) as! MyWordCell
        cell.MyWordLabel.text = mywords[indexPath.row].myword
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.SegueID.toMean, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        context.delete(mywords[indexPath.row])
        saveWord()
        loadWord()
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
    
    //MARK: - Database Management Methods
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
//削除ボタンが押されたときの処理
    @IBAction func removePressed(_ sender: UIBarButtonItem) {
        if (tableView.isEditing) {
            tableView.setEditing(false, animated: true)
        } else {
            tableView.setEditing(true, animated: true)
        }
    }
}
