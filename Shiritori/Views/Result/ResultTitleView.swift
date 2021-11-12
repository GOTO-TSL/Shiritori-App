//
//  ResultTitleView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/15.
//

import UIKit

class ResultTitleView: UIView {
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let title = UILabel()
        title.text = Const.TitleText.resultWin
        title.font = UIFont(name: Const.font, size: 45)
        title.textAlignment = .center
        
        // ゲーム結果に応じてテキストを変更
        let isWin = UserDefaults.standard.bool(forKey: Const.UDKeys.isWin)
        title.text = isWin ? Const.TitleText.resultWin : Const.TitleText.resultLose
        
        addSubview(title)
        
        title.centerX(inView: self)
        title.anchor(bottom: bottomAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
