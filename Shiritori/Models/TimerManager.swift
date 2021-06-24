//
//  ImageData.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/04.
//

import Foundation
import UIKit

protocol TimerManagerDelegate {
    func didUpdateTimeBar(timeNow: Float)
    func didUpdateComment(comment: String)
    func gameStart()
    func gotoNextView()
}

class TimerManager {
    var delegate: TimerManagerDelegate?
    var mainTimer = Timer()
    var mainTimerCount = 0
    
    //ゲームの開始から終了までカウントするタイマー
    func gameTimer() {
        mainTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.gameCount), userInfo: nil, repeats: true)
    }

    @objc func gameCount() {
        mainTimerCount += 1
        switch mainTimerCount {
        case 1..<K.Timer.countDownTime:
            let countNow = "\(K.Timer.countDownTime - mainTimerCount)"
            self.delegate?.didUpdateComment(comment: countNow)
            
        case K.Timer.countDownTime:
            let countNow = "START!"
            self.delegate?.didUpdateComment(comment: countNow)

        case (K.Timer.countDownTime+1):
            self.delegate?.gameStart()
            
        case (K.Timer.countDownTime+2)..<(K.Timer.playTime+K.Timer.countDownTime+3):
            let timeNow = 1.0 - Float(mainTimerCount - K.Timer.countDownTime-1)/Float(K.Timer.playTime+1)
            self.delegate?.didUpdateTimeBar(timeNow: timeNow)
            
        case K.Timer.playTime+K.Timer.countDownTime+3:
            let countNow = "Time's Up!"
            self.delegate?.didUpdateComment(comment: countNow)
            
        case K.Timer.playTime+K.Timer.countDownTime+4:
            mainTimer.invalidate()
            self.delegate?.gotoNextView()
            
        default:
            let countNow = "..."
            self.delegate?.didUpdateComment(comment: countNow)
        }
    }
    
    func stopTimer() {
        mainTimer.invalidate()
    }
}

