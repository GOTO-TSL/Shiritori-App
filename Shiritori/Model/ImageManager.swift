//
//  ImageManager.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/30.
//

import Foundation
import UIKit

struct ImageManager {
    
    let easyFaceImages = [#imageLiteral(resourceName: "normal2"), #imageLiteral(resourceName: "smile2"), #imageLiteral(resourceName: "confuse2")]
    let normalFaceImages = [#imageLiteral(resourceName: "normal1"), #imageLiteral(resourceName: "smile1"), #imageLiteral(resourceName: "confuse1")]
    let hardFaceImages = [#imageLiteral(resourceName: "normal3"), #imageLiteral(resourceName: "smile3"), #imageLiteral(resourceName: "confuse3")]
    let lifeImages = [#imageLiteral(resourceName: "blankheart"), #imageLiteral(resourceName: "halfblankheart"), #imageLiteral(resourceName: "heart")]
    let happyEndImages = [#imageLiteral(resourceName: "happyEndRight2"), #imageLiteral(resourceName: "happyEndRight1"), #imageLiteral(resourceName: "happyEndRight3")]
    let badEndImages = [#imageLiteral(resourceName: "badEndRight2"), #imageLiteral(resourceName: "badEndRight1"), #imageLiteral(resourceName: "badEndRight3")]
    let playerImages = [#imageLiteral(resourceName: "happyEndLeft"), #imageLiteral(resourceName: "badEndLeft")]
    


    
    func changeFace(face: UIImageView, mode: String, feeling: String) {
        if let k = K.feeling[feeling] {
            switch mode {
            case "EASY":
                face.image = self.easyFaceImages[k]
            case "NORMAL":
                face.image = self.normalFaceImages[k]
            case "HARD":
                face.image = self.hardFaceImages[k]
            default:
                face.image = self.normalFaceImages[k]
            }
        }
    }
    
    func changeFriendShip(heartStack: UIStackView, gamescore: Int, mode: String) {
        if mode == "EASY" {
            let index = gamescore/10 - 1
            print("gamescore:\(gamescore), index:\(index)")
            if gamescore < 50 && gamescore > 0 {
                for i in 0...4 {
                    if let easylife = heartStack.arrangedSubviews[i] as? UIImageView {
                        easylife.image = self.lifeImages[0]
                    }
                }
                for i in 0...index {
                    if let easylife = heartStack.arrangedSubviews[i] as? UIImageView {
                        easylife.image = self.lifeImages[2]
                    }
                }
            } else if gamescore >= 50 {
                for i in 0...4 {
                    if let easylife = heartStack.arrangedSubviews[i] as? UIImageView {
                        easylife.image = self.lifeImages[2]
                    }
                }
            } else {
                for i in 0...4 {
                    if let easylife = heartStack.arrangedSubviews[i] as? UIImageView {
                        easylife.image = self.lifeImages[0]
                    }
                }
            }
        }
    }
}
