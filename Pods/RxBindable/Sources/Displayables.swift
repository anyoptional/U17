//
//  Displayables.swift
//  Bindable
//
//  Created by Archer on 2018/11/13.
//  Copyright © 2018年 Archer. All rights reserved.
//

import Foundation
import Differentiator

/// A wrapper for a view that contains a single response object.
public struct UIViewSingleDisplay<Presenter: Presentable>: Displayable {
    
    public typealias RawValue = Presenter.RawValue
    
    public struct State {
        
        public let rawValue: RawValue
        public let presenter: Presenter
        
        public init(rawValue: RawValue) {
            self.rawValue = rawValue
            presenter = Presenter(rawValue: rawValue)
        }
    }
    
    public let state: State
    
    public init(rawValue: RawValue) {
        state = State(rawValue: rawValue)
    }
}

extension UIViewSingleDisplay.State: Equatable {
    public static func == (lhs: UIViewSingleDisplay<Presenter>.State, rhs: UIViewSingleDisplay<Presenter>.State) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension UIViewSingleDisplay: Equatable {}

extension UIViewSingleDisplay: IdentifiableType {
    public typealias Identity = RawValue

    public var identity: Presenter.RawValue {
        return state.rawValue
    }
}

/// A wrapper for a view that contains sequence of response objects.
public struct UIViewSequenceDisplay<Presenter: Presentable>: Displayable {
    
    public typealias RawValue = Presenter.RawValue
    
    public struct State {
        
        public let rawValues: [RawValue]
        public let presenters: [Presenter]
        
        public init(rawValues: [RawValue]) {
            self.rawValues = rawValues
            presenters =  rawValues.map { Presenter(rawValue: $0) }
        }
    }
    
    public let state: State
    
    public init(rawValues: [RawValue]) {
        state = State(rawValues: rawValues)
    }
}

extension UIViewSequenceDisplay.State: Equatable {
    public static func == (lhs: UIViewSequenceDisplay<Presenter>.State, rhs: UIViewSequenceDisplay<Presenter>.State) -> Bool {
        return lhs.rawValues == rhs.rawValues
    }
}

extension UIViewSequenceDisplay: Equatable {}
