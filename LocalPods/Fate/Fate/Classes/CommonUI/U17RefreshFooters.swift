//
//  U17RefreshFooters.swift
//  Fate
//
//  Created by Archer on 2018/11/26.
//

import MJRefresh

public final class U17RefreshTodayFooter: MJRefreshAutoNormalFooter {
    
    private lazy var stateIv: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(nameInBundle: "")
        return v
    }()
}
