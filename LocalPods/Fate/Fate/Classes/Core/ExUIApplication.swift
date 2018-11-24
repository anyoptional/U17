//
//  ExUIApplication.swift
//  Fate
//
//  Created by Archer on 2018/11/23.
//

import UIKit

public func UIApplicationAdjustStatusBarBackgroundColor(_ color: UIColor) {
    if let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as? UIView,
        let statusBar = statusBarWindow.value(forKey: "statusBar") as? UIView {
        statusBar.backgroundColor = color
    }
}
