//
//  RuleViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/04.
//

import UIKit

class PreRuleViewController: UIViewController {
    @IBOutlet weak var ruleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ruleLabel.text = Constant.Texts.rule
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
