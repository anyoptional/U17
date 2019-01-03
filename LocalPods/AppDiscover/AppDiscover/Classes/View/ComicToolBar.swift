//
//  ComicToolBar.swift
//  AppDiscover
//
//  Created by Archer on 2019/1/2.
//

import Fate
import UIKit
import YYKit
import RxSwift
import RxCocoa

class ComicToolBar: UIView {

    fileprivate lazy var ticketButton: UIButton = {
        let v = UIButton()
        v.setTitle("投月票", for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 15)
        v.setTitleColor(U17def.gray_AAAAAA, for: .normal)
        let image = UIImage(nameInBundle: "sendMonthTicket")?
            .byResize(to: CGSize(width: 17, height: 17))
        v.setImage(image, for: .normal)
        addSubview(v)
        return v
    }()
    
    fileprivate lazy var commentButton: UIButton = {
        let v = UIButton()
        v.setTitle("评论区", for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 15)
        v.setTitleColor(U17def.gray_AAAAAA, for: .normal)
        let image = UIImage(nameInBundle: "toComment")?
            .byResize(to: CGSize(width: 17, height: 17))
        v.setImage(image, for: .normal)
        addSubview(v)
        return v
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ticketButton.fate.setTitleAlignment(.right, withOffset: 3)
        commentButton.fate.setTitleAlignment(.right, withOffset: 3)
        layer.fate.setShadowOffset(CGSize(width: 0, height: -0.7), at: .top)
    }
    
    init() {
        super.init(frame: .zero)
        
        // 不设置背景色阴影会包裹着subview
        backgroundColor = .white
        layer.shadowOpacity = 0.15
        layer.shadowColor = UIColor.black.cgColor
        
        let buttons = [ticketButton, commentButton]
        buttons.snp.distributeViewsAlong(axisType: .horizontal, fixedSpacing: 15,
                                         leadSpacing: 0, tailSpacing: 0)
        buttons.snp.makeConstraints { (make) in
            make.top.height.equalToSuperview()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Reactive where Base: ComicToolBar {
    
    /// 投月票
    var sendTicket: Observable<Void> {
        return base.ticketButton.rx.tap.asObservable()
    }
    
    /// 评论区
    var sendComment: Observable<Void> {
        return base.commentButton.rx.tap.asObservable()
    }
}
