//
//  TodayRecommandCellDisplay.swift
//  AppToday
//
//  Created by Archer on 2018/11/23.
//

import Bindable

struct TodayRecommandCellPresenter: Presentable {
    
    let imgURL: URL?
    
    /// oh fuck, 真尼玛长orz...
    init(rawValue: TodayRecommandResp.DataBean.ReturnDataBean.DayDataListBean.DayItemDataListBean) {
        
        imgURL = URL(string: rawValue.cover.filterNil())
    }
}

typealias TodayRecommandCellDisplay = UIViewSingleDisplay<TodayRecommandCellPresenter>
