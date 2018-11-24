//
//  Fate.swift
//  Fate
//
//  Created by Archer on 2018/11/13.
//  Copyright © 2018年 Archer. All rights reserved.
//

public final class Fate<Base> {
    /// Base object to extend.
    public let base: Base
    
    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
}

/// A type that has fate extensions.
public protocol FateCompatible {
    /// Extended type
    associatedtype CompatibleType
    
    /// Fate extensions.
    static var fate: Fate<CompatibleType>.Type { get }
    
    /// Fate extensions.
    var fate: Fate<CompatibleType> { get }
}

extension FateCompatible {
    /// Fate extensions.
    public static var fate: Fate<Self>.Type {
        return Fate<Self>.self
    }
    
    /// Fate extensions.
    public var fate: Fate<Self> {
        return Fate(self)
    }
}

import class Foundation.NSObject

/// Extend NSObject with `fate` proxy.
extension NSObject: FateCompatible {}
