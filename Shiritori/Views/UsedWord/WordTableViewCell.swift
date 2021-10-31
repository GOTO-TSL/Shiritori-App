//
//  WordTableViewCell.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/16.
//

import UIKit

class WordTableViewCell: UITableViewCell {
    
    let wordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Const.font, size: 35)
        label.textColor = .white
        return label
    }()
    
    let heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Const.Image.unlike), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.white.cgColor
        backgroundColor = .black
        contentView.addSubview(wordLabel)
        contentView.addSubview(heartButton)
        
        wordLabel.centerY(inView: contentView)
        wordLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 10)
        heartButton.centerY(inView: contentView)
        heartButton.anchor(width: 50)
        heartButton.anchor(right: contentView.rightAnchor, paddingRight: 10)
        heartButton.setAspectRatio(ratio: 1)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
