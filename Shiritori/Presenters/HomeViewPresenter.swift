//
//  HomeViewPresenter.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/23.
//

import Foundation

final class HomeViewPresenter {
    // MARK: - Properties
    private var pushSound: SoundPlayer!
    
    // MARK: - Lifecycle
    init() {
        self.pushSound = SoundPlayer(name: Const.Sound.push)
        
    }
    // MARK: - HomeViewPresenter Methods
    func didPushButton() {
        // 効果音を再生
        pushSound.playSound()
    }
}
