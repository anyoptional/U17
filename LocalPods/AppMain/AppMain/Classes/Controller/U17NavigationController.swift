//
//  U17NavigationController.swift
//  AppMain
//
//  Created by Archer on 2018/11/20.
//

import UIKit

final class U17NavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            interactivePopGestureRecognizer?.delegate = nil
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
}
