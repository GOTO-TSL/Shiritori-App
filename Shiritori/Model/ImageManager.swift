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
    func didUpdateHeart(end: Int, row: Int, isHalf: Bool)
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
                self.delegate?.didUpdateHeart(end: index, row: 0, isHalf: false)
            } else if gamescore >= 50 {
                self.delegate?.gotoResultView()
            } else {
                self.delegate?.didUpdateHeart(end: -1, row: 0, isHalf: false)
            }
        } else if mode == "NORMAL" {
            var index = gamescore/10 - 1
            print("gamescore:\(gamescore), index:\(index)")
            switch gamescore {
            case 0..<50:
                self.delegate?.didUpdateHeart(end: index, row: 0, isHalf: false)
                
            case 50:
                self.delegate?.didUpdateHeart(end: -1, row: 1, isHalf: false)
                self.delegate?.didUpdateHeart(end: index, row: 0, isHalf: false)
                
            case 60..<100:
                index -= 5
                self.delegate?.didUpdateHeart(end: index, row: 1, isHalf: false)
                
            case 100:
                self.delegate?.gotoResultView()
                
            default:
                self.delegate?.didUpdateHeart(end: -1, row: 0, isHalf: false)
                self.delegate?.didUpdateHeart(end: -1, row: 1, isHalf: false)
            }
        } else {
            print("gamescore:\(gamescore)")
            switch gamescore {
            case 0:
                self.delegate?.didUpdateHeart(end: -1, row: 0, isHalf: false)
            
            case 10..<100:
                if (gamescore/10) % 2 == 0 {
                    let index = gamescore/20 - 1
                    self.delegate?.didUpdateHeart(end: index, row: 0, isHalf: false)
                } else {
                    let index = (gamescore/10)/2
                    self.delegate?.didUpdateHeart(end: index, row: 0, isHalf: true)
                }
            
            case 100:
                self.delegate?.didUpdateHeart(end: -1, row: 1, isHalf: false)
                self.delegate?.didUpdateHeart(end: 4, row: 0, isHalf: false)
            
            case 110...190:
                if (gamescore/10) % 2 == 0 {
                    let index = gamescore/20 - 6
                    self.delegate?.didUpdateHeart(end: index, row: 1, isHalf: false)
                } else {
                    let index = ((gamescore - 100)/10)/2
                    self.delegate?.didUpdateHeart(end: index, row: 1, isHalf: true)
                }
                
            case 200:
                self.delegate?.gotoResultView()
            
            default:
                self.delegate?.didUpdateHeart(end: -1, row: 0, isHalf: false)
                self.delegate?.didUpdateHeart(end: -1, row: 1, isHalf: false)
                
            }
        }
    }
}
