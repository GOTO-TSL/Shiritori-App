//
//  ModeSelectView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/12.
//

import UIKit

class ModeSelectView: UIView {
    // MARK: - Properties
    let modeButtonView: ModeButtonView = {
        let view = ModeButtonView()
        return view
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let title = UILabel()
        title.text = Const.TitleText.mode
        title.font = UIFont(name: Const.font, size: 45)
        title.textColor = .black
        
        backgroundColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 0.7)
        
        addSubview(modeButtonView)
        addSubview(title)
        
        title.centerX(inView: self)
        title.anchor(bottom: modeButtonView.topAnchor, paddingBottom: 30)
        modeButtonView.centerX(inView: self)
        modeButtonView.centerY(inView: self, constant: 20)
        modeButtonView.anchor(left: leftAnchor, right: rightAnchor, paddingTop: 30, paddingLeft: 30, paddingRight: 30)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
