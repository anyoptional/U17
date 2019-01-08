//
//  FDMargin.swift
//  FOLDin
//
//  Created by Archer on 2018/12/16.
//

import Foundation

@objc protocol FDMarginDelegate: NSObjectProtocol {
    func marginDidChange(_ margin: FDMargin)
}

/// 代表左右边距
@objcMembers
public class FDMargin: NSObject {
    
    weak var delegate: FDMarginDelegate?

    public var left: CGFloat {
        didSet {
            if left != oldValue {
                delegate?.marginDidChange(self)
            }
        }
    }
    
    public var right: CGFloat {
        didSet {
            if right != oldValue {
                delegate?.marginDidChange(self)
            }
        }
    }
    
    public init(left: CGFloat, right: CGFloat) {
        self.left = left
        self.right = right
    }
    
    public override var hash: Int {
        return left.hashValue ^ right.hashValue
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        guard let margin = object as? FDMargin else { return false }
        return margin.left == self.left && margin.right == self.right
    }
}
