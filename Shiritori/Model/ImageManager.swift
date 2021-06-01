//
//  ImageManager.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/30.
//

import Foundation
import UIKit

protocol ImageManagerDelegate {
    func didUpdateFace(mode: String, index: Int)
    func didUpdateHeart(end: Int)
    func gotoResultView()
}

struct ImageManager {
    
    var delegate: ImageManagerDelegate?

    func changeFace(mode: String, feeling: String) {
        if let k = K.feeling[feeling] {
            self.delegate?.didUpdateFace(mode: mode, index: k)
        }
    }
    
    func changeFriendShip(gamescore: Int, mode: String) {
        if mode == "EASY" {
            let index = gamescore/10 - 1
            print("gamescore:\(gamescore), index:\(index)")
            if (gamescore < 50) && (gamescore >= 0) {
                self.delegate?.didUpdateHeart(end: index)
            } else if gamescore >= 50 {
                self.delegate?.gotoResultView()
            } else {
                self.delegate?.didUpdateHeart(end: 0)
            }
        }
    }
}
