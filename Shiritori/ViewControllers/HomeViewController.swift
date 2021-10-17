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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    private func configureUI() {
        homeView = HomeView()
        playButton = homeView.middleButtons.playButton
        wordButton = homeView.middleButtons.wordButton
        
        view.addSubview(homeView)
        homeView.addConstraintsToFillView(view)
    }

}
