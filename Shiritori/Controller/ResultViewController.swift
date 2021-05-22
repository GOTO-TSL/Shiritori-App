//
//  ResultViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/04.
//

import UIKit

class ResultViewController: UIViewController {
    
    var score: Int?
    
    @IBOutlet weak var ScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScoreLabel.text = "SCORE: \(score ?? 0)"
    }

}
