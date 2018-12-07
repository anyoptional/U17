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
    
    fileprivate lazy var keywordsLabel: YYLabel = {
        let v = YYLabel()
        v.textContainerInset = UIEdgeInsets(top: 6, left: 9, bottom: 12, right: 9)
        v.numberOfLines = 0
        v.displaysAsynchronously = true
        v.textAlignment = .left
        contentView.addSubview(v)
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
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
        
        if keywordsLabel.attributedText != presenter.keywordsAttrText {
            keywordsLabel.attributedText = presenter.keywordsAttrText
        }
    }
}

extension Reactive where Base: U17HotSearchCell {
    
    /// 点击标签上的关键字
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
