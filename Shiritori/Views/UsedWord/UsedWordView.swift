//
//  UsedWordView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/16.
//

import UIKit

class UsedWordView: UIView {
    // MARK: - Properties
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        return tableView
    }()
    
    let headerView: HeaderView = {
        let headerView = HeaderView()
        return headerView
    }()
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        headerView.titleLabel.text = Const.TitleText.words
        tableView.register(WordTableViewCell.self, forCellReuseIdentifier: Const.CellID.used)
        
        let stack = UIStackView(arrangedSubviews: [headerView, tableView])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        
        addSubview(stack)
        
        stack.addConstraintsToFillView(self)
        stack.divide(by: [1, 7.5], baseHeight: heightAnchor)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
