//
//  U17KeywordRelativeCellDisplay.swift
//  AppSearch
//
//  Created by Archer on 2018/12/6.
//

import Fate
import RxBindable

struct U17KeywordRelativeCellPresenter: Presentable {
    
    let attributedText: NSAttributedString?
    
    init(rawValue: KeywordRelativeResp.DataBean.ReturnDataBean) {
        
        let name = rawValue.name.filterNil()
        let keyword = rawValue.keyword.filterNil()
        let attrText = NSMutableAttributedString(string: name,
                                                 attributes: [.font : UIFont.systemFont(ofSize: 13),
                                                              .foregroundColor : U17def.gray_999999])
        attrText.addAttributes([.foregroundColor : U17def.green_30DC91], range: (name as NSString).range(of: keyword))
        
        attributedText = attrText.fate.clone()
    }
}

typealias U17KeywordRelativeCellDisplay = UIViewSingleDisplay<U17KeywordRelativeCellPresenter>
