//
//  SelectGameViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/30.
//

import UIKit

class SelectGameViewController: UIViewController {
    var mode = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func modeSelected(_ sender: UIButton) {
        mode = sender.currentTitle!
        self.performSegue(withIdentifier: K.SegueID.toplay, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SegueID.toplay {
            let destinationVC = segue.destination as! PlayViewController
            destinationVC.playmode = mode
        }
    }
}
