//
//  ImageData.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/04.
//

import Foundation

protocol TimerManagerDelegate: AnyObject {
    func didUpdateTimeBar(_ timerManager: TimerManager, timeNow: Float)
    func didUpdateComment(_ timerManager: TimerManager, comment: String)
    func gameStart(_ timerManager: TimerManager)
    func gotoNextView(_ timerManager: TimerManager)
}

class TimerManager {
    weak var delegate: TimerManagerDelegate?
    var mainTimer = Timer()
    var mainTimerCount = 0
    
    // ゲームの開始から終了までカウントするタイマー
    func gameTimer() {
        mainTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(gameCount), userInfo: nil, repeats: true)
    }

    @objc func gameCount() {
        mainTimerCount += 1
        switch mainTimerCount {
        case 1 ..< Constant.Timer.countDownTime:
            let countNow = "\(Constant.Timer.countDownTime - mainTimerCount)"
            delegate?.didUpdateComment(self, comment: countNow)
            
        case Constant.Timer.countDownTime:
            let countNow = Constant.Comments.start
            delegate?.didUpdateComment(self, comment: countNow)

        case Constant.Timer.countDownTime + 1:
            delegate?.gameStart(self)
            
        case (Constant.Timer.countDownTime + 2) ..< (Constant.Timer.playTime + Constant.Timer.countDownTime + 3):
            let timeNow = 1.0 - Float(mainTimerCount - Constant.Timer.countDownTime - 1) / Float(Constant.Timer.playTime + 1)
            delegate?.didUpdateTimeBar(self, timeNow: timeNow)
            
        case Constant.Timer.playTime + Constant.Timer.countDownTime + 3:
            let countNow = Constant.Comments.end
            delegate?.didUpdateComment(self, comment: countNow)
            
        case Constant.Timer.playTime + Constant.Timer.countDownTime + 4:
            mainTimer.invalidate()
            delegate?.gotoNextView(self)
            
        default:
            let countNow = Constant.Comments.wait
            delegate?.didUpdateComment(self, comment: countNow)
        }
    }
    
    func stopTimer() {
        mainTimer.invalidate()
    }
}
