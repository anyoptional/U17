//
//  Displayables.swift
//  Bindable
//
//  Created by Archer on 2018/11/13.
//  Copyright © 2018年 Archer. All rights reserved.
//

import Foundation

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

/// A wrapper for a view that contains sequence of displayables.
public struct UIViewSequenceDisplayables<Display: Displayable>: Displayable {
    
    public struct State {
        public let displayables: [Display]
    }
    
    public let state: State
    
    public init(displayables: [Display]) {
        state = State(displayables: displayables)
    }
}
