//
//  RuleViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/04.
//

import UIKit

class RuleViewController: UIViewController {

    @IBOutlet weak var RuleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RuleLabel.text = K.Texts.rule
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
