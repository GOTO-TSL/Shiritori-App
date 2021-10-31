//
//  AppDelegate.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/03.
//

import AVFoundation
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let defaults = UserDefaults.standard
    var opening = SoundPlayer(name: Const.Sound.opening)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // set UserDefaults
        defaults.set(false, forKey: Const.UDKeys.isWinEasy)
        defaults.set(false, forKey: Const.UDKeys.isWinNormal)
        defaults.set(false, forKey: Const.UDKeys.isWinHard)
        
        defaults.set(false, forKey: Const.UDKeys.isWin)
        defaults.setEnum(Mode.easy, forKey: Const.UDKeys.currentMode)
        
        defaults.set(false, forKey: Const.UDKeys.isMute)
        opening.playSound(loop: -1)
        
        return true
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        //defaults.set(true, forKey: Constant.UserDefaultKeys.firstLaunch)
    }
}
