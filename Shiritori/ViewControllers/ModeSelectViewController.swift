//
//  ModeSelectViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/17.
//

import UIKit

class ModeSelectViewController: UIViewController {
    // MARK: - Properties
    var modeSelectView: ModeSelectView!
    var backButton: UIButton!
    var easyButton: UIButton!
    var normalButton: UIButton!
    var hardButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    private func configureUI() {
        modeSelectView = ModeSelectView()
        backButton = modeSelectView.backButton
        easyButton = modeSelectView.modeButtons.easyButton
        normalButton = modeSelectView.modeButtons.normalButton
        hardButton = modeSelectView.modeButtons.hardButton
        
        // 配置＆制約の追加
        view.addSubview(modeSelectView)
        modeSelectView.addConstraintsToFillView(view)
        
        // 各ボタンにアクションを追加
        backButton.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)
    }
    
    @objc private func backPressed(_ sender: UIButton) {
        addTransition(duration: 0.2, type: .push, subType: .fromLeft)
        dismiss(animated: false, completion: nil)
    }

}
