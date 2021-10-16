//
//  MyWordTableViewCell.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/17.
//

import UIKit

class MyWordTableViewCell: UITableViewCell {
    
    let wordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Const.font, size: 35)
        label.textColor = .white
        return label
    }()
    
    let heartImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Const.Image.next)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.white.cgColor
        backgroundColor = .black
        addSubview(wordLabel)
        addSubview(heartImage)
        
        wordLabel.centerY(inView: self)
        wordLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 10)
        heartImage.centerY(inView: self)
        heartImage.anchor(width: 40)
        heartImage.anchor(right: rightAnchor, paddingRight: 10)
        heartImage.setAspectRatio(ratio: 1)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
