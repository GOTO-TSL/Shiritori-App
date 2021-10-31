//
//  UIStackView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/11.
//

import Foundation
import UIKit

extension UIStackView {
    func divide(by ratio: [CGFloat], baseHeight: NSLayoutDimension) {
        translatesAutoresizingMaskIntoConstraints = false
        for (view, element) in zip(arrangedSubviews, ratio) {
            view.heightAnchor.constraint(equalTo: baseHeight,
                                         multiplier: element/ratio.reduce(0, +)).isActive = true
        }
    }
}
