//
//  ExUIButton.swift
//  Fate
//
//  Created by Archer on 2018/11/23.
//

import UIKit

fileprivate var touchAreaInsetsKey: UInt8 = 0

public extension Fate where Base: UIButton {
    /**
     *  Typically, the touch area of an UIButton object is described
     *  by its frame or all point inside its superview's frame, now you
     *  can increase/decrease the touch area by modify this property.
     *  By default is UIEdgeInsetsZero,which means no increase/decrease touch area.
     */
    public var touchAreaInsets: UIEdgeInsets {
        set {
            let insets = NSValue(uiEdgeInsets: newValue);
            objc_setAssociatedObject(self,
                                     &touchAreaInsetsKey,
                                     insets, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        get {
            return (objc_getAssociatedObject(self,
                                             &touchAreaInsetsKey) as? UIEdgeInsets) ?? .zero;
        }
    }
}

extension UIButton {
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let touchAreaInsets = fate.touchAreaInsets;
        var bounds = self.bounds;
        bounds = CGRect(x: bounds.minX - touchAreaInsets.left,
                        y: bounds.minY - touchAreaInsets.top,
                        width: bounds.width + touchAreaInsets.left + touchAreaInsets.right,
                        height: bounds.height + touchAreaInsets.top + touchAreaInsets.bottom);
        return bounds.contains(point);
    }
}
