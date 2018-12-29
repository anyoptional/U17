//
//  ReactorKit+Rx.swift
//  Fate
//
//  Created by Archer on 2018/12/29.
//

import RxSwift
import RxCocoa
import ReactorKit

public extension Reactor {
    /// 接收一个事件
    public func accept(_ act: Action) -> Disposable {
        return Observable.just(act).bind(to: action)
    }
}
