//
//  AppDelegate.swift
//  movie
//
//  Created by Jan Sebastian on 27/04/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        
        let vc = UINavigationController(rootViewController: HomeViewController())
        vc.navigationBar.isHidden = true
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        
        
        return true
    }


}

