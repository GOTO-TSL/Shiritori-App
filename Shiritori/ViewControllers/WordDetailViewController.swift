//
//  WordDetailViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/17.
//

import UIKit

class WordDetailViewController: UIViewController {
    
    // MARK: - Properties
    var wordDetailView: WordDetailView!
    var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // headerに枠線を追加
        wordDetailView.headerView.addBorder(width: 1.0, color: .white, position: .bottom)
        wordDetailView.headerView.addBorder(width: 1.0, color: .white, position: .left)
        wordDetailView.headerView.addBorder(width: 1.0, color: .white, position: .right)
    }
    
    private func configureUI() {
        wordDetailView = WordDetailView()
        backButton = wordDetailView.headerView.backButton
        
        // 配置＆制約の追加
        view.addSubview(wordDetailView)
        wordDetailView.addConstraintsToFillView(view)
        
        // ボタンにアクションを追加
        backButton.addTarget(self, action: #selector(backPressed(_ :)), for: .touchUpInside)
    }
    
    @objc private func backPressed(_ sender: UIButton) {
        addTransition(duration: 0.2, type: .push, subType: .fromLeft)
        dismiss(animated: false, completion: nil)
    }
    
}
