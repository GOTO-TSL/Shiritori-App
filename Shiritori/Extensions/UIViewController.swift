//
//  UIViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/17.
//

import UIKit

enum Operation {
    case play
    case stop
    case mute
}

extension UIViewController {
    // 画面遷移のアニメーション設定
    func addTransition(duration: Double, type: CATransitionType, subType: CATransitionSubtype) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = type
        transition.subtype = subType
        self.view.window?.layer.add(transition, forKey: kCATransition)
    }
    
    func opening(operation: Operation) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        switch operation {
        case .play:
            appDelegate.opening.playSound(loop: -1)
        case .stop:
            appDelegate.opening.stop()
        case .mute:
            appDelegate.opening.changeVolume()
        }
    }
    
    func removeSubViews() {
        let subviews = self.view.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}
