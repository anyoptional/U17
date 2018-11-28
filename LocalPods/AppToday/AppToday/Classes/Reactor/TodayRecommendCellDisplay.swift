//
//  TodayRecommendCellDisplay.swift
//  AppToday
//
//  Created by Archer on 2018/11/23.
//

import Bindable

struct TodayRecommendCellPresenter: Presentable {
    
    let imgURL: URL?
    let titleText: String
    let authorText: String
    let updateText: String
    let chapterText: String
    
    /// oh fuck, 真尼玛长orz...
    init(rawValue: TodayRecommendResp.DataBean.ReturnDataBean.ComicsBean) {
        
        titleText = rawValue.title.filterNil()
        
        authorText = rawValue.author.filterNil()
        
        imgURL = URL(string: rawValue.cover.filterNil())
        
        updateText = "更新至 " + rawValue.descriptor.filterNil()
        
        chapterText = "全集 >"
    }
}

typealias TodayRecommendCellDisplay = UIViewSingleDisplay<TodayRecommendCellPresenter>
