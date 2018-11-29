//
//  ExNSCopying.swift
//  Fate
//
//  Created by Archer on 2018/11/29.
//

import Foundation

extension Fate where Base: NSObject {
    
    /// 以类型推断的形式浅拷贝一个对象
    public func clone<_Tp: NSCopying>(_ objectClass: _Tp.Type = _Tp.self) -> _Tp? {
        return base.copy() as? _Tp
    }
    
    /// 以类型推断的形式深拷贝一个对象
    public func mutableClone<_Tp: NSMutableCopying>(_ objectClass: _Tp.Type = _Tp.self) -> _Tp? {
        return base.mutableCopy() as? _Tp
    }
}
