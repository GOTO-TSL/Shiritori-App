//
//  RankingViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/17.
//

import UIKit

class RankingViewController: UIViewController {
    
    // MARK: - Properties
    var rankingView: RankingView!
    var backButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // headerに枠線を追加
        rankingView.headerView.addBorder(width: 1.0, color: .white, position: .bottom)
        rankingView.headerView.addBorder(width: 1.0, color: .white, position: .left)
        rankingView.headerView.addBorder(width: 1.0, color: .white, position: .right)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()

    }
    
    private func configureUI() {
        rankingView = RankingView()
        backButton = rankingView.headerView.backButton
        
        // 配置＆制約の追加
        view.addSubview(rankingView)
        rankingView.addConstraintsToFillView(view)
        
        // ボタンにアクションを追加
        backButton.addTarget(self, action: #selector(backPressed(_ :)), for: .touchUpInside)
    }
    
    @objc private func backPressed(_ sender: UIButton) {
        addTransition(duration: 0.3, type: .fade, subType: .fromLeft)
        dismiss(animated: false, completion: nil)
    }
}
