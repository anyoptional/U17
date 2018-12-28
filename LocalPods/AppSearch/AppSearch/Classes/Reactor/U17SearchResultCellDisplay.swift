//
//  U17SearchResultCellDisplay.swift
//  AppSearch
//
//  Created by Archer on 2018/12/28.
//

import Fate
import YYKit
import RxBindable

struct U17SearchResultCellPresenter: Presentable {
    
    let imageURL: URL?
    let titleText: String
    let detailText: String
    let tagAttributedText: NSAttributedString?
    
    init(rawValue: SearchResultResp.DataBean.ReturnDataBean.ComicsBean) {
        
        imageURL = URL(string: rawValue.cover.filterNil())
        
        titleText = rawValue.name.filterNil()
        
        detailText = rawValue.author.filterNil() + "\n\n" + rawValue.descriptor.filterNil()
        
        let attrText = NSMutableAttributedString()
        for tagName in rawValue.tags.filterNil([]) {
            let tagText = NSMutableAttributedString(string: tagName)
            tagText.insertString("  ", at: 0)
            tagText.appendString("  ")
            tagText.color = U17def.gray_999999
            tagText.font = UIFont.systemFont(ofSize: 12)
            let border = YYTextBorder(lineStyle: .single, lineWidth: 0.7, stroke: U17def.gray_9B9B9B)
            border.cornerRadius = 8 // (fontSize 12 + insets.top 2 + insets.bottom 2) / 2
            border.lineJoin = .bevel
            border.insets = UIEdgeInsets(top: -2, left: -4, bottom: -2, right: -4)
            tagText.setTextBackgroundBorder(border, range: (tagText.string as NSString).range(of: tagName))
            attrText.append(tagText)
        }
        
        tagAttributedText = attrText.fate.clone()
    }
}

typealias U17SearchResultCellDisplay = UIViewSingleDisplay<U17SearchResultCellPresenter>
