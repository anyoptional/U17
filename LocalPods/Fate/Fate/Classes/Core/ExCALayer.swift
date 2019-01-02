//
//  ExCALayer.swift
//  Fate
//
//  Created by Archer on 2019/1/2.
//

import CoreGraphics

extension CALayer {
    /// 阴影方向
    public struct ShadowDirection: OptionSet {
        
        public let rawValue: Int
        
        public static let top = ShadowDirection(rawValue: 1 << 0)
        public static let left = ShadowDirection(rawValue: 1 << 1)
        public static let right = ShadowDirection(rawValue: 1 << 2)
        public static let bottom = ShadowDirection(rawValue: 1 << 3)
        public static let nonTop: ShadowDirection = [.left, .right, .bottom]
        public static let nonLeft: ShadowDirection = [.top, .right, .bottom]
        public static let nonRight: ShadowDirection = [.top, .left, .bottom]
        public static let nonBottom: ShadowDirection = [.top, .left, .right]
        public static let all: ShadowDirection = [.top, .left, .right, .bottom]
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}

extension Fate where Base: CALayer {
    
    /// 设置阴影方向
    /// NOTE: layer的frame必须已知
    /// TODO: 回家了 明天再说
    public func setShadowDirection(_ direction: CALayer.ShadowDirection) {
        var rect = base.bounds
        if direction.contains(.top) {
            
        }
        
        if direction.contains(.left) {
            
        }
        
        if direction.contains(.right) {
            
        }
        
        if direction.contains(.bottom) {
            
        }
        
        base.shadowPath = CGPath(rect: rect, transform: nil)
    }
}
