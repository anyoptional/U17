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

class ChapterHeaderView: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundView = UIView()
        backgroundView?.backgroundColor = U17def.gray_F2F2F2
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
