//
//  ComicDetailHeaderFooterViews.swift
//  AppDiscover
//
//  Created by Archer on 2019/1/8.
//

import Fate
import UIKit
import YYKit
import SnapKit
import RxSwift
import RxCocoa
import RxBindable

class ChapterHeaderView: UITableViewHeaderFooterView {
    
    fileprivate lazy var collectButton: UIButton = {
        let v = UIButton()
        let image = UIImage(nameInBundle: "july_comic_end_collect")?
            .byResize(to: CGSize(width: 25, height: 28))
        v.setImage(image, for: .normal)
        v.setTitle("收藏(--)", for: .normal)
        v.setTitleColor(U17def.black_333333, for: .normal)
        v.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        contentView.addSubview(v)
        return v
    }()
    
    fileprivate lazy var readButton: UIButton = {
        let v = UIButton()
        v.setBackgroundImage(UIImage(nameInBundle: "detailContinue"), for: .normal)
        v.setTitle("阅读 第~话", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        contentView.addSubview(v)
        return v
    }()
    
    private lazy var descLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        contentView.addSubview(v)
        return v
    }()
    
    fileprivate lazy var showAllButton: UIButton = {
        let v = UIButton()
        let image = UIImage(nameInBundle: "zhanBtnDetail")?
            .byResize(to: CGSize(width: 45, height: 20))
        v.setBackgroundImage(image, for: .normal)
        contentView.addSubview(v)
        return v
    }()
    
    private lazy var totalLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .left
        contentView.addSubview(v)
        return v
    }()
    
    fileprivate lazy var orderButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(nameInBundle: "Reverse"), for: .normal)
        v.setImage(UIImage(nameInBundle: "positive sequence"), for: .selected)
        contentView.addSubview(v)
        return v
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let display = display else { return }
        
        readButton.top = 20
        readButton.width = width / 2
        readButton.right = width
        readButton.height = 40
        
        collectButton.width = width / 2 - 10
        collectButton.height = 20
        collectButton.centerY = readButton.centerY
        collectButton.left = 0
        
        descLabel.top = readButton.bottom + 20
        descLabel.left = 13
        descLabel.width = width - 26
        descLabel.height = display.state.presenter.descLabelHeight
        
        showAllButton.size = CGSize(width: 45, height: 20)
        showAllButton.right = width - 13
        showAllButton.bottom = descLabel.bottom
        
        totalLabel.top = descLabel.bottom + 15
        totalLabel.left = descLabel.left
        totalLabel.width = width - 150
        totalLabel.height = 20
        
        orderButton.size = CGSize(width: 45, height: 20)
        orderButton.right = width - 13
        orderButton.centerY = totalLabel.centerY
        
        // 圆角
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: bounds,
                                      byRoundingCorners: [.topLeft, .topRight],
                                      cornerRadii: CGSize(width:15, height:15)).cgPath
        layer.mask = maskLayer
    
        // 对齐
        collectButton.fate.setTitleAlignment(.right, withOffset: 3)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundView = UIView()
        backgroundView?.backgroundColor = .white
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChapterHeaderView: Bindable {
    func bind(display: ChapterHeaderViewDisplay) {
        
        let presenter = display.state.presenter
        
        descLabel.attributedText = presenter.descAttrText
        
        totalLabel.attributedText = presenter.totalAttributedText
        
        showAllButton.isHidden = presenter.showsFullDescription
    }
}

extension Reactive where Base: ChapterHeaderView {
    
    /// 显示全部简介
    var showsAll: Observable<Void> {
        return base.showAllButton.rx.tap.asObservable()
    }
}

class ChapterFooterView: UITableViewHeaderFooterView {
    
    fileprivate lazy var expandButton: UIButton = {
        let v = UIButton()
        v.backgroundColor = .white
        v.setTitle("展开目录", for: .normal)
        let image = UIImage(nameInBundle: "zhanMenu")?
            .byResize(to: CGSize(width: 12, height: 12))
        v.setImage(image, for: .normal)
        v.setImage(image, for: .highlighted)
        v.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        v.setTitleColor(U17def.green_30DC91, for: .normal)
        contentView.addSubview(v)
        return v
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        expandButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        expandButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: -3)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundView = UIView()
        backgroundView?.backgroundColor = U17def.gray_F2F2F2
        
        expandButton.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(29)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Reactive where Base: ChapterFooterView {
    /// 展开目录
    var expand: Observable<Void> {
        return base.expandButton.rx.tap.asObservable()
    }
}

class GuessLikeHeaderView: UITableViewHeaderFooterView {
    
    private lazy var titleLabel: YYLabel = {
        let v = YYLabel()
        v.text = "猜你喜欢"
        v.textAlignment = .left
        v.backgroundColor = .white
        v.textColor = U17def.black_333333
        v.font = UIFont.boldSystemFont(ofSize: 18)
        v.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 0, right: 0)
        contentView.addSubview(v)
        return v
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundView = UIView()
        backgroundView?.backgroundColor = .white
        
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GuessLikeFooterView: UITableViewHeaderFooterView {
    
    fileprivate lazy var reportButton: UIButton = {
        let v = UIButton()
        v.setTitle("内容举报", for: .normal)
        v.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        v.setTitleColor(U17def.gray_999999.withAlphaComponent(0.7), for: .normal)
        v.fate.touchAreaInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        contentView.addSubview(v)
        return v
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reportButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundView = UIView()
        backgroundView?.backgroundColor = .white
        
        reportButton.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
        }
        
        // 上滑遮住 `被发现了吗`
        // 这才是真正的彩蛋哟~~
        let extendedView = YYLabel()
        extendedView.text = "骚年你很棒棒哟~"
        extendedView.textAlignment = .center
        extendedView.backgroundColor = .white
        extendedView.textColor = U17def.green_30DC91
        extendedView.font = UIFont.systemFont(ofSize: 13)
        extendedView.textContainerInset = UIEdgeInsets(top: 160, left: 0, bottom: 270, right: 0)
        contentView.addSubview(extendedView)
        extendedView.snp.makeConstraints { (make) in
            make.top.equalTo(snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(450)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Reactive where Base: GuessLikeFooterView {
    /// 举报
    var report: Observable<Void> {
        return base.reportButton.rx.tap.asObservable()
    }
}
