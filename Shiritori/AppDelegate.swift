//
//  AppDelegate.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/03.
//

import UIKit
import RealmSwift
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let defaults = UserDefaults.standard
    var opPlayer = SoundPlayer()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        defaults.set(false, forKey: K.UserDefaultKeys.isMute)
        opPlayer.playSound(name: K.Sounds.op, isMute: false, loop: -1)
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        do {
            _ = try Realm()
        } catch {
            print("Error initialising realm, \(error)")
        }
        
        
        return true
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        defaults.set(true, forKey: K.UserDefaultKeys.firstLaunch)
    }

}

