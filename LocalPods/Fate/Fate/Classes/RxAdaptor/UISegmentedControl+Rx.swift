//
//  UISegmentedControl+Rx.swift
//  Fate
//
//  Created by Archer on 2018/12/3.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UISegmentedControl {
    public var tap: Observable<Int> {
        return base.rx
            .controlEvent(.valueChanged)
            .flatMap { [weak base] _ -> Observable<Int> in
                guard let `base` = base else { return .empty() }
                return base.rx.selectedSegmentIndex.asObservable() }
    }
}
