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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
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

}
