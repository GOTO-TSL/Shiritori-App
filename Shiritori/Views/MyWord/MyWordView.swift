//
//  MyWordView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/17.
//

import UIKit
import SwiftUI

class MyWordView: UIView {
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
    
    let editButton: UIButton = {
        let editButton = UIButton()
        editButton.setImage(UIImage(named: Const.Image.like), for: .normal)
        editButton.imageView?.contentMode = .scaleAspectFit
        return editButton
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        headerView.titleLabel.text = Const.TitleText.myWords
        tableView.register(MyWordTableViewCell.self, forCellReuseIdentifier: Const.CellID.mine)
        
        let stack = UIStackView(arrangedSubviews: [headerView, tableView])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        
        addSubview(stack)
        addSubview(editButton)
        
        stack.addConstraintsToFillView(self)
        stack.divide(by: [1, 7.5], baseHeight: heightAnchor)
        editButton.centerY(inView: headerView, constant: 10)
        editButton.anchor(right: rightAnchor, paddingRight: 15, width: 50)
        editButton.setAspectRatio(ratio: 1)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
