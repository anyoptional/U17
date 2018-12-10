//
//  UIViewController+NavigationBar.swift
//  Fate
//
//  Created by Archer on 2018/12/10.
//

import UIKit

fileprivate var kNavigationBarAssociatedKey: UInt8 = 0
fileprivate var kNavigationItemAssociatedKey: UInt8 = 0

extension Fate where Base: UIViewController {

    /// A navigation bar associated with `UIViewController`
    public var navigationBar: FDNavigationBar {
        get {
            if let navBar = objc_getAssociatedObject(self, &kNavigationBarAssociatedKey) as? FDNavigationBar {
                return navBar
            } else {
                let navBar = FDNavigationBar()
                objc_setAssociatedObject(self, &kNavigationBarAssociatedKey, navBar, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return navBar
            }
        }
    }
    
    /// A navigation item that describes the navigaiton bar
    public var navigationItem: FDNavigationItem {
        get {
            if let navItem = objc_getAssociatedObject(self, &kNavigationItemAssociatedKey) as? FDNavigationItem {
                return navItem
            } else {
                let navItem = FDNavigationItem()
                objc_setAssociatedObject(self, &kNavigationItemAssociatedKey, navItem, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return navItem
            }
        }
    }
}
