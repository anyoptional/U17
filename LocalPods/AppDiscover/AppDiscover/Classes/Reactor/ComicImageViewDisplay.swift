//
//  ComicImageViewDisplay.swift
//  AppDiscover
//
//  Created by Archer on 2019/1/6.
//

import RxBindable

struct ComicImageViewPresenter: Presentable {
    
    let backgroundImageURL: URL?
    let backgroundImageColor: UIColor?
    
    init(rawValue: ComicStaticDetailResp.DataBean.ReturnDataBean) {
        
        let comic = rawValue.comic
        
        // cover不存在时取ori
        let coverURLString = comic?.cover
        let originalURLString = (comic?.ori).filterNil()
        let imageURL = URL(string: coverURLString.filterNil(originalURLString))
        
        // wide不存在取cover，cover也没有取ori
        let wideURLString = comic?.wideCover
        if wideURLString?.isBlank ?? true {
            backgroundImageURL = imageURL
        } else {
            backgroundImageURL = URL(string: wideURLString.filterNil())
        }
        
        if let wideColorString = comic?.wideColor, let color = UIColor(hexString: wideColorString) {
            backgroundImageColor = color.withAlphaComponent(0.8)
        } else {
            backgroundImageColor = nil
        }
    }
}

typealias ComicImageViewDisplay = UIViewSingleDisplay<ComicImageViewPresenter>
