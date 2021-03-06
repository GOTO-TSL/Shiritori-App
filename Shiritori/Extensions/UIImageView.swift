//
//  UIImageView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/23.
//

import UIKit

extension UIImageView {
    func animation(action: String, duration: Double) {
        let mode: Mode = UserDefaults.standard.getEnum(forKey: Const.UDKeys.currentMode)!
        animationImages = animationImages(for: "\(mode)/\(action)")
        animationDuration = duration
        animationRepeatCount = 0
        image = animationImages?.first
        startAnimating()
    }
    
    private func animationImages(for name: String) -> [UIImage] {
        var count = 0
        var images = [UIImage]()
        
        while let image = UIImage(named: "\(name)\(count)") {
            images.append(image)
            count += 1
        }
        return images
    }
}
