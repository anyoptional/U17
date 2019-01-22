//
//  ComicChapterCellDisplay.swift
//  AppDiscover
//
//  Created by Archer on 2019/1/7.
//

import RxBindable

fileprivate let formatter: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "yyyy-MM-dd"
    return f
}()

struct ComicChapterCellPresenter: Presentable {
    
    let imgURL: URL?
    let titleText: String
    let detailText: String
    
    init(rawValue: ComicStaticDetailResp.DataBean.ReturnDataBean.Chapter_listBean) {
        
        imgURL = URL(string: rawValue.smallPlaceCover.filterNil())
        
        titleText = rawValue.name.filterNil()
        
        detailText = "第\(rawValue.chapterIndex + 1)话" + " " + formatter.string(from: Date(timeIntervalSince1970: TimeInterval(rawValue.publish_time)))
    }
}

typealias ComicChapterCellDisplay = UIViewSingleDisplay<ComicChapterCellPresenter>
