//
//  HomeViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/10.
//

import UIKit

class HomeViewController: UIViewController {
    
    var homeView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    private func configureUI() {
        homeView = RankingView()
        view.addSubview(homeView)
        homeView.addConstraintsToFillView(view)
    }

}
