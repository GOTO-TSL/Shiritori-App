//
//  Constant.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/30.
//

import Foundation
import UIKit

struct K {
    
    static let alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    static let feeling = ["normal": 0, "laugh": 1, "confuse": 2]
    
    struct SegueID {
        static let toresult = "toResult"
        static let toplay = "toPlay"
    }
    struct Timer {
        static let playTime: Int = 100
        static let countDownTime: Int = 4
    }
    
    struct Images {
        static let easyFace = [#imageLiteral(resourceName: "normal2"), #imageLiteral(resourceName: "smile2"), #imageLiteral(resourceName: "confuse2")]
        static let normalFace = [#imageLiteral(resourceName: "normal1"), #imageLiteral(resourceName: "smile1"), #imageLiteral(resourceName: "confuse1")]
        static let hardFace = [#imageLiteral(resourceName: "normal3"), #imageLiteral(resourceName: "smile3"), #imageLiteral(resourceName: "confuse3")]
        static let hearts = [#imageLiteral(resourceName: "blankheart"), #imageLiteral(resourceName: "halfblankheart"), #imageLiteral(resourceName: "heart")]
        static let happyEnd = [#imageLiteral(resourceName: "happyEndRight2"), #imageLiteral(resourceName: "happyEndRight1"), #imageLiteral(resourceName: "happyEndRight3")]
        static let badEnd = [#imageLiteral(resourceName: "badEndRight2"), #imageLiteral(resourceName: "badEndRight1"), #imageLiteral(resourceName: "badEndRight3")]
        static let playerEnd = [#imageLiteral(resourceName: "happyEndLeft"), #imageLiteral(resourceName: "badEndLeft")]
    }

}
