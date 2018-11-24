//
//  Presentable.swift
//  Bindable
//
//  Created by Archer on 2018/11/13.
//  Copyright © 2018年 Archer. All rights reserved.
//

import Foundation

// A type that is pretty suit for UI display
public protocol Presentable {
    
    /// RawValue represents the original unmodified data
    associatedtype RawValue
    
    /// Initializer for creates Presentable itself
    init(rawValue: RawValue)
}
