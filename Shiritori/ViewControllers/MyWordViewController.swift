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
        tableView.delegate = self
    }
    
    @objc private func backPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource Methods
extension MyWordViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.CellID.mine, for: indexPath) as? MyWordTableViewCell
        guard let safeCell = cell else { fatalError() }
        safeCell.selectionStyle = .none
        safeCell.wordLabel.text = "word"
        return safeCell
    }
}

// MARK: - UITableViewDelegate Methods
extension MyWordViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = WordDetailViewController()
        detailVC.modalPresentationStyle = .fullScreen
        addTransition(duration: 0.3, type: .push, subType: .fromRight)
        present(detailVC, animated: false, completion: nil)
    }
}
