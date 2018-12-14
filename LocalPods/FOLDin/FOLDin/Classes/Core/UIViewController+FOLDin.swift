//
//  UIViewController+FOLDin.swift
//  FOLDin
//
//  Created by Archer on 2018/12/11.
//

import UIKit

/// Navigation bar style list
@objc public enum UINavigationBarStyle: Int {
    // System UINavigationBar, nothing changed
    case system = 0
    // Use FDNavigationBar instead of UINavigationBar,
    // if this returned, system's navigation bar will be hide
    case custom = 1
}

/// A protocol that determine use system navigation bar or not
@objc public protocol UINavigationBarStyleCustomizable {
    
    /// A navigation bar style which you'd like to use
    var prefersNavigationBarStyle: UINavigationBarStyle { get }
}

// MARK: - We all know that navigation bar is presented by `UIViewController`
// although `UINavigationContrller` truly own it, we made 'UIViewController'
// conform the protocol and return UINavigationBarStyleSystem by default.
extension UIViewController: UINavigationBarStyleCustomizable {
    
    /// Subclass can override this property to determine their own style
    open var prefersNavigationBarStyle: UINavigationBarStyle {
        return .system
    }
}

/// A wrapper that around `fd_` properties.
extension FOLDin where Base: UIViewController {
    
    /// The navigation bar managed by the view controller.
    public var navigationBar: FDNavigationBar {
        get {
            return base._namespace_navigationBar
        }
    }
    
    /// The navigation item used to represent the view controller's navigation bar.
    public var navigationItem: FDNavigationItem {
        get {
            return base._namespace_navigationItem
        }
    }
    
    /// Shortcut for `fd.navigationBar.frame.maxY`,
    /// helps to layout UI element.
    public var fullNavbarHeight: CGFloat {
        get {
            return base._namespace_fullNavbarHeight
        }
    }
    
    /// Hides system navigation bar when use FDNavigationBar, YES by default.
    /// NOTE: We hides system navigation bar in viewWillAppear method, so you
    /// should set thid property in before viewWillAppear.
    public var hidesSystemNavigationBar: Bool {
        get { return base._namespace_hidesSystemNavigationBar }
        set { base._namespace_hidesSystemNavigationBar = newValue }
    }
}
