//
//  ImageManager.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/30.
//

import Foundation
import UIKit

protocol ImageManagerDelegate {
    func didUpdateResult(isHappy: Bool, modeIndex: Int)
}

struct ImageManager {
    
    var delegate: ImageManagerDelegate?
    
    //ゲームの結果に応じてresult画面の画像を変更
    func changeResultImage(gamescore: Int, mode: String) {
        if mode == "EASY" {
            if gamescore >= 50 {
                self.delegate?.didUpdateResult(isHappy: true, modeIndex: 0)
            } else {
                self.delegate?.didUpdateResult(isHappy: false, modeIndex: 0)
            }
        } else if mode == "NORMAL" {
            if gamescore >= 100 {
                self.delegate?.didUpdateResult(isHappy: true, modeIndex: 1)
            } else {
                self.delegate?.didUpdateResult(isHappy: false, modeIndex: 1)
            }
        } else {
            if gamescore >= 200 {
                self.delegate?.didUpdateResult(isHappy: true, modeIndex: 2)
            } else {
                self.delegate?.didUpdateResult(isHappy: false, modeIndex: 2)
            }
        }
    }
    
    func imageAnimation(for imageView: UIImageView, mode: String) {
        imageView.animationImages = animationImages(for: mode)
        imageView.animationDuration = 1.0
        imageView.animationRepeatCount = 0
        imageView.image = imageView.animationImages?.first
        imageView.startAnimating()
    }
    
    func animationImages(for name: String) -> [UIImage] {
        var i = 0
        var images = [UIImage]()
        
        while let image = UIImage(named: "\(name)\(i)") {
            images.append(image)
            i += 1
        }
        return images
    }
    
}
