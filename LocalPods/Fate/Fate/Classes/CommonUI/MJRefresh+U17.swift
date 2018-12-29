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
    public var upState: MJRefreshState
    /// 下拉刷新状态
    public var downState: MJRefreshState
    
    public init(_ downState: MJRefreshState = .idle, _ upState: MJRefreshState = .idle) {
        self.upState = upState
        self.downState = downState
    }
}

public extension UIScrollView {
    /// u17的gif下拉刷新控件
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
    
    /// u17今日模块的上拉刷新控件
    public var todayFooter: U17RefreshTodayFooter {
        set {
            synchronized(self) {
                mj_footer = newValue;
            }
        }
        get {
            return synchronized(self) {
                if let footer = mj_footer as? U17RefreshTodayFooter {
                    return footer
                }
                let footer = U17RefreshTodayFooter()
                footer.isOnlyRefreshPerDrag = true
                mj_footer = footer
                return mj_footer as! U17RefreshTodayFooter
            }
        }
    }
    
    /// u17普通上拉刷新控件
    public var stateFooter: MJRefreshFooter {
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
                let footer = U17RefreshAutoStateFooter()
                footer.isOnlyRefreshPerDrag = true
                mj_footer = footer
                return mj_footer
            }
        }
    }
}
