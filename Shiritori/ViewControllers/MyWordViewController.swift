//
//  MyWordViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/17.
//

import UIKit

class MyWordViewController: UIViewController {
    
    // MARK: - Properties
    private var myWordView: MyWordView!
    private var tableView: UITableView!
    private var backButton: UIButton!
    private var editButton: UIButton!
    private var myWords: [Word]!
    private var presenter: MyWordViewPresenter!
    // ステータスバーの色を白に設定
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        presenter = MyWordViewPresenter(view: self)
        presenter.myWordViewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // headerに枠線を追加
        myWordView.headerView.addBorder(width: 1.0, color: .white, position: .bottom)
        myWordView.headerView.addBorder(width: 1.0, color: .white, position: .left)
        myWordView.headerView.addBorder(width: 1.0, color: .white, position: .right)
    }
    
    private func configureUI() {
        myWordView = MyWordView()
        tableView = myWordView.tableView
        backButton = myWordView.headerView.backButton
        editButton = myWordView.editButton
        
        // 配置＆制約の追加
        view.addSubview(myWordView)
        myWordView.addConstraintsToFillView(view)
        
        // ボタンにアクションを追加
        backButton.addTarget(self, action: #selector(backPressed(_ :)), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editPressed(_ :)), for: .touchUpInside)
        // delegateの設定
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc private func backPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func editPressed(_ sender: UIButton) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
        } else {
            tableView.setEditing(true, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource Methods
extension MyWordViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.CellID.mine, for: indexPath) as? MyWordTableViewCell
        guard let safeCell = cell else { fatalError() }
        safeCell.selectionStyle = .none
        safeCell.wordLabel.text = myWords[indexPath.row].word
        return safeCell
    }
}

// MARK: - UITableViewDelegate Methods
extension MyWordViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let detailVC = WordDetailViewController()
        detailVC.modalPresentationStyle = .fullScreen
        detailVC.word = myWords[indexPath.row].word
        detailVC.mean = myWords[indexPath.row].mean
        addTransition(duration: 0.3, type: .push, subType: .fromRight)
        present(detailVC, animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        presenter.deleted(word: myWords[indexPath.row])
        self.myWords.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
// MARK: - MyWordViewProtocol Methods
extension MyWordViewController: MyWordViewProtocol {
    func showWords(_ myWordViewPresenter: MyWordViewPresenter, words: [Word]) {
        DispatchQueue.main.async {
            self.myWords = words
            self.tableView.reloadData()
        }
    }
}
