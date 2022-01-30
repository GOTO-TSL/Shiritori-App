//
//  GeneralGameView.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/12/20.
//

import UIKit

// 通常プレイモード -> View HPバーを追加で配置
// チャレンジモード -> countLabelを追加で配置
class GeneralGameView: GameView {
    // MARK: - Properties
    let hpView: HPView = {
        let view = HPView()
        return view
    }()
    
    let shiritoriCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: Const.font, size: 20)
        label.text = "\(0) COMBO"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let mode: Mode = UserDefaults.standard.getEnum(forKey: Const.UDKeys.currentMode)!
        if mode == .challenge {
            addSubview(shiritoriCountLabel)
            
            shiritoriCountLabel.anchor(bottom: enemyView.topAnchor, right: rightAnchor, paddingBottom: 20, paddingRight: 20)
        } else {
            addSubview(hpView)
            
            hpView.anchor(left: speechView.rightAnchor, bottom: speechView.topAnchor, right: rightAnchor, paddingLeft: -25, paddingBottom: -20, paddingRight: 10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
