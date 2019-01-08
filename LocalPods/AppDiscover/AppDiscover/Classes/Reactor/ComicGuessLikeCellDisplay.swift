//
//  ComicGuessLikeCellDisplay.swift
//  AppDiscover
//
//  Created by Archer on 2019/1/7.
//

import RxBindable

struct ComicGuessLikeComponentViewPresenter: Presentable {
    
    let imgURL: URL?
    let titleText: String
    
    init(rawValue: ComicGuessLikeResp.DataBean.ReturnDataBean.ComicsBean) {
        
        imgURL = URL(string: rawValue.cover.filterNil())
        
        titleText = rawValue.name.filterNil()
    }
}

typealias ComicGuessLikeComponentViewDisplay = UIViewSingleDisplay<ComicGuessLikeComponentViewPresenter>


struct ComicGuessLikeCellPresenter: Presentable {
    
    let componentViewDisplays: [ComicGuessLikeComponentViewDisplay]
    
    init(rawValue: ComicGuessLikeResp.DataBean.ReturnDataBean) {
        
        let comics = rawValue.comics.filterNil([]).suffix(3)
        
        componentViewDisplays = comics.map { ComicGuessLikeComponentViewDisplay(rawValue: $0) }
    }
}

typealias ComicGuessLikeCellDisplay = UIViewSingleDisplay<ComicGuessLikeCellPresenter>
