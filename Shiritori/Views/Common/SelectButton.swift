//
//  SelectButton.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/15.
//

import UIKit

class SelectButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel?.font = UIFont(name: Const.font, size: 45)
        setBackgroundImage(UIImage(named: Const.Image.buttonFrame), for: .normal)
        setAspectRatio(ratio: 16/7)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
