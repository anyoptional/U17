//
//  FDMargin.swift
//  FOLDin
//
//  Created by Archer on 2018/12/16.
//

import Foundation

/// 代表左右边距
@objcMembers
public class FDMargin: NSObject {
    public var left: CGFloat
    public var right: CGFloat
    
    public init(left: CGFloat, right: CGFloat) {
        self.left = left
        self.right = right
    }
}
