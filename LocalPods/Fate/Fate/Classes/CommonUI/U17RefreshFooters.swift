//
//  U17RefreshFooters.swift
//  Fate
//
//  Created by Archer on 2018/11/26.
//

import MJRefresh

public final class U17RefreshTodayFooter: MJRefreshAutoNormalFooter {
    
    public enum DisplayMode {
        case normal
        case specific
    }
    
    public var displayMode: DisplayMode? {
        didSet {
            guard let mode = displayMode else { return }
            if mode == .normal {
                remindIv.image = UIImage(nameInBundle: "today_nomore")
            } else {
                remindIv.image = UIImage(nameInBundle: "today_nomore_last")
            }
        }
    }
    
    private lazy var remindIv: UIImageView = {
        let v = UIImageView()
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFit
        addSubview(v)
        return v
    }()    

    public override func prepare() {
        super.prepare()
        stateLabel.textColor = U17def.gray_9B9B9B
    }
    
    public override func placeSubviews() {
        super.placeSubviews()
        if state == .noMoreData {
            backgroundColor = U17def.gray_FAFAFA
            remindIv.size = CGSize(width: 320, height: 120)
            remindIv.center = CGPoint(x: mj_w / 2, y: mj_h / 2)
        } else {
            remindIv.frame = .zero
            backgroundColor = .clear
        }
    }
    
    public override var state: MJRefreshState {
        didSet {
            switch (state) {
            case .noMoreData:
                if mj_h == 200 { return }
                let oldH = mj_h
                mj_h = 200
                scrollView.mj_insetB += (mj_h - oldH)
                remindIv.isHidden = false
                stateLabel.isHidden = true
            default:
                if mj_h == MJRefreshFooterHeight { return }
                let oldH = mj_h
                mj_h = MJRefreshFooterHeight
                scrollView.mj_insetB += (mj_h - oldH)
                remindIv.isHidden = true
                stateLabel.isHidden = false
            }
        }
    }
}

public final class U17RefreshAutoStateFooter: MJRefreshAutoStateFooter {
    override public func prepare() {
        super.prepare()
        setTitle("", for: .idle);
        setTitle("", for: .pulling);
        setTitle("努力加载中~", for: .refreshing);
        setTitle("我也是有底线的~", for: .noMoreData);
        stateLabel.textColor = U17def.gray_999999.withAlphaComponent(0.5)
    }
}
