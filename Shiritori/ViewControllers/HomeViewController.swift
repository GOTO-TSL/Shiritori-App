//
//  HomeViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/10.
//

import UIKit

class HomeViewController: UIViewController {
    
    var homeView: HomeView!
    var playButton: UIButton!
    var wordButton: UIButton!
    var helpButton: UIButton!
    var rankingButton: UIButton!
    
    var database: DictDataModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        database = DictDataModel()
        database.openDB()
    }
    
    private func configureUI() {
        homeView = HomeView()
        playButton = homeView.middleButtons.playButton
        wordButton = homeView.middleButtons.wordButton
        helpButton = homeView.bottomButtons.helpButton
        rankingButton = homeView.bottomButtons.rankingButton
        
        // 配置＆制約
        view.addSubview(homeView)
        homeView.addConstraintsToFillView(view)
        
        // 各ボタンにアクションを追加
        playButton.addTarget(self, action: #selector(playPressed(_:)), for: .touchUpInside)
        wordButton.addTarget(self, action: #selector(wordPressed(_:)), for: .touchUpInside)
        helpButton.addTarget(self, action: #selector(helpPressed(_:)), for: .touchUpInside)
        rankingButton.addTarget(self, action: #selector(rankingPressed(_:)), for: .touchUpInside)
    }
    
    @objc private func playPressed(_ sender: UIButton) {
        // モードセレクト画面に遷移
        let modeVC = ModeSelectViewController()
        modeVC.modalPresentationStyle = .fullScreen
        addTransition(duration: 0.3, type: .fade, subType: .fromRight)
        present(modeVC, animated: false, completion: nil)
    }
    
    @objc private func wordPressed(_ sender: UIButton) {
        // マイ単語帳画面に遷移
        let mywordVC = MyWordViewController()
        mywordVC.modalPresentationStyle = .fullScreen
        addTransition(duration: 0.3, type: .moveIn, subType: .fromBottom)
        present(mywordVC, animated: false, completion: nil)
    }
    
    @objc private func helpPressed(_ sender: UIButton) {
        // モードセレクト画面に遷移
        let ruleVC = RuleViewController()
        ruleVC.modalPresentationStyle = .fullScreen
        addTransition(duration: 0.3, type: .fade, subType: .fromRight)
        present(ruleVC, animated: false, completion: nil)
    }
    
    @objc private func rankingPressed(_ sender: UIButton) {
        // モードセレクト画面に遷移
        let rankingVC = RankingViewController()
        rankingVC.modalPresentationStyle = .fullScreen
        addTransition(duration: 0.3, type: .fade, subType: .fromRight)
        present(rankingVC, animated: false, completion: nil)
    }

}
