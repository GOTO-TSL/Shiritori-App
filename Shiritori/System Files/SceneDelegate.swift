//
//  SceneDelegate.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/03.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard (scene as? UIWindowScene) != nil else { return }
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
//            let nav = UINavigationController(rootViewController: HomeViewController())
//            window.rootViewController = nav
            window.rootViewController = HomeViewController.init()
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
