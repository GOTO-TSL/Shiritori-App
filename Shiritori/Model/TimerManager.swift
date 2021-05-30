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
    let FaceImage = [#imageLiteral(resourceName: "normal1"), #imageLiteral(resourceName: "smile1"), #imageLiteral(resourceName: "confuse1")]
    var timer = Timer()
    var timerCount = 0
    
    init(commentLabel: UILabel, timeBar: UIProgressView) {
        self.commentLabel = commentLabel
        self.timeBar = timeBar
    }
    
    func countdown() {
        timerCount = 0
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.changeComment), userInfo: nil, repeats: true)
    }
    
    @objc func changeComment() {
        timerCount += 1
        switch timerCount {
        case 1..<K.Timer.countDownTime:
            self.commentLabel.text = "\(K.Timer.countDownTime - timerCount)"
        case K.Timer.countDownTime:
            self.commentLabel.text = "START!"
        case (K.Timer.countDownTime)...(K.Timer.playTime+K.Timer.countDownTime+1):
            self.timeBar.progress = 1.0 - Float(timerCount - K.Timer.countDownTime)/Float(K.Timer.playTime+1)
        case K.Timer.playTime+K.Timer.countDownTime+2:
            self.commentLabel.text = "Time's Up!"
            timer.invalidate()
        default:
            self.commentLabel.text = "..."
        }
    }
}

