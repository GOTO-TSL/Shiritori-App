//
//  SelectGameViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/30.
//

import UIKit

class SelectGameViewController: UIViewController {
    var mode = ""
    
    @IBOutlet weak var EasyButton: UIButton!
    @IBOutlet weak var NormalButton: UIButton!
    @IBOutlet weak var HardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EasyButton.layer.cornerRadius = 20.0
        NormalButton.layer.cornerRadius = 20.0
        HardButton.layer.cornerRadius = 20.0
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
