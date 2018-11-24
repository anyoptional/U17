//
//  Mediator.swift
//  Mediator
//
//  Created by Archer on 2018/11/20.
//

import Foundation

public struct Mediator {
    
    private init() {}
    
    public typealias Class = String
    public typealias Module = String
    public typealias Selector = String
}

extension Mediator {
    
    /// Designated remote call making method
    public static func openURL(_ url: URL, completion: (() -> Void)? = nil) -> Any? {
        fatalError("openURL has not been implemented.")
    }
    
    /// Designated local call making method
    public static func perform(_ aSelector: Selector,
                               inClass class: Class,
                               onModule module: Module? = nil,
                               usingParameters parameters: [String : Any]? = nil) -> Any? {
        return __objc_performSelector(aSelector, `class`, module, parameters)
    }
}
