//
//  ImageManager.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/30.
//

import Foundation
import UIKit


struct ImageManager {
    
    func imageAnimation(for imageView: UIImageView, mode: String, action: String, duration: Double) {
        imageView.animationImages = animationImages(for: "\(mode)\(action)")
        imageView.animationDuration = duration
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
