//
//  RuleViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/17.
//

import UIKit

class RuleViewController: UIViewController {
    
    // MARK: - Properties
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
        let ruleView = RuleView()
        ruleView.headerView.addBorder(width: 1.0, color: .white, position: .bottom)
        ruleView.headerView.addBorder(width: 1.0, color: .white, position: .left)
        ruleView.headerView.addBorder(width: 1.0, color: .white, position: .right)
    }
    
    private func configureUI() {
        let ruleView = RuleView()
        backButton = ruleView.headerView.backButton
        
        // 配置＆制約の追加
        view.addSubview(ruleView)
        ruleView.addConstraintsToFillView(view)
        
        // ボタンにアクションを追加
        backButton.addTarget(self, action: #selector(backPressed(_ :)), for: .touchUpInside)
    }
    
    @objc private func backPressed(_ sender: UIButton) {
        addTransition(duration: 0.3, type: .fade, subType: .fromLeft)
        dismiss(animated: false, completion: nil)
    }
}
