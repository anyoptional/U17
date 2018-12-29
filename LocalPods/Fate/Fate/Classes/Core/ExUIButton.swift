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
            let insets = NSValue(uiEdgeInsets: newValue)
            objc_setAssociatedObject(self,
                                     &touchAreaInsetsKey,
                                     insets, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self,
                                             &touchAreaInsetsKey) as? NSValue)?.uiEdgeInsetsValue ?? .zero
        }
    }
    
    /// 调用时UIButton的frame必须是已知的
    public func setTitleAlignment(_ alignment: UIButton.Alignment, withOffset offset: CGFloat = 0) {
        let imageSize = base.imageRect(forContentRect: base.frame)
        guard let titleFont = base.titleLabel?.font else { return }
        guard let titleSize = base.titleLabel?.text?.size(withAttributes: [.font: titleFont]) else { return }
        
        switch alignment {
        case .top:
            base.titleEdgeInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + offset) / 2,
                                                left: -(imageSize.width), bottom: 0, right: 0)
            base.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -(imageSize.height + titleSize.height + offset) / 2, right: -titleSize.width)
            
        case .left:
            base.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            base.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0,
                                                right: -(titleSize.width * 2 + offset))
        case .right:
            base.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -offset)
            base.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
        case .bottom:
            base.titleEdgeInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + offset) / 2,
                                                left: -(imageSize.width), bottom: 0, right: 0)
            base.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: (imageSize.height + titleSize.height + offset) / 2, right: -titleSize.width)
        }
    }
}

extension UIButton {
    
    /// 文字的对齐方式
    public enum Alignment {
        case top
        case left
        case right
        case bottom
    }
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let touchAreaInsets = fate.touchAreaInsets
        var bounds = self.bounds
        bounds = CGRect(x: bounds.minX - touchAreaInsets.left,
                        y: bounds.minY - touchAreaInsets.top,
                        width: bounds.width + touchAreaInsets.left + touchAreaInsets.right,
                        height: bounds.height + touchAreaInsets.top + touchAreaInsets.bottom)
        return bounds.contains(point)
    }
}
