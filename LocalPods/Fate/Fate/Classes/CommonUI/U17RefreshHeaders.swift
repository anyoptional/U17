//
//  U17RefreshHeaders.swift
//  Fate
//
//  Created by Archer on 2018/11/26.
//

import MJRefresh

public final class U17RefreshGifHeader: MJRefreshGifHeader {
    
    public override func prepare() {
        super.prepare()
        
        stateLabel.isHidden = true
        lastUpdatedTimeLabel.isHidden = true
        
        setImages([UIImage(nameInBundle: "refresh_normal")!], for: .idle)
        setImages([UIImage(nameInBundle: "refresh_will_refresh")!], for: .pulling)
        var images = [UIImage]()
        for i in 1...3 { images += [UIImage(nameInBundle: "refresh_loading_\(i)")!] }
        setImages(images, for: .refreshing)
    }
}
