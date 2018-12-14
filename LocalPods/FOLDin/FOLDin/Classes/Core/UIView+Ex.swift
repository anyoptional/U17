//
//  UIView+Ex.swift
//  FOLDin
//
//  Created by Archer on 2018/12/14.
//  Copyright © 2018年 Archer. All rights reserved.
//

import UIKit

extension UIView {
    var viewController: UIViewController? {
        get {
            var view: UIView? = self
            while let wrappedView = view {
                if let nextResponder = wrappedView.next {
                    if nextResponder is UIViewController {
                        return nextResponder as? UIViewController
                    }
                }
                view = wrappedView.superview
            }
            return nil
        }
    }
    
    var left: CGFloat {
        get { return frame.origin.x }
        set { frame.origin.x = newValue }
    }
    
    var top: CGFloat {
        get { return frame.origin.y }
        set { frame.origin.y = newValue }
    }
    
    var right: CGFloat {
        get { return frame.origin.x + frame.size.width }
        set { frame.origin.x = newValue - frame.size.width }
    }
    
    var bottom: CGFloat {
        get { return frame.origin.y + frame.size.height }
        set { frame.origin.y = newValue - frame.size.height }
    }

    var width: CGFloat {
        get { return frame.size.width }
        set { frame.size.width = newValue }
    }
    
    var height: CGFloat {
        get { return frame.size.height }
        set { frame.size.height = newValue }
    }
    
    var centerX: CGFloat {
        get { return center.x }
        set { center = CGPoint(x: newValue, y: center.y) }
    }
    
    var centerY: CGFloat {
        get { return center.y }
        set { center = CGPoint(x: center.x, y: newValue) }
    }
    
    var origin: CGPoint {
        get { return frame.origin }
        set { frame.origin = newValue }
    }
    
    var size: CGSize {
        get { return frame.size }
        set { frame.size = newValue }
    }
}
