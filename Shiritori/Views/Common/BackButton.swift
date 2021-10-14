//
//  BackButton.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/14.
//

import UIKit

class BackButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setImage(UIImage(named: "back_icon"), for: .normal)
        setTitle("back", for: .normal)
        setTitleColor(.black, for: .normal)
        titleLabel?.font = UIFont(name: Const.font, size: 20)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
