
//
//  U17HistorySearchCellDisplay.swift
//  AppSearch
//
//  Created by Archer on 2018/12/6.
//

import RxBindable

struct U17HistorySearchCellPresenter: Presentable {
    
    let keywordText: String
    
    init(rawValue: String) {
        
        keywordText = rawValue
    }    
}

typealias U17HistorySearchCellDisplay = UIViewSingleDisplay<U17HistorySearchCellPresenter>

