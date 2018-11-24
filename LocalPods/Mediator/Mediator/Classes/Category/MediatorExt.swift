//
//  MediatorExt.swift
//  Mediator
//
//  Created by Archer on 2018/11/23.
//

import UIKit

/// MARK: 四大组件
public extension Mediator {
    public static func getTodayViewController() -> UIViewController? {
        return perform("getTodayViewController", inClass: "AppTodayTarget", onModule: "AppToday") as? UIViewController
    }
    
    public static func getDiscoverViewController() -> UIViewController? {
        return perform("getDiscoverViewController", inClass: "AppDiscoverTarget", onModule: "AppDiscover") as? UIViewController
    }
    
    public static func getBookshelfViewController() -> UIViewController? {
        return perform("getBookshelfViewController", inClass: "AppBookshelfTarget", onModule: "AppBookshelf") as? UIViewController
    }
    
    public static func getProfileViewController() -> UIViewController? {
        return perform("getProfileViewController", inClass: "AppProfileTarget", onModule: "AppProfile") as? UIViewController
    }
}
