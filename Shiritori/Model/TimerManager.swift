//
//  ImageData.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/04.
//

import Foundation
import UIKit

class TimerManager {
    let commentLabel: UILabel
    let timeBar: UIProgressView
    var timer = Timer()
    var timerCount = 0
    
    init(commentLabel: UILabel, timeBar: UIProgressView) {
        self.commentLabel = commentLabel
        self.timeBar = timeBar
    }
    
    func countdownTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.startCount), userInfo: nil, repeats: true)
    }
    
    func gameTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.gameCount), userInfo: nil, repeats: true)
    }
    
    @objc func startCount() {
        timerCount += 1
        if timerCount != K.Timer.countDownTime {
            self.commentLabel.text = "\(K.Timer.countDownTime - timerCount)"
        } else {
            self.commentLabel.text = "START!"
            timerCount = 0
            timer.invalidate()
        }
    }
    
    @objc func gameCount() {
        timerCount += 1
        self.timeBar.progress = 1.0 - Float(timerCount)/Float(K.Timer.playTime+1)
        
        if timerCount == K.Timer.playTime + 1 {
            self.commentLabel.text = "Time's Up!"
            timerCount = 0
            timer.invalidate()
        }
    }
    
//    @objc func changeComment() {
//        timerCount += 1
//        switch timerCount {
//        case 1..<K.Timer.countDownTime:
//            self.commentLabel.text = "\(K.Timer.countDownTime - timerCount)"
//        case K.Timer.countDownTime:
//            self.commentLabel.text = "START!"
//        case (K.Timer.countDownTime)...(K.Timer.playTime+K.Timer.countDownTime+1):
//            self.timeBar.progress = 1.0 - Float(timerCount - K.Timer.countDownTime)/Float(K.Timer.playTime+1)
//        case K.Timer.playTime+K.Timer.countDownTime+2:
//            self.commentLabel.text = "Time's Up!"
//            timer.invalidate()
//        default:
//            self.commentLabel.text = "..."
//        }
//    }
}

