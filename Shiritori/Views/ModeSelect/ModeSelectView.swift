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
        button.backgroundColor = .red
        button.setImage(UIImage(named: "brank"), for: .normal)
        button.setTitle("back", for: .normal)
        button.titleLabel?.font = UIFont(name: Const.font, size: 10)
        button.imageView?.setAspectRatio(ratio: 1)
        button.imageView?.anchor(width: 25)
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
        
        let topSpace = UIView()
        let bottomSpace = UIView()
        let mainStack = UIStackView(arrangedSubviews: [topSpace, titleLabel, ModeButtonView(), bottomSpace])
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.distribution = .fill
        
        addSubview(bgImageView)
        addSubview(backButton)
        addSubview(mainStack)
         
        bgImageView.addConstraintsToFillView(self)
        backButton.anchor(width: 50, height: 25)
        backButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 50, paddingLeft: 30)
        mainStack.addConstraintsToFillView(self)
        topSpace.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/6).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/6).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
