//
//  AppDelegate.swift
//  U17
//
//  Created by Archer on 2018/11/20.
//  Copyright © 2018年 Archer. All rights reserved.
//

import AppMain
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupIQkeyboardManager()
        setupRootViewController()
        
        /// Check `Pods target -> Development Pods` for more details
        
        return true
    }

}

extension AppDelegate {
    private func setupRootViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = AppMainTarget.rootViewController() 
        window?.makeKeyAndVisible()
    }
}

extension AppDelegate {
    private func setupIQkeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 30
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
    }
}
