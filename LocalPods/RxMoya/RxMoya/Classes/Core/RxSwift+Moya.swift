
//
//  RxSwift+Moya.swift
//  RxMoya
//
//  Created by Archer on 2018/11/20.
//

import RxSwift
import RxOptional

public extension Observable {
    /// Discards all emit elements.
    public func discard() -> Observable<Void> {
        return map { _ in Void() }
    }
    
    /// Subscribes the Observable sequence, but does nothing.
    public func cauterize() -> Disposable {
        return subscribe(onNext: { _ in })
    }
    
    /// Emits elements of an observable sequence based on a predicate.
    public func takeWhen(_ predicate: @escaping (Element) throws -> Bool) -> Observable<Element> {
        return filter(predicate)
    }
}

public extension Observable where Element == JSONObject {
    /// Converts response json to specified object type,
    /// if failed, just emit a single completed message.
    public func mapObject<_Tp: JSONObjectConvertible>(_ ObjCType: _Tp.Type) -> Observable<_Tp> {
        return map { ObjCType.object(withJSON: $0) }.filterNil()
    }    
}
