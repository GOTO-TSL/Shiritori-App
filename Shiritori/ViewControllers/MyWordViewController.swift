//
//  MyWordViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/17.
//

import UIKit

class MyWordViewController: UIViewController {
    
    // MARK: - Properties
    var myWordView: MyWordView!
    var tableView: UITableView!
    var backButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        myWordView.headerView.addBorder(width: 1.0, color: .white, position: .bottom)
        myWordView.headerView.addBorder(width: 1.0, color: .white, position: .left)
        myWordView.headerView.addBorder(width: 1.0, color: .white, position: .right)
    }
    
    private func configureUI() {
        myWordView = MyWordView()
        tableView = myWordView.tableView
        backButton = myWordView.headerView.backButton
        
        // 配置＆制約の追加
        view.addSubview(myWordView)
        myWordView.addConstraintsToFillView(view)
        
        // ボタンにアクションを追加
        backButton.addTarget(self, action: #selector(backPressed(_ :)), for: .touchUpInside)
        // delegateの設定
        tableView.dataSource = self
    }
    
    @objc private func backPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension MyWordViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.CellID.mine, for: indexPath) as? MyWordTableViewCell
        guard let safeCell = cell else { fatalError() }
        safeCell.wordLabel.text = "word"
        return safeCell
    }
    
}
