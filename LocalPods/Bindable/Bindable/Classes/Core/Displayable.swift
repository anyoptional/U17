
//
//  Displayable.swift
//  Bindable
//
//  Created by Archer on 2018/11/13.
//  Copyright © 2018年 Archer. All rights reserved.
//

import Foundation

/// Displayable that holds view's state,
/// both RawValue(typically thin model) and
/// Presenter(typically fat model) are inlcude,
/// see Displayables.Swift for more information.
public protocol Displayable {
    
    /// A State represents the current state of a view.
    associatedtype State
    
    /// The current state of a view.
    var state: State { get }
}
