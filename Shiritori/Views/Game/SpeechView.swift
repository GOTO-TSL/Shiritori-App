//
//  SpeechView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/12/19.
//

import UIKit

class SpeechView: UIView {
    // MARK: - Properties
    let speechBalloon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Const.Image.speechballoon)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let wordLabel: UILabel = {
        let label = UILabel()
        label.text = "hello!"
        label.textColor = .white
        label.font = UIFont(name: Const.font, size: 20)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(speechBalloon)
        addSubview(wordLabel)
        
        speechBalloon.addConstraintsToFillView(self)
        wordLabel.center(inView: speechBalloon)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
