//
//  U17HotSearchCell.swift
//  AppSearch
//
//  Created by Archer on 2018/12/5.
//

import Fate
import YYKit
import SnapKit
import RxSwift
import RxCocoa
import RxBindable

class U17HotSearchCell: UITableViewCell {
    
    private lazy var lineView: UIView = {
        let v = UIView()
        v.backgroundColor = U17def.gray_EAEAEA
        contentView.addSubview(v)
        return v
    }()
    
    fileprivate lazy var keywordsLabel: YYLabel = {
        let v = YYLabel()
        v.textContainerInset = UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0)
        v.numberOfLines = 0
        v.displaysAsynchronously = true
        v.textAlignment = .left
        contentView.addSubview(v)
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        lineView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(0.7)
        }
        
        keywordsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.bottom.equalTo(-5)
            make.left.right.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension U17HotSearchCell: Bindable {
    func bind(display: U17HotSearchCellDisplay) {
        
        let presenter = display.state.presenter
        
        keywordsLabel.attributedText = presenter.keywordsAttrText
    }
}

extension Reactive where Base: U17HotSearchCell {
    var tap: Observable<String> {
        return Observable.create({ [weak base] (observer) in
            if let base = base {
                base.keywordsLabel.highlightTapAction = { (container, attrString, range, rect) in
                    let keyword = attrString.attributedSubstring(from: range).string
                    observer.onNext(keyword.trimmed)
                }
            } else {
                observer.onCompleted()
            }
            return Disposables.create()
        }).takeUntil(deallocated)
    }
}
