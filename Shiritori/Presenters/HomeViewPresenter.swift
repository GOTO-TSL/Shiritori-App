//
//  HomeViewPresenter.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/23.
//

import Foundation

final class HomeViewPresenter {
    
    private var pushPlayer: SoundPlayer!
    
    init() {
        self.pushPlayer = SoundPlayer()
        
    }
    
    func didPushButton() {
        // 効果音を再生
        pushPlayer.playSound(name: Const.Sound.push)
    }
}
