//
//  U17NavigationController.swift
//  AppMain
//
//  Created by Archer on 2018/11/20.
//

import UIKit
import FOLDin

final class U17NavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewControllers.count > 0 {
            // 基础设置
            viewController.hidesBottomBarWhenPushed = true
            interactivePopGestureRecognizer?.delegate = nil
            // 全局默认返回按钮
            if viewController.prefersNavigationBarStyle == .custom {
                // 调整一下外边距
                viewController.fd.navigationBar.contentMargin.left = 4
                let backButton = UIButton()
                backButton.frame = CGRect(origin: .zero, size: CGSize(width: 32, height: 32))
                backButton.setImage(UIImage(nameInBundle: "nav_back_default"), for: .normal)
                backButton.addTarget(self, action: #selector(popViewControllerAnimated), for: .touchUpInside)
                viewController.fd.navigationItem.leftBarButtonItem = FDBarButtonItem(customView: backButton)
            }
        }
        
        // 避免在首页疯狂左滑导致的卡死
        interactivePopGestureRecognizer?.isEnabled = (viewControllers.count > 0)

        super.pushViewController(viewController, animated: animated)
    }
    
}

extension U17NavigationController {
    @objc private func popViewControllerAnimated() {
        popViewController(animated: true)
    }
}
