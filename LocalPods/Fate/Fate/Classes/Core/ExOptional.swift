//
//  ExOptional.swift
//  Fate
//
//  Created by Archer on 2018/11/23.
//

import Foundation

public extension Optional {
    
    /// 过滤可选项为nil的情况
    ///
    /// - Parameter valueOnNil: 可选项为空时的默认值
    /// - Returns: 解包后的值
    public func filterNil(_ valueOnNil: Wrapped) -> Wrapped {
        switch self {
        case .some(let value):
            return value
        case .none:
            return valueOnNil
        }
    }
}
