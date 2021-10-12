//
//  ModeSelectView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/12.
//

import UIKit

class ModeSelectView: UIView {
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "brank"), for: .normal)
        button.setTitle("back", for: .normal)
        button.titleLabel?.font = UIFont(name: Const.font, size: 10)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Const.Title.mode
        label.font = UIFont(name: Const.font, size: 45)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let backgroundImage = UIImage(named: "background128")
        let bgImageView = UIImageView(image: backgroundImage)
        bgImageView.contentMode = .scaleAspectFill
        
        let modeButtonView = ModeButtonView()
        
        addSubview(bgImageView)
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(modeButtonView)
        
        bgImageView.addConstraintsToFillView(self)
        backButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 30, paddingLeft: 30)
        titleLabel.centerX(inView: self)
        titleLabel.anchor(top: backButton.bottomAnchor, paddingTop: 20)
        modeButtonView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 40, paddingLeft: 20, paddingBottom: 40, paddingRight: 20)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
