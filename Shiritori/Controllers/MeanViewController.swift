//
//  MeanViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/06/10.
//

import UIKit

class MeanViewController: UIViewController {
    
    var word: String?
    var mean: String?

    @IBOutlet weak var myWordLabel: UILabel!
    @IBOutlet weak var meanLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myWordLabel.text = word
        meanLabel.text = mean
    }
    

}
