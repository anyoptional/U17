//
//  U17SearchHeaderView.swift
//  AppSearch
//
//  Created by Archer on 2018/12/6.
//

import Fate
import RxSwift
import RxCocoa
import SnapKit

class U17SearchHeaderView: UIView {
    
    enum DisplayMode {
        case hot
        case history
    }

    var displayMode: DisplayMode? {
        didSet {
            guard let displayMode = displayMode else { return }
            switch displayMode {
            case .hot:
                titleLabel.text = "大家都在搜"
                eventButton.setBackgroundImage(UIImage(nameInBundle: "search_keyword_refresh"), for: .normal)
            case .history:
                titleLabel.text = "搜过的漫画都在这里"
                eventButton.setBackgroundImage(UIImage(nameInBundle: "search_history_delete"), for: .normal)
            }
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.font = UIFont.systemFont(ofSize: 11)
        v.textAlignment = .left
        v.textColor = U17def.gray_BABABA
        addSubview(v)
        return v
    }()
    
    fileprivate lazy var eventButton: UIButton = {
        let v = UIButton()
        addSubview(v)
        return v
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
        }
        
        eventButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Reactive where Base: U17SearchHeaderView {
    var event: Observable<U17SearchHeaderView.DisplayMode> {
        return base.eventButton
            .rx.tap
            .map { [weak base] in base?.displayMode }
            .filterNil()
    }
}

