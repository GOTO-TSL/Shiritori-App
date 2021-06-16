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
        meanLabel.text = stringReshape(for: mean)
    }
    
    func stringReshape(for string: String?) -> String {
        guard let str = string else { return "" }
        if str.contains("/") {
            let stringArray = str.split(separator: "/")
            var newstring = ""
            for word in stringArray {
                newstring += ("\n" + word)
            }
            return newstring
        } else {
            return str
        }
    }
    

}
