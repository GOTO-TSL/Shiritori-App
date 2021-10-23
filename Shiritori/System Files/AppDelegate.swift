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
    // var opPlayer = SoundPlayer()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //defaults.set(false, forKey: Constant.UserDefaultKeys.isMute)
        //opPlayer.playSound(name: Constant.Sounds.opening, isMute: false, loop: -1)
        
        return true
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        //defaults.set(true, forKey: Constant.UserDefaultKeys.firstLaunch)
    }
}
