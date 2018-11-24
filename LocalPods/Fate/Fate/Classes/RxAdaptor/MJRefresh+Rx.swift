//
//  MJRefresh+Rx.swift
//  Fate
//
//  Created by Archer on 2018/11/23.
//

import RxSwift
import RxCocoa
import MJRefresh

public class NXTarget: NSObject, Disposable {
    private var retainSelf: NXTarget?
    override init() {
        super.init()
        self.retainSelf = self
    }
    public func dispose() {
        self.retainSelf = nil
    }
}

private final class MJRefreshTarget<Component: MJRefreshComponent>: NXTarget {
    weak var component: Component?
    let refreshingBlock: MJRefreshComponentRefreshingBlock
    
    init(_ component: Component , refreshingBlock: @escaping MJRefreshComponentRefreshingBlock) {
        self.refreshingBlock = refreshingBlock
        self.component = component
        super.init()
        component.setRefreshingTarget(self, refreshingAction: #selector(onRefeshing))
    }
    
    @objc func onRefeshing() {
        refreshingBlock()
    }
    
    override func dispose() {
        super.dispose()
        self.component?.refreshingBlock = nil
    }
}

public extension Reactive where Base: MJRefreshComponent {
    public var refresh: ControlProperty<MJRefreshState> {
        let source: Observable<MJRefreshState> = Observable.create { [weak component = base] observer  in
            MainScheduler.ensureExecutingOnScheduler()
            guard let component = component else {
                observer.on(.completed)
                return Disposables.create()
            }
            
            observer.on(.next(component.state))
            
            let observer = MJRefreshTarget(component) {
                observer.on(.next(component.state))
            }
            return observer
            }.takeUntil(deallocated)
        
        let bindingObserver = Binder<MJRefreshState>(base) { (component, state) in
            component.state = state
        }
        return ControlProperty(values: source, valueSink: bindingObserver)
    }
}

