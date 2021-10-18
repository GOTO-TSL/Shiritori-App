//
//  UsedWordViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/16.
//

import UIKit

class UsedWordViewController: UIViewController {
    
    var usedWordView: MyWordView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        usedWordView.headerView.addBorder(width: 1.0, color: .white, position: .bottom)
        usedWordView.headerView.addBorder(width: 1.0, color: .white, position: .left)
        usedWordView.headerView.addBorder(width: 1.0, color: .white, position: .right)
    }
    
    private func configureUI() {
        usedWordView = MyWordView()
        usedWordView.tableView.dataSource = self
        
        view.addSubview(usedWordView)
        usedWordView.addConstraintsToFillView(view)
    }
}

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
