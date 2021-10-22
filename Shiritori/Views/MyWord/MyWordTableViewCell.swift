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
    
    let nextImage: UIImageView = {
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
        contentView.addSubview(wordLabel)
        contentView.addSubview(nextImage)
        
        wordLabel.centerY(inView: contentView)
        wordLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 10)
        nextImage.centerY(inView: contentView)
        nextImage.anchor(width: 40)
        nextImage.anchor(right: contentView.rightAnchor, paddingRight: 10)
        nextImage.setAspectRatio(ratio: 1)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
