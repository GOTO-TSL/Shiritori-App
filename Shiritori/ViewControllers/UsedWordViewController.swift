//
//  UsedWordViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/16.
//

import UIKit

class UsedWordViewController: UIViewController {
    
    // MARK: - Properties
    var usedWordView: UsedWordView!
    var tableView: UITableView!
    
    // ステータスバーの色を白に設定
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // headerに枠線を追加
        usedWordView.headerView.addBorder(width: 1.0, color: .white, position: .bottom)
        usedWordView.headerView.addBorder(width: 1.0, color: .white, position: .left)
        usedWordView.headerView.addBorder(width: 1.0, color: .white, position: .right)
    }
    
    private func configureUI() {
        usedWordView = UsedWordView()
        tableView = usedWordView.tableView
        
        // 配置＆制約の追加
        view.addSubview(usedWordView)
        usedWordView.addConstraintsToFillView(view)
        
        // delegateの設定
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource Methods
extension UsedWordViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.CellID.used, for: indexPath) as? WordTableViewCell
        guard let safeCell = cell else { fatalError() }
        safeCell.wordLabel.text = "word"
        return safeCell
    }
}
