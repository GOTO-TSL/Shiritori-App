//
//  UIViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/17.
//

import UIKit

extension UIViewController {
    // 画面遷移のアニメーション設定
    func addTransition(duration: Double, type: CATransitionType, subType: CATransitionSubtype) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = type
        transition.subtype = subType
        self.view.window?.layer.add(transition, forKey: kCATransition)
    }
}
