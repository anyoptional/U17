//
//  ExOptional.swift
//  Fate
//
//  Created by Archer on 2018/11/23.
//

import Foundation

public extension Optional {
    public func filterNil(_ valueOnNil: Wrapped) -> Wrapped {
        switch self {
        case .some(let value):
            return value
        case .none:
            return valueOnNil
        }
    }
}
