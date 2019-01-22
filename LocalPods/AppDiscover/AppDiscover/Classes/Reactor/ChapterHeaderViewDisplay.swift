//
//  ChapterHeaderViewDisplay.swift
//  AppDiscover
//
//  Created by Archer on 2019/1/22.
//

import Fate
import YYKit
import RxBindable

struct ChapterHeaderViewPresenter: Presentable {
    
    let descLabelHeight: CGFloat
    let showsFullDescription: Bool
    let descAttrText: NSAttributedString
    let totalAttributedText: NSAttributedString?
    let height: CGFloat
    
    init(rawValue: ComicStaticDetailResp.DataBean.ReturnDataBean) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = .left
        paragraphStyle.lineBreakMode = .byWordWrapping
        descAttrText = NSAttributedString(string: (rawValue.comic?.descriptor).filterNil(), attributes: [.paragraphStyle : paragraphStyle, .foregroundColor : U17def.gray_777777, .font : UIFont.systemFont(ofSize: 12)])
                
        let container = YYTextContainer(size: CGSize(width: (kScreenWidth - 26).toDouble(), height: Double.greatestFiniteMagnitude))
        let layout = YYTextLayout(container: container, text: descAttrText)
        let rowCount = layout?.rowCount ?? 0
        // 3行以内允许完全显示
        if rowCount <= 3 {
            showsFullDescription = true
            // 莫要忘记行间距
            descLabelHeight = (layout?.textBoundingSize.height ?? 0) + CGFloat((rowCount - 1) * 4)
        } else {
            showsFullDescription = rawValue.showsFullDescription
            if showsFullDescription {
                descLabelHeight = (layout?.textBoundingSize.height ?? 0) + CGFloat((rowCount - 1) * 4)
            } else {
                descLabelHeight = (layout?.lines.prefix(3).reduce(1, { $0 + $1.height }) ?? 0) + 2 * 4
            }
        }
        
        let state: String
        if let tagList = rawValue.comic?.tagList, tagList.count >= 2 {
            state = tagList[1]
        } else {
            state = "连载中"
        }
        let count = "共\(rawValue.chapter_list.filterNil([]).count)话"
        let text = state + " " + count
        let attrText = NSMutableAttributedString(string: text, attributes: [.foregroundColor : U17def.black_333333, .font : UIFont.boldSystemFont(ofSize: 18)])
        attrText.addAttributes([.foregroundColor : U17def.gray_888888, .font : UIFont.boldSystemFont(ofSize: 14)], range: (text as NSString).range(of: count))
        totalAttributedText = attrText.fate.clone()
        
        // 根据布局计算而来
        height = 20 + 40 + 20 + descLabelHeight + 15 + 20 + 15
    }
}

typealias ChapterHeaderViewDisplay = UIViewSingleDisplay<ChapterHeaderViewPresenter>
