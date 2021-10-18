//
//  ResultViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/17.
//

import UIKit

class ResultViewController: UIViewController {
    
    // MARK: - Properties
    var resultView: ResultView!
    var homeButton: UIButton!
    var wordButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        
    }
    
    private func configureUI() {
        resultView = ResultView()
        homeButton = resultView.buttons.homeButton
        wordButton = resultView.buttons.wordButton
        
        // 配置＆制約
        view.addSubview(resultView)
        resultView.addConstraintsToFillView(view)
        
        // 各ボタンにアクションを追加
        homeButton.addTarget(self, action: #selector(homePressed(_:)), for: .touchUpInside)
        wordButton.addTarget(self, action: #selector(wordPressed(_:)), for: .touchUpInside)
    }
    
    @objc private func homePressed(_ sender: UIButton) {
        // ホーム画面に遷移
        let homeVC = HomeViewController()
        homeVC.modalPresentationStyle = .fullScreen
        addTransition(duration: 0.3, type: .fade, subType: .fromRight)
        present(homeVC, animated: false, completion: nil)
    }
    
    @objc private func wordPressed(_ sender: UIButton) {
        // 使用した単語一覧画面に遷移
        let usedWordVC = UsedWordViewController()
        usedWordVC.modalPresentationStyle = .fullScreen
        addTransition(duration: 0.3, type: .moveIn, subType: .fromBottom)
        present(usedWordVC, animated: false, completion: nil)
    }
}
