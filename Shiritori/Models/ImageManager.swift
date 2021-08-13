//
//  ImageManager.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/30.
//

import UIKit

/// 画像の変更（アニメーション）を管理するモデル
final class ImageManager {
    
    /// 画像のアニメーションを実効する
    /// - Parameters:
    ///   - imageView: 対象の画像
    ///   - mode: 選択中のモード
    ///   - action: アニメーションの種類
    ///   - duration: 動きの速さ
    func imageAnimation(for imageView: UIImageView, mode: String, action: String, duration: Double) {
        imageView.animationImages = animationImages(for: "\(mode)\(action)")
        imageView.animationDuration = duration
        imageView.animationRepeatCount = 0
        imageView.image = imageView.animationImages?.first
        imageView.startAnimating()
    }
    
    /// アニメーションに使用する画像を一つにまとめる
    /// - Parameter name: アニメーションの種類
    /// - Returns: 画像のリスト
    private func animationImages(for name: String) -> [UIImage] {
        var count = 0
        var images = [UIImage]()
        
        while let image = UIImage(named: "\(name)\(count)") {
            images.append(image)
            count += 1
        }
        return images
    }
    
    /// ダメージラベルのアニメーション
    /// - Parameter view: damageView
    func damageAnimation(for view: UIView) {
        view.center.y += 30
        view.alpha = 1.0
        UIView.animate(withDuration: 1.0) {
            view.center.y -= 30
            view.alpha = 0.0
        }
    }
}
