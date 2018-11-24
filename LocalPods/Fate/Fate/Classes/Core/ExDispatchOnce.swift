//
//  ExDispatchOnce.swift
//  Fate
//
//  Created by Archer on 2018/11/23.
//

import Foundation

/// A Set that stores registed tokens
fileprivate var dispatchOnceTokens = Set<String>()

public extension Fate where Base: DispatchQueue {
    
    /// Executes a closure of code, associated with a unique token, only once.
    /// The code is thread safe and will only execute the code once even in the
    /// presence of multithreaded calls.
    ///
    /// - Parameters:
    ///   - token: A unique string
    ///   - execute: A closure to execute once
    public static func once(token: String, execute:() -> Void) {
        objc_sync_enter(self)
        if dispatchOnceTokens
            .insert(token)
            .inserted {
            execute()
        }
        objc_sync_exit(self)
    }
}
