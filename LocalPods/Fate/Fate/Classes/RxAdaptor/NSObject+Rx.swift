//
//  NSObject+Rx.swift
//  Fate
//
//  Created by Archer on 2018/11/23.
//

import RxSwift

/// Equivalent to @synchronized(key) {} in Objective-C.
public func synchronized<_Tp>(_ key: Any, execute: () -> _Tp) -> _Tp {
    objc_sync_enter(key)
    let result = execute()
    objc_sync_exit(key)
    return result
}

fileprivate var disposeBagKey: UInt8 = 0

public extension NSObject {
    /// Provide a unique disposeBag for NSObject subclass.
    public var disposeBag: DisposeBag {
        set {
            synchronized(self) {
                objc_setAssociatedObject(self, &disposeBagKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
        get {
            return synchronized(self) {
                if let disposeObject = objc_getAssociatedObject(self, &disposeBagKey) as? DisposeBag {
                    return disposeObject
                }
                let disposeObject = DisposeBag()
                objc_setAssociatedObject(self, &disposeBagKey, disposeObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return disposeObject
            }
        }
    }
}
