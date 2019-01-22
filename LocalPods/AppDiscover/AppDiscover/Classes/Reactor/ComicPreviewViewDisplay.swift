//
//  ComicPreviewViewDisplay.swift
//  AppDiscover
//
//  Created by Archer on 2019/1/4.
//

import Fate
import YYKit
import RxBindable

struct ComicPreviewViewPresenter: Presentable {
    
    let imageURL: URL?
    let titleText: String
    let detailAttributedText: NSAttributedString?
    let tagAttributedText: NSAttributedString?
    
    init(rawValue: ComicStaticDetailResp.DataBean.ReturnDataBean) {
        
        let comic = rawValue.comic
        
        // cover不存在时取ori
        let coverURLString = comic?.cover
        let originalURLString = (comic?.ori).filterNil()
        imageURL = URL(string: coverURLString.filterNil(originalURLString))
    
        let comicName = comic?.name
        titleText = comicName.filterNil()
        
        // TODO: 寻找表示热度值的字段
        let authorNmae = (comic?.author?.name).filterNil()
        let detailText = authorNmae + "\n\n" + "热度值 281.9万"
        let detailAttrText = NSMutableAttributedString(string: detailText, attributes: [.foregroundColor : UIColor.white,
                                                                                        .font : UIFont.systemFont(ofSize: 14)])
        detailAttrText.setTextHighlight((authorNmae as NSString).rangeOfAll(), color: nil, backgroundColor: nil, userInfo: nil)
        detailAttrText.lineSpacing = -3
        detailAttributedText = detailAttrText.fate.clone()
        
        // 最多取三个
        let attrText = NSMutableAttributedString()
        for tagName in (comic?.theme_ids).filterNil([]).prefix(3) {
            let tagFillColor = U17def.green_EAF7FA
            let tagText = NSMutableAttributedString(string: tagName)
            tagText.insertString("    ", at: 0)
            tagText.appendString("    ")
            tagText.color = U17def.green_5AC5D6
            tagText.font = UIFont.systemFont(ofSize: 13)
            tagText.setTextBinding(YYTextBinding(deleteConfirm: false), range: (tagText.string as NSString).rangeOfAll())
            let border = YYTextBorder(fill: tagFillColor, cornerRadius: 10.5)
            border.lineJoin = .bevel
            border.insets = UIEdgeInsets(top: -4, left: -6, bottom: -4, right: -6)
            tagText.setTextBackgroundBorder(border, range: (tagText.string as NSString).range(of: tagName))
            tagText.setTextHighlight((tagText.string as NSString).rangeOfAll(), color: nil, backgroundColor: nil, userInfo: nil)
            attrText.append(tagText)
        }
        
        tagAttributedText = attrText.fate.clone()
    }
}

typealias ComicPreviewViewDisplay = UIViewSingleDisplay<ComicPreviewViewPresenter>
