//
//  U17NavigationController.swift
//  AppMain
//
//  Created by Archer on 2018/11/20.
//

import UIKit

final class U17NavigationController: UINavigationController {
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true;
            interactivePopGestureRecognizer?.delegate = nil;
//            let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ico_back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(popViewControllerAnimated));
//            viewController.navigationItem.leftBarButtonItem = leftBarButtonItem;
        }
        
        super.pushViewController(viewController, animated: animated);
    }
    
}
