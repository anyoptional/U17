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
    let backgroundImageURL: URL?
    let backgroundImageColor: UIColor
    let titleText: String
    let detailAttributedText: NSAttributedString?
    let tagAttributedText: NSAttributedString?
    
    init(rawValue: ComicStaticDetailResp.DataBean.ReturnDataBean) {
        
        let comic = rawValue.comic
        
        // cover不存在时取ori
        let coverURLString = comic?.cover
        let originalURLString = (comic?.ori).filterNil()
        imageURL = URL(string: coverURLString.filterNil(originalURLString))
        
        // wide不存在取cover，cover也没有取ori
        let wideURLString = comic?.wideCover
        if wideURLString?.isBlank ?? true {
            backgroundImageURL = imageURL
        } else {
            backgroundImageURL = URL(string: wideURLString.filterNil())
        }
        
        if let wideColorString = comic?.wideColor, let color = UIColor(hexString: wideColorString) {
            backgroundImageColor = color
        } else {
            backgroundImageColor = UIColor(white: 0.84, alpha: 0.36)
        }        

        let comicName = comic?.name
        titleText = comicName.filterNil()
        
        // TODO: 寻找表示热度值的字段
        let authorNmae = comic?.author?.name
        let detailText = authorNmae.filterNil() + "\n\n" + "热度值 281.9万"
        detailAttributedText = NSAttributedString(string: detailText, attributes: [.foregroundColor : UIColor.white,
                                                                                   .font : UIFont.systemFont(ofSize: 14)])
        
        let attrText = NSMutableAttributedString()
        for tagName in (comic?.theme_ids).filterNil([]) {
            let tagFillColor = U17def.green_EAF7FA
            let tagText = NSMutableAttributedString(string: tagName)
            tagText.insertString("   ", at: 0)
            tagText.appendString("   ")
            tagText.color = U17def.green_5AC5D6
            tagText.font = UIFont.systemFont(ofSize: 13)
            tagText.setTextBinding(YYTextBinding(deleteConfirm: false), range: (tagText.string as NSString).rangeOfAll())
            let border = YYTextBorder(fill: tagFillColor, cornerRadius: 10.5)
            border.lineJoin = .bevel
            border.insets = UIEdgeInsets(top: -4, left: -6, bottom: -4, right: -6)
            tagText.setTextBackgroundBorder(border, range: (tagText.string as NSString).range(of: tagName))
            attrText.append(tagText)
        }
        
        tagAttributedText = attrText.fate.clone()
    }
}

typealias ComicPreviewViewDisplay = UIViewSingleDisplay<ComicPreviewViewPresenter>
