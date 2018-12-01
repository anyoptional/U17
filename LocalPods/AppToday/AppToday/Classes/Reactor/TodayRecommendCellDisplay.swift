//
//  TodayRecommendCellDisplay.swift
//  AppToday
//
//  Created by Archer on 2018/11/23.
//

import YYKit
import RxBindable

struct TodayRecommendCellPresenter: Presentable {
    
    let imgURL: URL?
    let titleText: String
    let authorText: String
    let updateText: String
    let chapterText: String
    let tagAttributedText: NSAttributedString?
    
    /// oh fuck, 真尼玛长orz...
    init(rawValue: TodayRecommendResp.DataBean.ReturnDataBean.ComicsBean) {
        
        titleText = rawValue.title.filterNil()
        
        authorText = rawValue.author.filterNil()
        
        imgURL = URL(string: rawValue.cover.filterNil())
        
        updateText = "更新至 " + rawValue.descriptor.filterNil()
        
        chapterText = "全集 >"
        
        let attrText = NSMutableAttributedString()
        for tag in rawValue.tagList.filterNil([]) {
            let tagName = tag.tagStr.filterNil()
            let tagFillColor = UIColor(hexString: tag.tagColor.filterNil("#FDD63E"))
            let tagText = NSMutableAttributedString(string: tagName)
            tagText.insertString("  ", at: 0)
            tagText.appendString("  ")
            tagText.color = UIColor.white
            tagText.font = UIFont.systemFont(ofSize: 9)
            let border = YYTextBorder(fill: tagFillColor, cornerRadius: 6.5)
            border.lineJoin = .bevel
            border.insets = UIEdgeInsets(top: -2, left: -4, bottom: -2, right: -4)
            tagText.setTextBackgroundBorder(border, range: (tagText.string as NSString).range(of: tagName))
            attrText.append(tagText)
        }
        
        tagAttributedText = attrText.fate.clone()
    }
}

typealias TodayRecommendCellDisplay = UIViewSingleDisplay<TodayRecommendCellPresenter>
