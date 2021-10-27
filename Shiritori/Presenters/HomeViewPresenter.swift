//
//  HomeViewPresenter.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/23.
//

import Foundation

final class HomeViewPresenter {
    
    private var pushSound: SoundPlayer!
    
    init() {
        self.pushSound = SoundPlayer(name: Const.Sound.push)
        
    }
    deinit {
        print("home Presenter deinit")
    }
    
    func didPushButton() {
        // 効果音を再生
        pushSound.playSound()
    }
}
