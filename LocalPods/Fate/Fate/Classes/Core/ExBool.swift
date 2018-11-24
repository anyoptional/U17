//
//  ExBool.swift
//  Fate
//
//  Created by Archer on 2018/11/23.
//

import Foundation

public extension Bool {
    public func toggle() -> Bool {
        return !self
    }
    public mutating func toggled() {
        self = !self
    }
}
