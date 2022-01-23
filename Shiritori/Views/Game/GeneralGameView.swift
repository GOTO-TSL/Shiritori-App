//
//  GeneralGameView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/12/20.
//

import UIKit

// 通常プレイモードのView HPバーを追加で配置
class GeneralGameView: GameView {
    // MARK: - Properties
    let hpView: HPView = {
        let view = HPView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(hpView)
        
        hpView.anchor(left: speechView.rightAnchor, bottom: speechView.topAnchor, right: rightAnchor, paddingLeft: -25, paddingBottom: -20, paddingRight: 10)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
