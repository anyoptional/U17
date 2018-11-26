//
//  MJRefresh+U17.swift
//  Fate
//
//  Created by Archer on 2018/11/26.
//

import MJRefresh

/// 刷新控件的状态
public struct U17RefreshState {
    /// 上拉刷新状态
    public var upState = MJRefreshState.idle
    /// 上拉刷新状态
    public var downState = MJRefreshState.idle
    
    public init() {}
}

public extension UIScrollView {
    public var gifHeader: MJRefreshHeader {
        set {
            synchronized(self) {
                mj_header = newValue;
            }
        }
        get {
            return synchronized(self) {
                if let header = mj_header {
                    return header
                }
                mj_header = U17RefreshGifHeader()
                return mj_header
            }
        }
    }
    
    public var todayFooter: MJRefreshFooter {
        set {
            synchronized(self) {
                mj_footer = newValue;
            }
        }
        get {
            return synchronized(self) {
                if let footer = mj_footer {
                    return footer
                }
                let footer = U17RefreshTodayFooter()
                footer.isOnlyRefreshPerDrag = true
                mj_footer = footer
                return mj_footer
            }
        }
    }
}
