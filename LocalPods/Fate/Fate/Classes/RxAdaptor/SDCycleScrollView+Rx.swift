//
//  SDCycleScrollView+Rx.swift
//  Fate
//
//  Created by Archer on 2018/12/3.
//

import RxSwift
import RxCocoa
import SDCycleScrollView

public class RxSDCycleScrollViewDelegateProxy
    : DelegateProxy<SDCycleScrollView, SDCycleScrollViewDelegate>
    , DelegateProxyType, SDCycleScrollViewDelegate {    
    
    public weak private(set) var cycleScrollView: SDCycleScrollView?
    
    public init(cycleScrollView: ParentObject) {
        self.cycleScrollView = cycleScrollView
        super.init(parentObject: cycleScrollView, delegateProxy: RxSDCycleScrollViewDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxSDCycleScrollViewDelegateProxy(cycleScrollView: $0) }
    }
    
    public static func currentDelegate(for object: SDCycleScrollView) -> SDCycleScrollViewDelegate? {
        return object.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: SDCycleScrollViewDelegate?, to object: SDCycleScrollView) {
        object.delegate = delegate
    }
}

extension Reactive where Base : SDCycleScrollView {
    
    public var delegate: DelegateProxy<SDCycleScrollView, SDCycleScrollViewDelegate> {
        return RxSDCycleScrollViewDelegateProxy.proxy(for: base)
    }
    
    public func setDelegate(_ delegate: SDCycleScrollViewDelegate) -> Disposable {
        return RxSDCycleScrollViewDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: self.base)
    }
    
    public var itemSelected: ControlEvent<Int> {
        let source = self.delegate
            .methodInvoked(#selector(SDCycleScrollViewDelegate.cycleScrollView(_:didSelectItemAt:)))
            .map { castOrFatal($0[1], Int.self) }
        return ControlEvent(events: source)
    }
    
    public var customization: ControlEvent<(cell: UICollectionViewCell, index: Int)> {
        let source = self.delegate
            .methodInvoked(#selector(SDCycleScrollViewDelegate.setupCustomCell(_:for:cycleScrollView:)))
            .map { (cell: castOrFatal($0[0], UICollectionViewCell.self), index: castOrFatal($0[1], Int.self)) }
        return ControlEvent(events: source)
    }
}

extension SDCycleScrollView {
    public func reloadData() {
        if let mainView = value(forKey: "_mainView") as? UICollectionView {
            mainView.reloadData();
        }
    }
    
    public var numberOfItems: Int {
        set {
            var images = [String]()
            for _ in 0..<newValue {
                images.append("http://useless")
            }
            imageURLStringsGroup = images;
        }
        get {
            if let count = value(forKey: "_totalItemsCount") as? Int {
                return count;
            }
            return 0;
        }
    }
}

public func castOrFatal<T>( _ object: Any, _ targetType: T.Type) -> T {
    guard let returnValue = object as? T else {
        fatalError("Error casting `\(object)` to `\(targetType)`")
    }
    return returnValue
}
