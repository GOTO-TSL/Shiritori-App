//
//  ModeSelectViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/17.
//

import UIKit

class ModeSelectViewController: UIViewController {
    
    var modeSelectView: ModeSelectView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    private func configureUI() {
        modeSelectView = ModeSelectView()
        view.addSubview(modeSelectView)
        
        modeSelectView.addConstraintsToFillView(view)
    }

}
