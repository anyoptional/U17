
//
//  Bindable.swift
//  Bindable
//
//  Created by Archer on 2018/11/13.
//  Copyright © 2018年 Archer. All rights reserved.
//

import Foundation

/// UI-independent layer that manages view's presentation state,
/// user interactions are not inlcude(unlike Reactor).
public protocol Bindable: class, ObjCAssociatedObjectStore {
    
    associatedtype Display: Displayable
    
    /// A view's display object. `bind(display:)` gets called
    /// when the new value is assigned to this property.
    var display: Display? { get set }
    
    /// Creates data bindings. This method is called each time the `display` is assigned.
    ///
    /// - warning: It's not recommended to call this method directly.
    func bind(display: Display)
}

// MARK: - Default Implementations
fileprivate var associativeKey: UInt8 = 0

extension Bindable {
    public var display: Display? {
        get { return associatedObject(forKey: &associativeKey) }
        set {
            setAssociatedObject(newValue, forKey: &associativeKey)
            if let display = newValue { bind(display: display) }
        }
    }
}
