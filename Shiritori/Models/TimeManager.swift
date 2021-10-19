//
//  TimeManager.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/19.
//

import Foundation

protocol TimeManagerDelegate: AnyObject {
    func didFirstCount(_ timeManager: TimeManager, count: Int)
    func didGameCount(_ timeManager: TimeManager, count: Int)
}

final class TimeManager {
    
    weak var delegate: TimeManagerDelegate?
    var timer: Timer = Timer()
    var counter: Int = 0
    
    // カウントダウン用タイマーメソッド
    func firstCount() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countThree), userInfo: nil, repeats: true)
    }
    // ゲームの制限時間用タイマーメソッド
    func gameCount() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countSixty), userInfo: nil, repeats: true)
    }
    // ゲームスタート前の３秒のカウントダウン
    @objc func countThree() {
        if counter <= 2 {
            self.delegate?.didFirstCount(self, count: counter)
        } else {
            timer.invalidate()
            self.delegate?.didFirstCount(self, count: counter)
            counter = 0
        }
        counter += 1
    }
    // ゲームの制限時間60秒をカウント
    @objc func countSixty() {
        if counter <= 60 {
            self.delegate?.didGameCount(self, count: counter)
        } else {
            timer.invalidate()
            self.delegate?.didGameCount(self, count: counter)
            counter = 0
        }
        counter += 1
    }
    
}
