//
//  U17PlaceholderView.swift
//  Fate
//
//  Created by Archer on 2018/12/5.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional

public class U17PlaceholderView: UIView {
    
    public enum State {
        /// 没有数据
        case empty
        /// 加载失败
        case failed
        /// 正在加载
        case loading
        /// 加载完成
        case completed
    }
    
    /// 占位图的当前状态
    public var state: State? {
        didSet {
            guard state != oldValue else { return }
            isHidden = false
            subviews.forEach { $0.removeFromSuperview() }
            layer.removeAnimation(forKey: "_kCAAniamtionKey")
            if let state = state {
                switch state {
                case .empty:
                    if let emptyView = reusingViews.first(where: { $0 is U17EmptyPlaceholderView }) {
                        addSubview(emptyView)
                    } else {
                        let emptyView = U17EmptyPlaceholderView()
                        reusingViews.append(emptyView)
                        addSubview(emptyView)
                    }
                case .failed:
                    if let failedView = reusingViews.first(where: { $0 is U17FailedPlaceholderView }) {
                        addSubview(failedView)
                    } else {
                        let failedView = U17FailedPlaceholderView()
                        reusingViews.append(failedView)
                        addSubview(failedView)
                    }
                case .loading:
                    if let loadingView = reusingViews.first(where: { $0 is U17LoadingPlaceholderView }) {
                        addSubview(loadingView)
                    } else {
                        let loadingView = U17LoadingPlaceholderView()
                        reusingViews.append(loadingView)
                        addSubview(loadingView)
                    }
                case .completed: isHidden = true
                }
                setNeedsLayout()
                if let animation = animation {
                    layer.add(animation, forKey: "_kCAAniamtionKey")
                }
            }
        }
    }
    
    /// 视图切换时的动画
    public var animation: CAAnimation? = {
        let animation = CATransition()
        animation.type = .fade
        animation.duration = 0.125
        animation.repeatCount = 1.0
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = true
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        return animation
    }()
    
    /// 调整当前具体状态视图的位置和大小
    /// 当前状态视图默认是和其父视图一样大的
    /// top left bottom right的具体意义和SnapKit定义的一致
    public var contentInset: UIEdgeInsets = .zero {
        didSet {
            setNeedsLayout()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        subviews.forEach {
            let x = self.contentInset.left
            let y = self.contentInset.top
            let width = self.bounds.width - x + self.contentInset.right
            let height = self.bounds.height - y + self.contentInset.bottom
            $0.frame = CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
    private lazy var reusingViews = [UIView]()
    fileprivate lazy var tapGesture = UITapGestureRecognizer()
    
    public init() {
        super.init(frame: .zero)
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Reactive where Base: U17PlaceholderView {
    
    /// Reactive extension for state
    public var state: Binder<U17PlaceholderView.State> {
        return Binder(base) { (placeholderView, state) in
            placeholderView.state = state
        }
    }
    
    /// Reactive extension for tap event
    public var tap: Observable<U17PlaceholderView.State> {
        return base.tapGesture
            .rx.event
            .filter { [weak base] (ges) -> Bool in
                guard let base = base else { return false }
                // 空的不能点
                guard let state = base.state else { return false }
                // 根据状态点击
                switch state {
                    // 不需要点击的状态
                case .failed, .loading, .completed:
                    return false
                case .empty:
                    // 没有加载出来时点击中间的头像
                    guard let emptyView = base.subviews.first else { return false }
                    let point = ges.location(in: base)
                    let rect = CGRect(x: emptyView.frame.minX + (emptyView.frame.width - 60)/2,
                                      y: emptyView.frame.minY + (emptyView.frame.height - 60)/2 + 20, // 20是头像相对整图的偏移
                                      width: 60, height: 60)
                    return rect.contains(point)
                }
            }.map { [weak base] _ in base?.state }
            .filterNil()
    }
}


fileprivate class U17EmptyPlaceholderView: UIView {
    
    private lazy var emptyIv: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.image = UIImage(nameInBundle: "nodata_image")
        addSubview(v)
        return v
    }()
    
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.text = "什么都没有~"
        v.textAlignment = .center
        v.textColor = U17def.gray_999999
        v.font = UIFont.systemFont(ofSize: 13)
        addSubview(v)
        return v
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        emptyIv.size = CGSize(width: frame.width, height: 105)
        emptyIv.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        titleLabel.size = CGSize(width: frame.width - 40, height: 14)
        titleLabel.left = 20
        titleLabel.top = emptyIv.bottom + 10
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return superview
    }
    
}

fileprivate class U17FailedPlaceholderView: UIView {
    
    private lazy var errorIv: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.image = UIImage(nameInBundle: "seal_load_error")
        addSubview(v)
        return v
    }()
    
    private lazy var leftLayer: CALayer = {
        let v = CALayer()
        v.backgroundColor = U17def.gray_F2F2F2.cgColor
        errorIv.layer.addSublayer(v)
        return v
    }()
    
    private lazy var rightLayer: CALayer = {
        let v = CALayer()
        v.backgroundColor = U17def.gray_F2F2F2.cgColor
        errorIv.layer.addSublayer(v)
        return v
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        errorIv.size = CGSize(width: frame.width, height: 180)
        errorIv.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        leftLayer.width = errorIv.width / 2 - 105
        leftLayer.height = 0.9
        leftLayer.left = 40
        leftLayer.centerY = errorIv.height / 2 + 20
        
        rightLayer.width = leftLayer.width
        rightLayer.height = leftLayer.height
        rightLayer.left = errorIv.width / 2 + 65
        rightLayer.centerY = leftLayer.centerY
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return superview
    }
    
}

fileprivate class U17LoadingPlaceholderView: UIView {
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(style: .gray)
        v.startAnimating()
        addSubview(v)
        return v
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        indicatorView.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return superview
    }

}
