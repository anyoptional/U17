//
//  U17HotSearchCellDisplay.swift
//  AppSearch
//
//  Created by Archer on 2018/12/6.
//

import Fate
import YYKit
import RxBindable

struct U17HotSearchCellPresenter: Presentable {
    
    let keywordsAttrText: NSAttributedString?
    
    init(rawValue: HotKeywordsResp.DataBean.ReturnDataBean) {
        
        var height: CGFloat = 0
        let keywords = (rawValue.hotItems?.map { $0.name.filterNil() }).filterNil([])
        
        let attrText = NSMutableAttributedString()
        for (index, keyword) in keywords.enumerated() {
            let keywordText = NSMutableAttributedString(string: keyword)
            keywordText.insertString("    ", at: 0)
            keywordText.appendString("    ")
            keywordText.color = U17def.gray_8E8E8E
            keywordText.font = UIFont.systemFont(ofSize: 13)
            keywordText.setTextBinding(YYTextBinding(deleteConfirm: false), range: (keywordText.string as NSString).rangeOfAll())
            let border = YYTextBorder(fill: U17def.gray_F2F2F2, cornerRadius: 50)
            border.insets = UIEdgeInsets(top: -6, left: -10, bottom: -6, right: -10)
            border.lineJoin = .bevel
            keywordText.setTextBackgroundBorder(border, range: (keywordText.string as NSString).range(of: keyword))
            keywordText.setTextHighlight((keywordText.string as NSString).rangeOfAll(), color: nil, backgroundColor: nil, userInfo: nil)
            attrText.append(keywordText)
            attrText.lineSpacing = 24
            attrText.lineBreakMode = .byWordWrapping
            
            let keywordContainer = YYTextContainer()
            keywordContainer.size = CGSize(width: kScreenWidth - 18, height: CGFloat.greatestFiniteMagnitude)
            let keywordLayout = YYTextLayout(container: keywordContainer, text: attrText)
            if (keywordLayout?.textBoundingSize.height ?? 0) > height {
                if index != 0 {
                    attrText.insertString("\n", at: UInt(attrText.length - keywordText.length))
                }
                height = keywordLayout?.textBoundingSize.height ?? 0
            }
        }
        
        keywordsAttrText = attrText.fate.clone()
    }
}

typealias U17HotSearchCellDisplay = UIViewSingleDisplay<U17HotSearchCellPresenter>
